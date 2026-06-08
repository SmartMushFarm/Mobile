class PaymentModel {
  final int id;
  final int orderId;
  final String paymentStatus;
  final double amount;
  final String paymentMethod;
  final String? qrCode;
  final DateTime? paidAt;
  final DateTime? createdAt;

  PaymentModel({
    required this.id,
    required this.orderId,
    required this.paymentStatus,
    required this.amount,
    required this.paymentMethod,
    this.qrCode,
    this.paidAt,
    this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: int.tryParse(json['order_id']?.toString() ?? '0') ?? 0,
      paymentStatus: json['payment_status']?.toString() ?? 'Pending',
      amount: double.tryParse(json['amount']?.toString() ?? '0') ?? 0.0,
      paymentMethod: json['payment_method']?.toString() ?? '',
      qrCode: json['qr_code']?.toString(),
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }
}
