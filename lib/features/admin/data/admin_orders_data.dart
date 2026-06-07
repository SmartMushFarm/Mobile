class AdminOrdersData {
  static const List<Map<String, dynamic>> orders = [
    {
      'id': 'ORD-7742',
      'customer': 'Alex Farmer',
      'items': 'Oyster Mushroom Box x2',
      'total': '\$89.00',
      'status': 'processing',
      'buttons': ['confirm', 'update'],
    },
    {
      'id': 'ORD-7745',
      'customer': 'Sarah Green',
      'items': "Lion's Mane Substrate x5",
      'total': '\$145.20',
      'status': 'shipped',
      'buttons': ['mark_delivered'],
    },
    {
      'id': 'ORD-7748',
      'customer': 'John Myco',
      'items': 'Pro Mist System x1',
      'total': '\$320.00',
      'status': 'pending',
      'buttons': ['send_invoice'],
    },
    {
      'id': 'ORD-7751',
      'customer': 'Emily Chen',
      'items': 'Smart Humidifier x1',
      'total': '\$199.00',
      'status': 'delivered',
      'buttons': [],
    },
    {
      'id': 'ORD-7754',
      'customer': 'Mike Wilson',
      'items': 'Oyster Mushroom Box x3, Grow Kit x1',
      'total': '\$267.50',
      'status': 'pending',
      'buttons': ['send_invoice'],
    },
  ];

  static const List<String> filterOptions = [
    'All Orders',
    'Pending',
    'Shipping',
    'Delivered',
  ];

  static const Map<String, dynamic> summary = {
    'ordersToday': 42,
    'pendingOrders': 8,
    'revenueToday': '\$1,284.50',
  };
}
