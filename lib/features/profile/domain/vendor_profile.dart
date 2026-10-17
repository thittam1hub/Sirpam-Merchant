/// Vendor business profile: what kind of vendor this is, where they operate,
/// and which compliance identifiers they hold. Tamil Nadu first; the district
/// list is a per-state data file so pan-India expansion adds files, not
/// structural changes.
library;

enum VendorCategory {
  /// Street cart / thalluvandi — mobile vendor.
  cart,

  /// Fixed stall / kadai — street-side or market stall.
  stall,

  /// Hotel / eatery / unavagam.
  hotel,

  /// Service vendor — barber, tailor, repair, ironing, etc.
  service;

  static VendorCategory? tryParse(String? raw) {
    for (final c in values) {
      if (c.name == raw) return c;
    }
    return null;
  }
}

class VendorProfile {
  final VendorCategory? category;

  /// Ready-made trade layout (`ShopType.name`); empty until the vendor picks
  /// one. Kept as a string so this file stays dependency-free.
  final String shopType;

  /// Free-text niche within the category (e.g. "Tea cart", "Tiffin center").
  final String niche;

  /// Tamil Nadu district (romanized proper noun, e.g. "Madurai").
  final String district;
  final String taluk;

  /// Market / area name, e.g. "Koyambedu".
  final String marketArea;
  final String fssaiNumber;
  final String udyamNumber;
  final String workingHours;

  /// True when the vendor sells goods that perish within the day.
  final bool sellsPerishables;

  const VendorProfile({
    this.category,
    this.shopType = '',
    this.niche = '',
    this.district = '',
    this.taluk = '',
    this.marketArea = '',
    this.fssaiNumber = '',
    this.udyamNumber = '',
    this.workingHours = '',
    this.sellsPerishables = false,
  });


  bool get isConfigured => category != null;

  /// Feature gating: service vendors have no stock; the home screen hides
  /// inventory shortcuts for them.
  bool get usesInventory => category != VendorCategory.service;

  /// Mobile vendors benefit most from GPS broadcasting.
  bool get isMobile => category == VendorCategory.cart;

  /// Food vendors are asked for an FSSAI number.
  bool get isFoodBusiness =>
      category == VendorCategory.hotel || category == VendorCategory.cart;

  VendorProfile copyWith({
    VendorCategory? Function()? category,
    String? shopType,
    String? niche,
    String? district,
    String? taluk,
    String? marketArea,
    String? fssaiNumber,
    String? udyamNumber,
    String? workingHours,
    bool? sellsPerishables,
  }) =>
      VendorProfile(
        category: category != null ? category() : this.category,
        shopType: shopType ?? this.shopType,
        niche: niche ?? this.niche,
        district: district ?? this.district,
        taluk: taluk ?? this.taluk,
        marketArea: marketArea ?? this.marketArea,
        fssaiNumber: fssaiNumber ?? this.fssaiNumber,
        udyamNumber: udyamNumber ?? this.udyamNumber,
        workingHours: workingHours ?? this.workingHours,
        sellsPerishables: sellsPerishables ?? this.sellsPerishables,
      );

  Map<String, dynamic> toJson() => {
        'category': category?.name,
        'shopType': shopType,
        'niche': niche,
        'district': district,
        'taluk': taluk,
        'marketArea': marketArea,
        'fssaiNumber': fssaiNumber,
        'udyamNumber': udyamNumber,
        'workingHours': workingHours,
        'sellsPerishables': sellsPerishables,
      };

  factory VendorProfile.fromJson(Map<String, dynamic> j) => VendorProfile(
        category: VendorCategory.tryParse(j['category'] as String?),
        shopType: j['shopType'] as String? ?? '',
        niche: j['niche'] as String? ?? '',
        district: j['district'] as String? ?? '',
        taluk: j['taluk'] as String? ?? '',
        marketArea: j['marketArea'] as String? ?? '',
        fssaiNumber: j['fssaiNumber'] as String? ?? '',
        udyamNumber: j['udyamNumber'] as String? ?? '',
        workingHours: j['workingHours'] as String? ?? '',
        sellsPerishables: j['sellsPerishables'] as bool? ?? false,
      );

}

/// Suggested niches per category. Proper-noun / romanized labels (like market
/// names); the vendor can always type their own free-text niche.
const nicheSuggestions = <VendorCategory, List<String>>{
  VendorCategory.cart: [
    'Tea & coffee cart',
    'Snacks cart (bajji/bonda)',
    'Tender coconut',
    'Sugarcane juice',
    'Fruit & vegetable cart',
    'Flower seller',
    'Fish cart',
    'Ice cream cart',
    'Ironing cart',
    'Cobbler / key maker',
  ],
  VendorCategory.stall: [
    'Vegetable stall',
    'Fruit stall',
    'Flower stall',
    'Tea shop',
    'Pan shop',
    'Tiffin stall',
    'Fish & meat stall',
    'Newspaper stand',
    'Tailoring shop',
    'Petty shop',
    'Bakery counter',
    'Mobile recharge',
  ],
  VendorCategory.hotel: [
    'Mess',
    'Tiffin center',
    'Tea shop with seating',
    'Small hotel',
    'Canteen',
    'Biryani shop',
    'Juice shop',
    'Bakery',
  ],
  VendorCategory.service: [
    'Barber',
    'Tailor',
    'Cobbler',
    'Cycle repair',
    'Mobile repair',
    'Ironing service',
    'Electrician',
    'Plumber',
  ],
};

/// The 38 districts of Tamil Nadu (romanized proper nouns, like market
/// names). Pan-India expansion ships one such list per state.
const tamilNaduDistricts = [
  'Ariyalur',
  'Chengalpattu',
  'Chennai',
  'Coimbatore',
  'Cuddalore',
  'Dharmapuri',
  'Dindigul',
  'Erode',
  'Kallakurichi',
  'Kancheepuram',
  'Kanyakumari',
  'Karur',
  'Krishnagiri',
  'Madurai',
  'Mayiladuthurai',
  'Nagapattinam',
  'Namakkal',
  'Nilgiris',
  'Perambalur',
  'Pudukkottai',
  'Ramanathapuram',
  'Ranipet',
  'Salem',
  'Sivaganga',
  'Tenkasi',
  'Thanjavur',
  'Theni',
  'Thoothukudi',
  'Tiruchirappalli',
  'Tirunelveli',
  'Tirupathur',
  'Tiruppur',
  'Tiruvallur',
  'Tiruvannamalai',
  'Tiruvarur',
  'Vellore',
  'Viluppuram',
  'Virudhunagar',
];
