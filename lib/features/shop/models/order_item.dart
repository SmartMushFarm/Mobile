enum OrderStatus {
  pending('Chờ xác nhận', OrderStatusType.pending),
  delivering('Đang giao', OrderStatusType.delivering),
  delivered('Đã giao', OrderStatusType.delivered),
  cancelled('Đã hủy', OrderStatusType.cancelled);

  const OrderStatus(this.label, this.type);
  final String label;
  final OrderStatusType type;
}

enum OrderStatusType { pending, delivering, delivered, cancelled }

enum OrderFilter {
  all('Tất cả', null),
  pending('Chờ xác nhận', OrderStatusType.pending),
  delivering('Đang giao', OrderStatusType.delivering),
  delivered('Đã giao', OrderStatusType.delivered),
  cancelled('Đã hủy', OrderStatusType.cancelled);

  const OrderFilter(this.label, this.type);
  final String label;
  final OrderStatusType? type;
}

class OrderItem {
  const OrderItem({
    required this.id,
    required this.orderCode,
    required this.products,
    required this.date,
    required this.total,
    required this.status,
  });

  final String id;
  final String orderCode;
  final String products;
  final String date;
  final String total;
  final OrderStatus status;
}
