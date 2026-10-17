/// Public-facing shop settings: what the QR menu shows and how it is reached.
library;

/// Another cloud shop the same owner runs. Only the link name and the owner
/// key are kept — enough to read that shop's totals, nothing else.
class LinkedShop {
  final String slug;
  final String shopKey;
  final String label;

  const LinkedShop({
    required this.slug,
    required this.shopKey,
    this.label = '',
  });

  Map<String, dynamic> toJson() =>
      {'slug': slug, 'shopKey': shopKey, 'label': label};

  static LinkedShop? tryFromJson(Map<String, dynamic> j) {
    final slug = j['slug'];
    final key = j['shopKey'];
    if (slug is! String || slug.isEmpty || key is! String || key.isEmpty) {
      return null;
    }
    return LinkedShop(
      slug: slug,
      shopKey: key,
      label: j['label'] as String? ?? '',
    );
  }
}

class ShopConfig {
  /// Trading name printed on receipts and shown at the top of the QR menu.
  final String shopName;

  /// Street address printed on receipts and shown on the QR menu.
  final String address;

  /// Contact number printed on receipts.
  final String phone;

  /// FSSAI licence number printed on receipts (food business).
  final String fssai;

  /// URL segment of the hosted menu: `…/m/<slug>?t=<table>`.
  final String slug;

  /// Base URL the table QR codes point at (the published web build).
  final String menuBaseUrl;

  /// Number of table / counter QR codes to print.
  final int tableCount;

  /// Product ids published to the customer menu. Empty means "everything with
  /// a price", so a new shop is usable before curating.
  final List<String> publishedIds;

  /// Ids temporarily marked sold out; they grey out on the customer menu.
  final List<String> soldOutIds;

  /// Master switch for accepting QR orders.
  final bool acceptOnlineOrders;

  /// Optional GST rate applied to bills; 0 keeps bills tax-free.
  final double taxPercent;

  /// GSTIN printed on the bill header; empty for an unregistered shop.
  final String gstin;

  /// True when the shop is GST registered: bills then print the CGST/SGST
  /// slab table and per-item rates are used.
  final bool gstRegistered;

  /// True when the menu prices already contain the tax (the usual Indian
  /// shop-front practice); false adds the tax on top of the subtotal.
  final bool priceIncludesTax;

  /// Secret that authenticates this device against the cloud shop RPCs. Empty
  /// keeps the board local-only.
  final String shopKey;

  /// Cloud shop row id returned by registration; informational.
  final String remoteShopId;

  /// Master switch for cloud order sync.
  final bool cloudSync;

  /// How food reaches the customer: `table`, `self` or `takeaway`.
  final String serviceMode;

  /// When the customer pays: `before` (confirm after paying) or `after`.
  final String payMode;

  /// Customer may tap "Call staff" from the table.
  final bool allowCallStaff;

  /// Customer may tap "Ask for the bill" from the table.
  final bool allowRequestBill;

  /// Other cloud shops this owner runs, for the all-shops totals view.
  final List<LinkedShop> otherShops;

  const ShopConfig({
    this.shopName = '',
    this.address = '',
    this.phone = '',
    this.fssai = '',
    this.slug = '',
    this.menuBaseUrl = '',
    this.tableCount = 6,
    this.publishedIds = const [],
    this.soldOutIds = const [],
    this.acceptOnlineOrders = true,
    this.taxPercent = 0,
    this.gstin = '',
    this.gstRegistered = false,
    this.priceIncludesTax = true,
    this.shopKey = '',
    this.remoteShopId = '',
    this.cloudSync = false,
    this.serviceMode = 'table',
    this.payMode = 'after',
    this.allowCallStaff = true,
    this.allowRequestBill = true,
    this.otherShops = const [],
  });

  /// Table service is the only mode where a customer can call staff over.
  bool get tableService => serviceMode == 'table';

  bool get payFirst => payMode == 'before';

  bool get callStaffEnabled => tableService && allowCallStaff;

  bool get requestBillEnabled => tableService && allowRequestBill;


  /// True when this shop can talk to the cloud board.
  bool get cloudReady => cloudSync && slug.isNotEmpty && shopKey.length >= 16;

  bool isPublished(String productId) =>
      publishedIds.isEmpty || publishedIds.contains(productId);

  bool isSoldOut(String productId) => soldOutIds.contains(productId);

  /// Menu link for a table; `table` 0 means the counter QR.
  String menuUrl(int table) {
    final base = menuBaseUrl.isEmpty ? 'https://sirpam.app' : menuBaseUrl;
    final trimmed = base.endsWith('/') ? base.substring(0, base.length - 1) : base;
    final shop = slug.isEmpty ? 'shop' : slug;
    return table <= 0 ? '$trimmed/m/$shop' : '$trimmed/m/$shop?t=$table';
  }

  ShopConfig copyWith({
    String? shopName,
    String? address,
    String? phone,
    String? fssai,
    String? slug,
    String? menuBaseUrl,
    int? tableCount,
    List<String>? publishedIds,
    List<String>? soldOutIds,
    bool? acceptOnlineOrders,
    double? taxPercent,
    String? gstin,
    bool? gstRegistered,
    bool? priceIncludesTax,
    String? shopKey,
    String? remoteShopId,
    bool? cloudSync,
    String? serviceMode,
    String? payMode,
    bool? allowCallStaff,
    bool? allowRequestBill,
    List<LinkedShop>? otherShops,
  }) =>
      ShopConfig(
        shopName: shopName ?? this.shopName,
        address: address ?? this.address,
        phone: phone ?? this.phone,
        fssai: fssai ?? this.fssai,
        slug: slug ?? this.slug,
        menuBaseUrl: menuBaseUrl ?? this.menuBaseUrl,
        tableCount: tableCount ?? this.tableCount,
        publishedIds: publishedIds ?? this.publishedIds,
        soldOutIds: soldOutIds ?? this.soldOutIds,
        acceptOnlineOrders: acceptOnlineOrders ?? this.acceptOnlineOrders,
        taxPercent: taxPercent ?? this.taxPercent,
        gstin: gstin ?? this.gstin,
        gstRegistered: gstRegistered ?? this.gstRegistered,
        priceIncludesTax: priceIncludesTax ?? this.priceIncludesTax,
        shopKey: shopKey ?? this.shopKey,
        remoteShopId: remoteShopId ?? this.remoteShopId,
        cloudSync: cloudSync ?? this.cloudSync,
        serviceMode: serviceMode ?? this.serviceMode,
        payMode: payMode ?? this.payMode,
        allowCallStaff: allowCallStaff ?? this.allowCallStaff,
        allowRequestBill: allowRequestBill ?? this.allowRequestBill,
        otherShops: otherShops ?? this.otherShops,
      );


  Map<String, dynamic> toJson() => {
        'shopName': shopName,
        'address': address,
        'phone': phone,
        'fssai': fssai,
        'slug': slug,
        'baseUrl': menuBaseUrl,
        'tables': tableCount,
        'published': publishedIds,
        'soldOut': soldOutIds,
        'online': acceptOnlineOrders,
        'taxPct': taxPercent,
        'gstin': gstin,
        'gstReg': gstRegistered,
        'priceInclTax': priceIncludesTax,
        'shopKey': shopKey,
        'remoteShopId': remoteShopId,
        'cloudSync': cloudSync,
        'serviceMode': serviceMode,
        'payMode': payMode,
        'callStaff': allowCallStaff,
        'requestBill': allowRequestBill,
        'otherShops': [for (final s in otherShops) s.toJson()],
      };


  static List<String> _ids(Object? raw) => raw is List
      ? [for (final e in raw) if (e is String) e]
      : const <String>[];

  factory ShopConfig.fromJson(Map<String, dynamic> j) => ShopConfig(
        shopName: j['shopName'] as String? ?? '',
        address: j['address'] as String? ?? '',
        phone: j['phone'] as String? ?? '',
        fssai: j['fssai'] as String? ?? '',
        slug: j['slug'] as String? ?? '',
        menuBaseUrl: j['baseUrl'] as String? ?? '',
        tableCount: (j['tables'] as num?)?.toInt().clamp(0, 99) ?? 6,
        publishedIds: _ids(j['published']),
        soldOutIds: _ids(j['soldOut']),
        acceptOnlineOrders: j['online'] != false,
        taxPercent: (j['taxPct'] as num?)?.toDouble() ?? 0,
        gstin: j['gstin'] as String? ?? '',
        gstRegistered: j['gstReg'] == true,
        priceIncludesTax: j['priceInclTax'] != false,
        shopKey: j['shopKey'] as String? ?? '',
        remoteShopId: j['remoteShopId'] as String? ?? '',
        cloudSync: j['cloudSync'] == true,
        serviceMode: const {'table', 'self', 'takeaway'}
                .contains(j['serviceMode'])
            ? j['serviceMode'] as String
            : 'table',
        payMode: j['payMode'] == 'before' ? 'before' : 'after',
        allowCallStaff: j['callStaff'] != false,
        allowRequestBill: j['requestBill'] != false,
        otherShops: _linked(j['otherShops']),
      );

  static List<LinkedShop> _linked(Object? raw) => raw is List
      ? [
          for (final e in raw)
            if (e is Map)
              ...[LinkedShop.tryFromJson(e.cast<String, dynamic>())]
                  .whereType<LinkedShop>(),
        ]
      : const <LinkedShop>[];

}
