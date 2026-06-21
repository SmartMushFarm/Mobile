class CheckoutItem {
  const CheckoutItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  final String name;
  final String price;
  final int quantity;
  final String imageUrl;
}

enum DeliveryMethod {
  standard('Giao hàng tiêu chuẩn', '35.000đ'),
  express('Giao hàng nhanh', '55.000đ');

  const DeliveryMethod(this.label, this.price);
  final String label;
  final String price;
}

enum PaymentMethod {
  cod('Thanh toán khi nhận hàng'),
  payOS('Thanh toán qua PayOS (QR Code/Ngân hàng)'),
  bankTransfer('Chuyển khoản thủ công'),
  creditCard('Thẻ ngân hàng');

  const PaymentMethod(this.label);
  final String label;
}
