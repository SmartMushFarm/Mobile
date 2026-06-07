class AdminProductsData {
  static const List<Map<String, dynamic>> products = [
    {
      'id': 'PRD001',
      'name': 'Smart LED Grow Light',
      'price': '\$45.00',
      'stock': 15,
      'status': 'in_stock',
      'image': 'led_grow_light',
    },
    {
      'id': 'PRD002',
      'name': 'Oyster Mushroom Kit',
      'price': '\$29.99',
      'stock': 2,
      'status': 'low_stock',
      'image': 'mushroom_kit',
    },
    {
      'id': 'PRD003',
      'name': 'Humidity Sensor Pro',
      'price': '\$72.00',
      'stock': 8,
      'status': 'in_stock',
      'image': 'humidity_sensor',
    },
    {
      'id': 'PRD004',
      'name': "Lion's Mane Culture",
      'price': '\$18.50',
      'stock': 0,
      'status': 'out_of_stock',
      'image': 'lions_mane',
    },
    {
      'id': 'PRD005',
      'name': 'Pro Mist System',
      'price': '\$89.00',
      'stock': 5,
      'status': 'in_stock',
      'image': 'mist_system',
    },
    {
      'id': 'PRD006',
      'name': 'Substrate Bag Mix',
      'price': '\$24.00',
      'stock': 1,
      'status': 'low_stock',
      'image': 'substrate_bag',
    },
  ];

  static const Map<String, dynamic> summary = {
    'totalInventory': 24,
    'lowStock': 3,
    'outOfStock': 1,
  };
}
