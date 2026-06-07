class AdminDashboardData {
  static const List<Map<String, dynamic>> stats = [
    {'label': 'Active Devices', 'value': '42', 'icon': 'sensors', 'color': 0xFF22C55E},
    {'label': 'Offline Devices', 'value': '2', 'icon': 'sensors_off', 'color': 0xFFEF4444},
    {'label': 'Open Tickets', 'value': '5', 'icon': 'confirmation_number', 'color': 0xFFF59E0B},
    {'label': 'Orders Today', 'value': '18', 'icon': 'shopping_cart', 'color': 0xFF8B5CF6},
  ];

  static const List<Map<String, dynamic>> devices = [
    {
      'id': 'DEV001',
      'name': 'Oyster Box 1',
      'status': 'online',
      'temperature': 24.0,
      'humidity': 85.0,
      'lastSync': '2m ago',
      'alert': null,
      'co2': 800,
      'actions': ['restart', 'ota_update', 'details'],
    },
    {
      'id': 'DEV002',
      'name': 'Grow Lab A',
      'status': 'warning',
      'temperature': 37.0,
      'humidity': 77.0,
      'lastSync': '1m ago',
      'alert': 'High Temp Alert',
      'co2': null,
      'actions': ['restart', 'ota_update', 'details'],
    },
    {
      'id': 'DEV003',
      'name': 'Smart Box 3',
      'status': 'offline',
      'temperature': null,
      'humidity': null,
      'lastSync': '5m ago',
      'alert': null,
      'co2': null,
      'actions': ['reconnect', 'diagnostics'],
    },
  ];

  static const List<Map<String, dynamic>> alerts = [
    {
      'id': 'ALT001',
      'device': 'Oyster Box 1',
      'time': '2m ago',
      'title': 'High Temperature',
      'description': 'Oyster Box 1 exceeds safe threshold',
      'severity': 'critical',
      'buttons': ['resolve', 'assign_tech'],
    },
    {
      'id': 'ALT002',
      'device': 'Grow Lab A',
      'time': '15m ago',
      'title': 'Sensor Malfunction',
      'description': 'Humidity sensor offline in Grow Lab A',
      'severity': 'warning',
      'buttons': ['resolve'],
    },
    {
      'id': 'ALT003',
      'device': 'Smart Box 3',
      'time': '1h ago',
      'title': 'Automation Conflict',
      'description': 'Multiple rules triggered simultaneously',
      'severity': 'success',
      'buttons': ['archive'],
    },
  ];

  static const Map<String, int> maintenanceSummary = {
    'pending': 8,
    'assigned': 4,
    'doneToday': 12,
  };

  static const List<Map<String, dynamic>> actions = [
    {'label': 'Manage Products', 'icon': 'inventory_2', 'route': '/admin/products'},
    {'label': 'Manage Orders', 'icon': 'receipt_long', 'route': '/admin/orders'},
    {'label': 'Manage Users', 'icon': 'people', 'route': '/admin/users'},
    {'label': 'OTA Firmware', 'icon': 'system_update', 'route': '/admin/devices'},
    {'label': 'Notifications', 'icon': 'notifications', 'route': '/admin/alerts'},
  ];
}
