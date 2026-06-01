class CartItem {
  const CartItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.quantity,
  });

  final String id;
  final String name;
  final String description;
  final String price;
  final String imageUrl;
  final int quantity;
}

class CartSummary {
  const CartSummary({
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
  });

  final String subtotal;
  final String shipping;
  final String tax;
  final String total;
}
