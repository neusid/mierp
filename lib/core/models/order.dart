class OrderProduct {
  String? id;
  bool? financeApproved;
  DateTime? financeApprovedDate;
  String? orderDate;
  String productId;
  String productCode;
  String productName;
  int quantity;
  int totalCost;
  int unitPrice;
  int? discountPercent;
  int? discountMax;
  String userId;
  String firstName;
  String imageProduct;
  bool? isRejected;
  String? rejectionReason;

  OrderProduct({
    required this.id,
    required this.financeApproved,
    required this.financeApprovedDate,
    required this.orderDate,
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.quantity,
    required this.totalCost,
    required this.unitPrice,
    this.discountPercent,
    this.discountMax,
    required this.userId,
    required this.firstName,
    required this.imageProduct,
    this.isRejected,
    this.rejectionReason,
  });

  factory OrderProduct.fromJson(
    Map<String, dynamic> json, {
    required String? docId,
  }) => OrderProduct(
    id: docId,
    financeApproved: json["finance_approved"] == true,
    isRejected: json["is_rejected"] == true,
    rejectionReason: json["rejection_reason"]?.toString(),
    financeApprovedDate: () {
      final raw = json["finance_approved_date"];
      if (raw == null) return null;
      if (raw is DateTime) return raw;
      if (raw.runtimeType.toString().contains("Timestamp")) {
        try {
          return (raw as dynamic).toDate();
        } catch (_) {}
      }
      return DateTime.tryParse(raw.toString());
    }(),
    orderDate: json["order_date"]?.toString() ?? '',
    productId: json["product_id"]?.toString() ?? '',
    productCode: json["product_code"]?.toString() ?? '',
    productName: json["product_name"]?.toString() ?? '',
    quantity: (json["quantity"] is num)
        ? (json["quantity"] as num).toInt()
        : (int.tryParse(json["quantity"]?.toString() ?? '0') ?? 0),
    totalCost: (json["total_cost"] is num)
        ? (json["total_cost"] as num).toInt()
        : (int.tryParse(json["total_cost"]?.toString() ?? '0') ?? 0),
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
    firstName: json["first_name"]?.toString() ?? '',
    imageProduct: json["image_product"]?.toString() ?? '',
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "finance_approved": financeApproved!,
    "finance_approved_date": financeApprovedDate?.toIso8601String(),
    "is_rejected": isRejected == true,
    "rejection_reason": rejectionReason,
    "order_date": orderDate!,
    "product_id": productId,
    "product_code": productCode,
    "product_name": productName,
    "quantity": quantity,
    "total_cost": totalCost,
    "unit_price": unitPrice,
    "discount_percent": discountPercent,
    "discount_max": discountMax,
    "user_id": userId,
    "first_name": firstName,
    "image_product": imageProduct,
  };
}
