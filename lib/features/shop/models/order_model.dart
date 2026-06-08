class OrderModel {
  final int id;
  final int? userId;
  final int? promotionId;
  final DateTime? orderDate;
  final String status;
  final double totalAmount;
  final String? shippingAddress;
  final DateTime? createdAt;
  final String? userName; // Useful for admin view

  OrderModel({
    required this.id,
    this.userId,
    this.promotionId,
    this.orderDate,
    required this.status,
    required this.totalAmount,
    this.shippingAddress,
    this.createdAt,
    this.userName,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      promotionId: int.tryParse(json['promotion_id']?.toString() ?? ''),
      orderDate: json['order_date'] != null
          ? DateTime.tryParse(json['order_date'].toString())
          : null,
      status: json['status']?.toString() ?? 'Pending',
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      shippingAddress: json['shipping_address']?.toString(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
      userName: json['user_name']?.toString() ?? (json['user'] is Map ? json['user']['name']?.toString() : null),
    );
  }
}
