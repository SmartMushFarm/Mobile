class OrderDetailModel {
  final int id;
  final int? orderId;
  final int? productId;
  final int quantity;
  final double price;
  final String? productName;
  final String? productImageUrl;

  OrderDetailModel({
    required this.id,
    this.orderId,
    this.productId,
    required this.quantity,
    required this.price,
    this.productName,
    this.productImageUrl,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> product = json['product'] is Map ? json['product'] : {};

    return OrderDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      orderId: int.tryParse(json['order_id']?.toString() ?? ''),
      productId: int.tryParse((json['product_id'] ?? product['id'])?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      price: double.tryParse((json['price'] ?? product['price'])?.toString() ?? '0') ?? 0.0,
      productName: json['product_name']?.toString() ?? product['name']?.toString(),
      productImageUrl: json['product_image_url']?.toString() ?? product['image_url']?.toString(),
    );
  }
}
