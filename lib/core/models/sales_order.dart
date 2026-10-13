class SalesOrder {
  String? id;
  String companyName;
  bool? financeApproved;
  String? financeApprovedDate;
  String firstName;
  bool? paymentStatus;
  String productCode;
  String productId;
  String productName;
  String purchasedDate;
  int quantity;
  int totalPrice;
  int unitPrice;
  int? discountPercent;
  int? discountMax;
  String userId;
  String imageProduct;

  SalesOrder({
    required this.id,
    required this.companyName,
    required this.financeApproved,
    required this.financeApprovedDate,
    required this.firstName,
    required this.paymentStatus,
    required this.productCode,
    required this.productId,
    required this.productName,
    required this.purchasedDate,
    required this.quantity,
    required this.totalPrice,
    required this.unitPrice,
    this.discountPercent,
    this.discountMax,
    required this.userId,
    required this.imageProduct,
  });

  factory SalesOrder.fromJson(
    Map<String, dynamic> json, {
    required String? docId,
  }) => SalesOrder(
    id: docId,
    companyName: json["company_name"]?.toString() ?? '',
    financeApproved: json["finance_approved"] == true,
    financeApprovedDate: json["finance_approved_date"]?.toString() ?? '',
    firstName: json["first_name"]?.toString() ?? '',
    paymentStatus: json["payment_status"] == true,
    productCode: json["product_code"]?.toString() ?? '',
    productId: json["product_id"]?.toString() ?? '',
    productName: json["product_name"]?.toString() ?? '',
    purchasedDate: json["purchased_date"]?.toString() ?? '',
    quantity: (json["quantity"] is num)
        ? (json["quantity"] as num).toInt()
        : (int.tryParse(json["quantity"]?.toString() ?? '0') ?? 0),
    totalPrice: (json["total_price"] is num)
        ? (json["total_price"] as num).toInt()
        : (int.tryParse(json["total_price"]?.toString() ?? '0') ?? 0),
    unitPrice: (json["unit_price"] is num)
        ? (json["unit_price"] as num).toInt()
        : (int.tryParse(json["unit_price"]?.toString() ?? '0') ?? 0),
    discountPercent: (json["discount_percent"] is num)
        ? (json["discount_percent"] as num).toInt()
        : int.tryParse(json["discount_percent"]?.toString() ?? ''),
    discountMax: (json["discount_max"] is num)
        ? (json["discount_max"] as num).toInt()
        : int.tryParse(json["discount_max"]?.toString() ?? ''),
    userId: json["user_id"]?.toString() ?? '',
    imageProduct: json["image_product"]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "company_name": companyName,
    "finance_approved": financeApproved,
    "finance_approved_date": financeApprovedDate,
    "first_name": firstName,
    "payment_status": paymentStatus,
    "product_code": productCode,
    "product_id": productId,
    "product_name": productName,
    "purchased_date": purchasedDate,
    "quantity": quantity,
    "total_price": totalPrice,
    "unit_price": unitPrice,
    "discount_percent": discountPercent,
    "discount_max": discountMax,
    "user_id": userId,
    "image_product": imageProduct,
  };
}
