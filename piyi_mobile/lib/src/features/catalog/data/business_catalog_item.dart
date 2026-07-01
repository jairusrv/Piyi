import 'business_catalog_item_type.dart';

class BusinessCatalogItem {
  const BusinessCatalogItem({
    required this.id,
    required this.businessId,
    required this.businessName,
    this.businessPhone,
    this.businessWhatsApp,
    this.businessAddress,
    this.businessCity,
    this.businessRegion,
    this.businessLatitude,
    this.businessLongitude,
    required this.businessIsVerified,
    required this.type,
    required this.name,
    this.description,
    this.category,
    this.brand,
    this.barcode,
    this.sku,
    this.referencePrice,
    required this.currency,
    this.photoUrl,
    required this.isAvailable,
    required this.isFeatured,
    this.petSpecies,
    this.breedTarget,
    this.ageTarget,
    this.weightTarget,
    this.tags,
    this.notes,
  });

  final String id;
  final String businessId;
  final String businessName;
  final String? businessPhone;
  final String? businessWhatsApp;
  final String? businessAddress;
  final String? businessCity;
  final String? businessRegion;
  final num? businessLatitude;
  final num? businessLongitude;
  final bool businessIsVerified;
  final BusinessCatalogItemType type;
  final String name;
  final String? description;
  final String? category;
  final String? brand;
  final String? barcode;
  final String? sku;
  final num? referencePrice;
  final String currency;
  final String? photoUrl;
  final bool isAvailable;
  final bool isFeatured;
  final String? petSpecies;
  final String? breedTarget;
  final String? ageTarget;
  final String? weightTarget;
  final String? tags;
  final String? notes;

  factory BusinessCatalogItem.fromJson(Map<String, dynamic> json) {
    return BusinessCatalogItem(
      id: json['id'] as String,
      businessId: json['businessId'] as String,
      businessName: json['businessName'] as String? ?? '',
      businessPhone: json['businessPhone'] as String?,
      businessWhatsApp: json['businessWhatsApp'] as String?,
      businessAddress: json['businessAddress'] as String?,
      businessCity: json['businessCity'] as String?,
      businessRegion: json['businessRegion'] as String?,
      businessLatitude: json['businessLatitude'] as num?,
      businessLongitude: json['businessLongitude'] as num?,
      businessIsVerified: json['businessIsVerified'] as bool? ?? false,
      type: catalogTypeFromInt(json['type'] as int? ?? 1),
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      category: json['category'] as String?,
      brand: json['brand'] as String?,
      barcode: json['barcode'] as String?,
      sku: json['sku'] as String?,
      referencePrice: json['referencePrice'] as num?,
      currency: json['currency'] as String? ?? 'CRC',
      photoUrl: json['photoUrl'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? true,
      isFeatured: json['isFeatured'] as bool? ?? false,
      petSpecies: json['petSpecies'] as String?,
      breedTarget: json['breedTarget'] as String?,
      ageTarget: json['ageTarget'] as String?,
      weightTarget: json['weightTarget'] as String?,
      tags: json['tags'] as String?,
      notes: json['notes'] as String?,
    );
  }

  String get priceLabel {
    if (referencePrice == null) return 'Precio no indicado';

    final value = referencePrice!.toStringAsFixed(referencePrice! % 1 == 0 ? 0 : 2);

    if (currency.toUpperCase() == 'CRC') {
      return '₡$value';
    }

    return '$currency $value';
  }

  String get availabilityLabel => isAvailable ? 'Disponible' : 'Consultar disponibilidad';
}
