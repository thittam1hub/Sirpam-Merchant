import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/app_back_button.dart';
import '../../../core/widgets/neu.dart';

/// In-app guide: how a street vendor gets a business UPI account, where the
/// merchant id and secret come from, and how to link the phone soundbox.
class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return DetailScaffold(
      title: l10n.helpTitle,
      subtitle: l10n.helpSubtitle,
      fallbackLocation: AppPaths.soundbox,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 32),
        children: [
          _Section(
            title: l10n.helpWhyTitle,
            lines: [l10n.helpWhyBody],
          ),
          _Section(
            title: l10n.helpDocsTitle,
            lines: [
              l10n.helpDocsAadhaar,
              l10n.helpDocsPan,
              l10n.helpDocsBank,
              l10n.helpDocsShop,
            ],
          ),
          _Section(
            title: l10n.helpRegisterTitle,
            lines: [
              l10n.helpRegisterStep1,
              l10n.helpRegisterStep2,
              l10n.helpRegisterStep3,
              l10n.helpRegisterStep4,
            ],
          ),
          _Section(
            title: l10n.helpKeysTitle,
            lines: [
              l10n.helpKeysPhonePe,
              l10n.helpKeysPaytm,
              l10n.helpKeysCallback,
            ],
          ),
          _Section(
            title: l10n.helpLinkTitle,
            lines: [
              l10n.helpLinkStep1,
              l10n.helpLinkStep2,
              l10n.helpLinkStep3,
            ],
          ),
          _Section(
            title: l10n.helpSafetyTitle,
            lines: [l10n.helpSafetyBody],
          ),
          const SizedBox(height: 8),
          NeuButton(
            onPressed: () => context.push(AppRoutes.merchant()),
            child: Text(l10n.registerBusiness,
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: NeuColors.accentDark)),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> lines;
  const _Section({required this.title, required this.lines});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: NeuBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: NeuColors.ink)),
              const SizedBox(height: 10),
              for (final line in lines)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6, right: 10),
                        child: Icon(Icons.circle,
                            size: 7, color: NeuColors.accentDark),
                      ),
                      Expanded(
                        child: Text(line,
                            style: TextStyle(
                                fontSize: 14,
                                height: 1.45,
                                color: NeuColors.inkSoft)),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}
