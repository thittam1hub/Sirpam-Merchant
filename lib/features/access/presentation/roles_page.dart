import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';
import '../../products/presentation/inventory_widgets.dart';
import '../../profile/application/profile_controller.dart';
import '../../profile/domain/shop_type.dart';
import '../application/access_controller.dart';
import '../domain/permission.dart';
import '../domain/role.dart';
import '../domain/role_templates.dart';

/// Every role the owner has created, with what each one is allowed to touch.
class RolesPage extends ConsumerWidget {
  const RolesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final state = ref.watch(accessProvider);
    final roles = state.roles;
    final profile = ref.watch(profileProvider);
    final shopType = ShopType.tryParse(profile.shopType);
    final templates = roleTemplatesFor(shopType, profile.category);

    return DetailScaffold(
      title: l10n.rolesTitle,
      subtitle: l10n.rolesSubtitle,
      fallbackLocation: AppPaths.staff,
      actions: [
        NeuIconButton(
          icon: Icons.add_rounded,
          label: l10n.roleNew,
          onPressed: () => context.push(AppRoutes.roleNew()),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          NeuBox(
            inset: true,
            child: Text(l10n.rolesHint,
                style: TextStyle(color: NeuColors.inkSoft)),
          ),
          if (templates.isNotEmpty) ...[
            SectionTitle(l10n.roleSuggestionsTitle),
            NeuBox(
              inset: true,
              child: Text(l10n.roleSuggestionsHint,
                  style:
                      TextStyle(color: NeuColors.inkSoft, fontSize: 12)),
            ),
            const SizedBox(height: 10),
            for (final t in templates)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _roleTile(
                  context,
                  name: roleTemplateLabel(context, t.id),
                  note: '',
                  count: t.permissions.length,
                  locked: false,
                  onTap: () async {
                    final role = await ref
                        .read(accessProvider.notifier)
                        .saveRole(
                          name: roleTemplateLabel(context, t.id),
                          permissions: {...t.permissions},
                          maxDiscountPaise: t.maxDiscountPaise,
                          maxCreditPaise: t.maxCreditPaise,
                        );
                    if (context.mounted) {
                      unawaited(context.push(AppRoutes.role(role.id)));
                    }
                  },
                ),
              ),
          ],
          const SizedBox(height: 14),
          _roleTile(
            context,
            name: l10n.roleOwner,
            note: l10n.roleOwnerNote,
            count: Permission.values.length,
            locked: true,
            onTap: null,
          ),
          if (roles.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 14),
              child: NeuBox(
                inset: true,
                padding: const EdgeInsets.symmetric(vertical: 22),
                child: Center(
                    child: Text(l10n.rolesEmpty,
                        style: TextStyle(color: NeuColors.inkSoft))),
              ),
            ),
          for (final r in roles)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _roleTile(
                context,
                name: r.name,
                note: r.active ? r.note : l10n.roleInactive,
                count: r.permissions.length,
                locked: false,
                onTap: () => context.push(AppRoutes.role(r.id)),
              ),
            ),
          const SizedBox(height: 18),
          NeuTextButton(
            label: l10n.roleNew,
            color: NeuColors.accentDark,
            onPressed: () => context.push(AppRoutes.roleNew()),
          ),
        ],
      ),
    );
  }

  Widget _roleTile(
    BuildContext context, {
    required String name,
    required String note,
    required int count,
    required bool locked,
    VoidCallback? onTap,
  }) {
    final l10n = context.l10n;
    return NeuButton(
      onPressed: onTap ?? () {},
      child: Row(children: [
        Icon(locked ? Icons.verified_user_rounded : Icons.badge_outlined,
            color: locked ? NeuColors.accentDark : NeuColors.inkSoft),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800, color: NeuColors.ink)),
              if (note.isNotEmpty)
                Text(note,
                    style: TextStyle(
                        fontSize: 12, color: NeuColors.inkSoft)),
            ],
          ),
        ),
        StatusPill(l10n.rolePermissionCount('$count')),
      ]),
    );
  }
}

/// Create or edit one role: name, responsibility, permissions, money limits.
class RoleEditPage extends ConsumerStatefulWidget {
  final String roleId;
  const RoleEditPage({super.key, this.roleId = ''});

  @override
  ConsumerState<RoleEditPage> createState() => _RoleEditPageState();
}

class _RoleEditPageState extends ConsumerState<RoleEditPage> {
  final _name = TextEditingController();
  final _note = TextEditingController();
  final _discount = TextEditingController();
  final _credit = TextEditingController();
  final _refund = TextEditingController();
  Set<Permission> _granted = {};
  bool _loaded = false;
  bool _dirty = false;

  @override
  void dispose() {
    _name.dispose();
    _note.dispose();
    _discount.dispose();
    _credit.dispose();
    _refund.dispose();
    super.dispose();
  }

  void _load(ShopRole? role) {
    if (_loaded) return;
    _loaded = true;
    if (role == null) return;
    _name.text = role.name;
    _note.text = role.note;
    _granted = {...role.permissions};
    if (role.maxDiscountPaise > 0) {
      _discount.text = (role.maxDiscountPaise / 100).toStringAsFixed(0);
    }
    if (role.maxCreditPaise > 0) {
      _credit.text = (role.maxCreditPaise / 100).toStringAsFixed(0);
    }
    if (role.maxRefundPaise > 0) {
      _refund.text = (role.maxRefundPaise / 100).toStringAsFixed(0);
    }
  }

  int _paise(TextEditingController c) {
    final rupees = double.tryParse(c.text.trim()) ?? 0;
    return rupees <= 0 ? 0 : (rupees * 100).round();
  }

  Future<void> _save() async {
    await ref.read(accessProvider.notifier).saveRole(
          id: widget.roleId,
          name: _name.text,
          note: _note.text,
          permissions: _granted,
          maxDiscountPaise: _paise(_discount),
          maxCreditPaise: _paise(_credit),
          maxRefundPaise: _paise(_refund),
        );
    if (!mounted) return;
    _dirty = false;
    AppBackButton.popOrGo(context, AppPaths.roles);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(accessProvider);
    final role = state.roles.where((r) => r.id == widget.roleId).firstOrNull;
    final profile = ref.watch(profileProvider);
    final shopType = ShopType.tryParse(profile.shopType);
    final profileCategory = profile.category;
    _load(role);

    return DetailScaffold(
      title: role == null ? l10n.roleNew : role.name,
      subtitle: l10n.roleEditSubtitle,
      fallbackLocation: AppPaths.roles,
      isDirty: () => _dirty,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          LabeledField(
              label: l10n.roleName,
              controller: _name,
              onChanged: (_) => _dirty = true),
          LabeledField(
              label: l10n.roleNote,
              controller: _note,
              onChanged: (_) => _dirty = true),
          SectionTitle(l10n.roleLimits),
          LabeledField(
              label: l10n.roleMaxDiscount,
              controller: _discount,
              keyboard: TextInputType.number,
              onChanged: (_) => _dirty = true),
          LabeledField(
              label: l10n.roleMaxCredit,
              controller: _credit,
              keyboard: TextInputType.number,
              onChanged: (_) => _dirty = true),
          LabeledField(
              label: l10n.roleMaxRefund,
              controller: _refund,
              keyboard: TextInputType.number,
              onChanged: (_) => _dirty = true),
          NeuBox(
            inset: true,
            child: Text(l10n.roleLimitHint,
                style: TextStyle(color: NeuColors.inkSoft, fontSize: 12)),
          ),
          for (final area in PermissionArea.values) ...[
            if (relevantPermissions(shopType, profileCategory, area)
                .isNotEmpty)
              SectionTitle(areaLabel(context, area)),
            for (final p
                in relevantPermissions(shopType, profileCategory, area))
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: NeuButton(
                  onPressed: () => setState(() {
                    _dirty = true;
                    _granted.contains(p)
                        ? _granted.remove(p)
                        : _granted.add(p);
                  }),
                  child: Row(children: [
                    Icon(
                        _granted.contains(p)
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: _granted.contains(p)
                            ? NeuColors.accentDark
                            : NeuColors.inkSoft),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Text(permissionLabel(context, p),
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: NeuColors.ink))),
                  ]),
                ),
              ),
          ],
          const SizedBox(height: 16),
          ActionRow(children: [
            NeuTextButton(
                label: l10n.save,
                color: NeuColors.accentDark,
                onPressed: _save),
            if (role != null)
              NeuTextButton(
                label: l10n.roleDuplicate,
                onPressed: () async {
                  await ref
                      .read(accessProvider.notifier)
                      .duplicateRole(role.id, '${role.name} 2');
                  if (context.mounted) AppBackButton.popOrGo(context, AppPaths.roles);
                },
              ),
            if (role != null && role.active)
              NeuTextButton(
                label: l10n.roleDeactivate,
                color: NeuColors.warn,
                onPressed: () async {
                  await ref
                      .read(accessProvider.notifier)
                      .deactivateRole(role.id);
                  if (context.mounted) AppBackButton.popOrGo(context, AppPaths.roles);
                },
              ),
          ]),
        ],
      ),
    );
  }
}

String roleTemplateLabel(BuildContext context, String id) {
  final l10n = context.l10n;
  return switch (id) {
    'waiter' => l10n.tmplWaiter,
    'kitchen' => l10n.tmplKitchen,
    'cashier' => l10n.tmplCashier,
    'counter' => l10n.tmplCounter,
    'salesHelper' => l10n.tmplSalesHelper,
    'stockKeeper' => l10n.tmplStockKeeper,
    'jobAssistant' => l10n.tmplJobAssistant,
    'counterHelper' => l10n.tmplCounterHelper,
    _ => l10n.tmplAssistant,
  };
}

String areaLabel(BuildContext context, PermissionArea area) {
  final l10n = context.l10n;
  return switch (area) {
    PermissionArea.sales => l10n.areaSales,
    PermissionArea.orders => l10n.areaOrders,
    PermissionArea.billing => l10n.areaBilling,
    PermissionArea.credit => l10n.areaCredit,
    PermissionArea.stock => l10n.areaStock,
    PermissionArea.purchases => l10n.areaPurchases,
    PermissionArea.money => l10n.areaMoney,
    PermissionArea.customers => l10n.areaCustomers,
    PermissionArea.staff => l10n.areaStaff,
    PermissionArea.settings => l10n.areaSettings,
  };
}

String permissionLabel(BuildContext context, Permission p) {
  final l10n = context.l10n;
  return switch (p) {
    Permission.recordSale => l10n.permRecordSale,
    Permission.quickSale => l10n.permQuickSale,
    Permission.collectUpi => l10n.permCollectUpi,
    Permission.takeOrder => l10n.permTakeOrder,
    Permission.changeOrderStatus => l10n.permChangeOrderStatus,
    Permission.viewKitchen => l10n.permViewKitchen,
    Permission.editMenu => l10n.permEditMenu,
    Permission.makeBill => l10n.permMakeBill,
    Permission.giveDiscount => l10n.permGiveDiscount,
    Permission.voidBill => l10n.permVoidBill,
    Permission.reprintBill => l10n.permReprintBill,
    Permission.giveCredit => l10n.permGiveCredit,
    Permission.settleCredit => l10n.permSettleCredit,
    Permission.viewCredit => l10n.permViewCredit,
    Permission.viewStock => l10n.permViewStock,
    Permission.adjustStock => l10n.permAdjustStock,
    Permission.editProducts => l10n.permEditProducts,
    Permission.changePrice => l10n.permChangePrice,
    Permission.cookRecipe => l10n.permCookRecipe,
    Permission.recordExpense => l10n.permRecordExpense,
    Permission.manageSuppliers => l10n.permManageSuppliers,
    Permission.recordPurchase => l10n.permRecordPurchase,
    Permission.paySupplier => l10n.permPaySupplier,
    Permission.viewDayTotals => l10n.permViewDayTotals,
    Permission.viewProfit => l10n.permViewProfit,
    Permission.closeDay => l10n.permCloseDay,
    Permission.viewReports => l10n.permViewReports,
    Permission.viewCashBook => l10n.permViewCashBook,
    Permission.exportData => l10n.permExportData,
    Permission.viewCustomers => l10n.permViewCustomers,
    Permission.editCustomers => l10n.permEditCustomers,
    Permission.manageStaff => l10n.permManageStaff,
    Permission.markAttendance => l10n.permMarkAttendance,
    Permission.payWages => l10n.permPayWages,
    Permission.manageRoles => l10n.permManageRoles,
    Permission.viewAudit => l10n.permViewAudit,
    Permission.viewStaffReport => l10n.permViewStaffReport,
    Permission.editSettings => l10n.permEditSettings,
    Permission.editShop => l10n.permEditShop,
    Permission.managePrinters => l10n.permManagePrinters,
  };
}
