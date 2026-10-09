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
    category: json["category"],
    createdOn: json["created_on"],
    imageProduct: json['image_product'] == null ||
  json['image_product'] == 'null'
  ? ''
    : json['image_product'],
    productName: json["product_name"],
    productCode: json["product_code"],
    quantity: json["quantity"],
    unitPrice: json["unit_price"],
    discountPercent: json["discount_percent"],
    discountMax: json["discount_max"],
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
