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
    required this.userId,
    required this.imageProduct,
  });

  factory SalesOrder.fromJson(
    Map<String, dynamic> json, {
    required String? docId,
  }) => SalesOrder(
    id: docId,
    companyName: json["company_name"],
    financeApproved: json["finance_approved"],
    financeApprovedDate: json["finance_approved_date"] ?? '',
    firstName: json["first_name"],
    paymentStatus: json["payment_status"],
    productCode: json["product_code"],
    productId: json["product_id"],
    productName: json["product_name"],
    purchasedDate: json["purchased_date"],
    quantity: json["quantity"],
    totalPrice: json["total_price"],
    unitPrice: json["unit_price"],
    userId: json["user_id"],
    imageProduct: json["image_product"],
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
    "user_id": userId,
    "image_product": imageProduct,
  };
}
