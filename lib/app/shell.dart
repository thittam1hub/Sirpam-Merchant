import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/l10n/l10n_extension.dart';
import '../core/layout/responsive.dart';
import '../core/theme/neu_theme.dart';
import '../core/widgets/neu_chrome.dart';
import '../core/widgets/neu_side_nav.dart';
import '../features/access/application/access_controller.dart';
import '../features/backup/application/backup_controller.dart';
import '../features/devices/application/device_controller.dart';
import '../features/devices/domain/device_link.dart';
import '../features/profile/application/profile_controller.dart';
import 'navigation_registry.dart';
import 'routes.dart';

class _ShellTab {
  final AppNavDestination destination;
  final int? branch;
  const _ShellTab(this.destination, this.branch);
}

/// Work-focused adaptive shell: five stable owner tabs on phones and the full,
/// permission-aware information architecture on larger screens.
class AppShell extends ConsumerStatefulWidget {
  final StatefulNavigationShell shell;
  const AppShell({super.key, required this.shell});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  bool _desktopExpanded = true;

  @override
  void initState() {
    super.initState();
    // Once a day, quietly send a copy of the books to the shop's own cloud
    // space, so a lost or broken phone does not lose the shop's history.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(ref.read(backupProvider.notifier).backupToCloudIfDue());
    });
  }

  void _select(_ShellTab tab) {
    final branch = tab.branch;
    if (branch == null) {
      context.go(tab.destination.path);
      return;
    }
    widget.shell.goBranch(
      branch,
      initialLocation: branch == widget.shell.currentIndex,
    );
  }

  List<_ShellTab> _tabs(
    DeviceLink link,
    bool usesInventory,
    AccessState access,
  ) {
    if (!link.paired) {
      return [
        _ShellTab(AppNavigationRegistry.byId(AppNavId.home), 0),
        _ShellTab(AppNavigationRegistry.byId(AppNavId.orders), 1),
        _ShellTab(AppNavigationRegistry.byId(AppNavId.sales), 2),
        _ShellTab(
          AppNavigationRegistry.byId(
            usesInventory ? AppNavId.stock : AppNavId.credit,
          ),
          usesInventory ? 3 : null,
        ),
        _ShellTab(AppNavigationRegistry.byId(AppNavId.more), 4),
      ];
    }

    final candidates = switch (link.role) {
      DeviceRole.waiter => const [(AppNavId.menu, 5), (AppNavId.orders, 1)],
      DeviceRole.kitchen => const [(AppNavId.kitchen, 6)],
      DeviceRole.counter => const [(AppNavId.orders, 1), (AppNavId.sales, 2)],
    };
    final tabs = <_ShellTab>[];
    for (final candidate in candidates) {
      final destination = AppNavigationRegistry.byId(candidate.$1);
      final permission = destination.permission;
      if (permission == null || access.can(permission)) {
        tabs.add(_ShellTab(destination, candidate.$2));
      }
    }
    final extras = AppNavigationRegistry.visible(
      owner: false,
      usesInventory: usesInventory,
      role: link.role,
      can: access.can,
    ).where((item) => !tabs.any((tab) => tab.destination.id == item.id));
    if (extras.isNotEmpty) {
      tabs.add(_ShellTab(AppNavigationRegistry.byId(AppNavId.more), 4));
    }
    return tabs.isEmpty
        ? [
            _ShellTab(
              AppNavigationRegistry.byId(_homeId(link.role)),
              _homeBranch(link.role),
            ),
          ]
        : tabs.take(5).toList();
  }

  static AppNavId _homeId(DeviceRole role) => switch (role) {
        DeviceRole.waiter => AppNavId.menu,
        DeviceRole.kitchen => AppNavId.kitchen,
        DeviceRole.counter => AppNavId.orders,
      };

  static int _homeBranch(DeviceRole role) => switch (role) {
        DeviceRole.waiter => 5,
        DeviceRole.kitchen => 6,
        DeviceRole.counter => 1,
      };

  @override
  Widget build(BuildContext context) {
    final access = ref.watch(accessProvider);
    final link = ref.watch(deviceProvider).link;
    final profile = ref.watch(profileProvider);
    final tabs = _tabs(link, profile.usesInventory, access);
    final body = ResponsiveContent.wide(child: widget.shell);

    return ResponsiveBuilder(
      builder: (context, form) {
        if (form == FormFactor.mobile) {
          final active = tabs.indexWhere(
            (tab) =>
                tab.branch != null && tab.branch == widget.shell.currentIndex,
          );
          return Scaffold(
            backgroundColor: NeuColors.canvas,
            body: body,
            bottomNavigationBar: tabs.length <= 1
                ? null
                : NeuBottomNav(
                    currentIndex: active < 0 ? 0 : active,
                    onSelected: (index) => _select(tabs[index]),
                    items: [
                      for (final tab in tabs)
                        NeuNavItem(
                          icon: tab.destination.icon,
                          selectedIcon: tab.destination.selectedIcon,
                          label: tab.destination.label(context),
                        ),
                    ],
                  ),
          );
        }

        final destinations = AppNavigationRegistry.visible(
          owner: !link.paired,
          usesInventory: profile.usesInventory,
          role: link.paired ? link.role : null,
          can: access.can,
        );
        final path = GoRouterState.of(context).uri.path;
        final extended = form == FormFactor.desktop && _desktopExpanded;
        return Scaffold(
          backgroundColor: NeuColors.canvas,
          body: Row(
            children: [
              NeuSideNav(
                extended: extended,
                onToggle: form == FormFactor.desktop
                    ? () => setState(() => _desktopExpanded = !_desktopExpanded)
                    : null,
                sections: [
                  for (final group in AppNavGroup.values)
                    if (destinations.any((item) => item.group == group))
                      NeuSideNavSection(
                        label: _groupLabel(context, group),
                        entries: [
                          for (final item in destinations.where(
                            (item) => item.group == group,
                          ))
                            NeuSideNavEntry(
                              item: NeuNavItem(
                                icon: item.icon,
                                selectedIcon: item.selectedIcon,
                                label: item.label(context),
                              ),
                              selected: _matches(path, item),
                              onTap: () => context.go(item.path),
                            ),
                        ],
                      ),
                ],
              ),
              Expanded(child: SafeArea(left: false, child: body)),
            ],
          ),
        );
      },
    );
  }

  bool _matches(String path, AppNavDestination item) {
    if (path == item.path || path.startsWith('${item.path}/')) return true;
    return switch (item.id) {
      AppNavId.orders => path.startsWith('/bill/'),
      AppNavId.stock => path == AppPaths.batches || path == AppPaths.suppliers,
      AppNavId.products => path.startsWith('${AppPaths.products}/'),
      AppNavId.credit => path == AppPaths.settle,
      _ => false,
    };
  }

  String _groupLabel(BuildContext context, AppNavGroup group) =>
      switch (group) {
        AppNavGroup.overview => context.l10n.navGroupOverview,
        AppNavGroup.sell => context.l10n.navGroupSell,
        AppNavGroup.inventory => context.l10n.menuInventory,
        AppNavGroup.operations => context.l10n.navGroupOperations,
        AppNavGroup.business => context.l10n.navGroupBusiness,
        AppNavGroup.team => context.l10n.navGroupTeam,
        AppNavGroup.grow => context.l10n.menuGrowSection,
        AppNavGroup.system => context.l10n.navGroupSystem,
      };
}
