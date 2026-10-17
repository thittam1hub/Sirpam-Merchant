import 'package:intl/intl.dart';

import '../../../core/l10n/l10n_extension.dart';
import '../../../core/network/share_links.dart';
import '../../../core/settings/settings_controller.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../feedback/domain/feedback_link.dart';
import '../../ledger/domain/sale.dart';
import '../../orders/domain/order.dart';
import '../../orders/domain/shop_config.dart';
import '../../printing/domain/receipt.dart';
import '../../profile/domain/vendor_profile.dart';
import '../domain/bill.dart';

/// Assembles the printable receipt from app state. Kept out of the widgets so
/// printing, sharing and reprinting all produce byte-identical paper.
class ReceiptBuilder {
  const ReceiptBuilder._();

  static String _tenderLabel(AppLocalizations l10n, SaleMode mode) =>
      switch (mode) {
        SaleMode.cash => l10n.modeCash,
        SaleMode.upi => l10n.modeUpi,
        SaleMode.credit => l10n.modeCredit,
      };

  static ReceiptData build({
    required AppLocalizations l10n,
    required Bill bill,
    required ShopOrder? order,
    required VendorSettings settings,
    required VendorProfile profile,
    required ShopConfig shop,
    String reviewUrl = '',
    bool reprint = false,
  }) {
    final lines = <ReceiptLine>[
      for (final l in order?.lines ?? const <OrderLine>[])
        ReceiptLine(name: l.name, qty: l.qty, totalPaise: l.totalPaise),
    ];
    final upiUri = settings.upiVpa.isEmpty
        ? ''
        : ShareLinks.upiCollect(
            vpa: settings.upiVpa,
            payeeName: settings.stallName,
            amountRupees: bill.totalPaise / 100,
            note: bill.number,
          ).toString();

    return ReceiptData(
      shopName:
          settings.stallName.isEmpty ? l10n.appTitle : settings.stallName,
      shopLine: [profile.marketArea, profile.district]
          .where((v) => v.isNotEmpty)
          .join(', '),
      gstin: shop.gstin,
      fssai: profile.fssaiNumber,
      billNumber: bill.number,
      dateText: DateFormat('dd/MM/yy HH:mm')
          .format(DateTime.fromMillisecondsSinceEpoch(bill.ts)),
      token: order?.token ?? 0,
      tableLabel: order?.tableLabel ?? '',
      customer: bill.customer,
      lines: lines,
      subtotalPaise: bill.subtotalPaise,
      discountPaise: bill.discountPaise,
      taxPaise: bill.taxPaise,
      roundingPaise: bill.roundingPaise,
      totalPaise: bill.totalPaise,
      slabs: [
        for (final s in bill.slabs)
          ReceiptTaxSlab(
            rateLabel: s.rateLabel,
            halfRateLabel: s.halfRateLabel,
            taxablePaise: s.taxablePaise,
            cgstPaise: s.cgstPaise,
            sgstPaise: s.sgstPaise,
            igstPaise: s.igstPaise,
          ),
      ],
      tenders: [
        for (final p in bill.payments)
          if (p.amountPaise != 0)
            ReceiptTender(
                label: _tenderLabel(l10n, p.mode), amountPaise: p.amountPaise),
      ],
      balancePaise: BillMath.balance(bill.totalPaise, bill.payments),
      reprint: reprint,
      upiUri: upiUri,
      feedbackUrl: feedbackUrl(
        baseUrl: shop.menuBaseUrl,
        shopName: shop.shopName.isEmpty ? settings.stallName : shop.shopName,
        phone: shop.phone,
        reviewUrl: reviewUrl,
      ),
      feedbackLabel: l10n.receiptFeedbackLine,
      labels: ReceiptLabels(
        bill: l10n.billNumberLabel,
        token: l10n.orderTokenShort,
        table: l10n.orderTable,
        subtotal: l10n.billSubtotal,
        discount: l10n.billDiscount,
        tax: l10n.billTax,
        rounding: l10n.billRounding,
        total: l10n.billTotal,
        paid: l10n.billPaid,
        balance: l10n.billBalance,
        reprint: l10n.billReprint,
        thanks: l10n.billThanks,
        taxable: l10n.billTaxable,
        cgst: l10n.billCgst,
        sgst: l10n.billSgst,
        igst: l10n.billIgst,
      ),
    );
  }
}
