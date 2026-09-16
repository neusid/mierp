class Product {
  String? id;
  String category;
  String createdOn;
  String? imageProduct;
  String productName;
  String productCode;
  int quantity;
  int unitPrice;

  Product({
    required this.id,
    required this.category,
    required this.createdOn,
    required this.imageProduct,
    required this.productName,
    required this.productCode,
    required this.quantity,
    required this.unitPrice,
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
  };
}