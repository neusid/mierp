class Product {
  String? id;
  String category;
  String createdOn;
  String? imageProduct;
  String productName;
  String productCode;
  int quantity;
  int unitPrice;
  int? discountPercent;
  int? discountMax;

  Product({
    required this.id,
    required this.category,
    required this.createdOn,
    required this.imageProduct,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unitPrice,
    this.discountPercent,
    this.discountMax,
  });

  factory Product.fromJson(Map<String, dynamic> json, {required String docId}) => Product(
    id: docId,
    category: json["category"]?.toString() ?? 'general',
    createdOn: () {
      final raw = json["created_on"];
      if (raw == null) return '';
      if (raw.runtimeType.toString().contains("Timestamp")) {
        try {
          return (raw as dynamic).toDate().toString();
        } catch (_) {}
      }
      return raw.toString();
    }(),
    imageProduct: (json['image_product'] == null || json['image_product'] == 'null')
        ? ''
        : json['image_product'].toString(),
    productName: json["product_name"]?.toString() ?? '',
    productCode: json["product_code"]?.toString() ?? '',
    quantity: (json["quantity"] is num)
        ? (json["quantity"] as num).toInt()
        : (int.tryParse(json["quantity"]?.toString() ?? '0') ?? 0),
    unitPrice: (json["unit_price"] is num)
        ? (json["unit_price"] as num).toInt()
        : (int.tryParse(json["unit_price"]?.toString() ?? '0') ?? 0),
    discountPercent: (json["discount_percent"] is num)
        ? (json["discount_percent"] as num).toInt()
        : int.tryParse(json["discount_percent"]?.toString() ?? ''),
    discountMax: (json["discount_max"] is num)
        ? (json["discount_max"] as num).toInt()
        : int.tryParse(json["discount_max"]?.toString() ?? ''),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category": category,
    "created_on": createdOn,
    "image_product": imageProduct,
    "product_name": productName,
    "product_code": productCode,
    "quantity": quantity,
    "unit_price": unitPrice,
    "discount_percent": discountPercent,
    "discount_max": discountMax,
  };

  Product copyWith({
    String? id,
    String? category,
    String? createdOn,
    String? imageProduct,
    String? productName,
    String? productCode,
    int? quantity,
    int? unitPrice,
    int? discountPercent,
    int? discountMax,
  }) {
    return Product(
      id: id ?? this.id,
      category: category ?? this.category,
      createdOn: createdOn ?? this.createdOn,
      imageProduct: imageProduct ?? this.imageProduct,
      productName: productName ?? this.productName,
      productCode: productCode ?? this.productCode,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountMax: discountMax ?? this.discountMax,
    );
  }
}
