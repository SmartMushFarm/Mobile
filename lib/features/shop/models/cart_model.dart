class CartModel {
  final int id;
  final int? userId;
  final List<CartItemModel> items;
  final double totalAmount;
  final DateTime? createdAt;

  CartModel({
    required this.id,
    this.userId,
    required this.items,
    required this.totalAmount,
    this.createdAt,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var itemsList = json['items'] as List? ?? [];
    List<CartItemModel> cartItems =
        itemsList.map((i) => CartItemModel.fromJson(i)).toList();

    return CartModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      userId: int.tryParse(json['user_id']?.toString() ?? ''),
      items: cartItems,
      totalAmount: double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'].toString())
          : null,
    );
  }
}

class CartItemModel {
  final int id;
  final int? cartId;
  final int productId;
  final int quantity;
  final String? productName;
  final String? productImageUrl;
  final double price;
  final double subtotal;

  CartItemModel({
    required this.id,
    this.cartId,
    required this.productId,
    required this.quantity,
    this.productName,
    this.productImageUrl,
    required this.price,
    required this.subtotal,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    // Handle nested product object if present
    Map<String, dynamic> product = json['product'] is Map ? json['product'] : {};
    
    return CartItemModel(
      id: int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      cartId: int.tryParse(json['cart_id']?.toString() ?? ''),
      productId: int.tryParse((json['product_id'] ?? product['id'])?.toString() ?? '0') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '0') ?? 0,
      productName: json['product_name']?.toString() ?? product['name']?.toString(),
      productImageUrl: json['product_image_url']?.toString() ?? product['image_url']?.toString(),
      price: double.tryParse((json['price'] ?? product['price'])?.toString() ?? '0') ?? 0.0,
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '0') ?? 0.0,
    );
  }
}
