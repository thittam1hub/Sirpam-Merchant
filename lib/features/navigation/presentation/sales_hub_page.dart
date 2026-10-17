import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes.dart';
import '../../../core/l10n/l10n_extension.dart';
import '../../../core/theme/neu_theme.dart';
import '../../../core/widgets/neu.dart';
import '../../../core/widgets/neu_chrome.dart';

class SalesHubPage extends StatelessWidget {
  const SalesHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      (
        Icons.bolt_rounded,
        l10n.quickSaleTitle,
        l10n.quickSaleSubtitle,
        AppRoutes.quickSale(),
      ),
      (
        Icons.qr_code_2_rounded,
        l10n.paymentQrTitle,
        l10n.paymentQrSubtitle,
        AppRoutes.paymentQr(),
      ),
      (
        Icons.schedule_rounded,
        l10n.udhaarTitle,
        l10n.udhaarSubtitle,
        AppRoutes.udhaar(),
      ),
      (
        Icons.volume_up_rounded,
        l10n.soundboxTitle,
        l10n.soundboxSubtitle,
        AppRoutes.soundbox(),
      ),
    ];
    return Scaffold(
      backgroundColor: NeuColors.canvas,
      appBar: NeuAppBar(title: l10n.navSales),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 32),
        children: [
          for (final item in items)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: NeuBox(
                onTap: () => context.push(item.$4),
                child: Row(
                  children: [
                    Icon(item.$1, size: 28, color: NeuColors.accentDark),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.$2,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: NeuColors.ink,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.$3,
                            style: TextStyle(
                              fontSize: 13,
                              color: NeuColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: NeuColors.inkSoft,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
