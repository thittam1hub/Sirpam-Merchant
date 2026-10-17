/// Printable receipt model.
///
/// Deliberately free of localisation and of Flutter: the caller fills the
/// labels from the ARB catalogs, so the same struct renders to plain text,
/// ESC/POS bytes and PDF without any of them knowing about the app.
library;

class ReceiptLine {
  final String name;
  final int qty;
  final int totalPaise;

  const ReceiptLine(
      {required this.name, required this.qty, required this.totalPaise});
}

class ReceiptTender {
  final String label;
  final int amountPaise;

  const ReceiptTender({required this.label, required this.amountPaise});
}

/// One GST rate's worth of the bill, ready to print as a slab row.
class ReceiptTaxSlab {
  /// Rate as printed: `5`, `12.5`.
  final String rateLabel;

  /// Half the rate, printed against CGST and SGST.
  final String halfRateLabel;
  final int taxablePaise;
  final int cgstPaise;
  final int sgstPaise;
  final int igstPaise;

  const ReceiptTaxSlab({
    required this.rateLabel,
    required this.taxablePaise,
    this.halfRateLabel = '',
    this.cgstPaise = 0,
    this.sgstPaise = 0,
    this.igstPaise = 0,
  });
}

/// Every caption printed on paper, supplied already translated.
class ReceiptLabels {
  final String bill;
  final String token;
  final String table;
  final String subtotal;
  final String discount;
  final String tax;
  final String rounding;
  final String total;
  final String paid;
  final String balance;
  final String reprint;
  final String thanks;
  final String taxable;
  final String cgst;
  final String sgst;
  final String igst;

  const ReceiptLabels({
    required this.bill,
    required this.token,
    required this.table,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.rounding,
    required this.total,
    required this.paid,
    required this.balance,
    required this.reprint,
    required this.thanks,
    this.taxable = 'Taxable',
    this.cgst = 'CGST',
    this.sgst = 'SGST',
    this.igst = 'IGST',
  });
}

class ReceiptData {
  final String shopName;
  final String shopLine;
  final String gstin;
  final String fssai;
  final String billNumber;
  final String dateText;
  final int token;
  final String tableLabel;
  final String customer;
  final List<ReceiptLine> lines;
  final int subtotalPaise;
  final int discountPaise;
  final int taxPaise;
  final int roundingPaise;
  final int totalPaise;

  /// GST slab table for a registered shop; empty leaves the bill as before.
  final List<ReceiptTaxSlab> slabs;
  final List<ReceiptTender> tenders;
  final int balancePaise;
  final bool reprint;
  final String upiUri;

  /// Optional "tell us how it was" link printed as a small QR under the bill.
  final String feedbackUrl;

  /// Caption printed above the feedback QR, already translated.
  final String feedbackLabel;
  final ReceiptLabels labels;

  const ReceiptData({
    required this.shopName,
    required this.billNumber,
    required this.dateText,
    required this.lines,
    required this.subtotalPaise,
    required this.totalPaise,
    required this.labels,
    this.shopLine = '',
    this.gstin = '',
    this.fssai = '',
    this.token = 0,
    this.tableLabel = '',
    this.customer = '',
    this.discountPaise = 0,
    this.taxPaise = 0,
    this.roundingPaise = 0,
    this.slabs = const [],
    this.tenders = const [],
    this.balancePaise = 0,
    this.reprint = false,
    this.upiUri = '',
    this.feedbackUrl = '',
    this.feedbackLabel = '',
  });
}

/// Character columns for the two thermal roll sizes sold in India.
enum PaperWidth { mm58, mm80 }

int columnsFor(PaperWidth width) => width == PaperWidth.mm58 ? 32 : 48;

PaperWidth paperWidthFrom(String? raw) =>
    raw == '80' ? PaperWidth.mm80 : PaperWidth.mm58;

String paperWidthLabel(PaperWidth width) =>
    width == PaperWidth.mm58 ? '58 mm' : '80 mm';
