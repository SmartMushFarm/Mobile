class AdminTicketsData {
  static const List<Map<String, dynamic>> tickets = [
    {
      'id': 'TK-1088',
      'title': 'High Temp Alert',
      'device': 'Grow Lab A',
      'assigned': 'Sam Green',
      'time': '45m ago',
      'priority': 'high',
      'status': 'pending',
      'buttons': ['assign_technician', 'update_status'],
    },
    {
      'id': 'TK-1086',
      'title': 'Connectivity Issue',
      'device': 'Oyster Box 2',
      'assigned': 'Jordan Smith',
      'time': '3h ago',
      'priority': 'medium',
      'status': 'in_progress',
      'buttons': ['assign_technician', 'update_status'],
    },
    {
      'id': 'TK-1082',
      'title': 'Water Pump Failure',
      'device': 'Smart Box 3',
      'assigned': 'Taylor Reed',
      'time': '5h ago',
      'priority': 'high',
      'status': 'in_progress',
      'buttons': ['assign_technician', 'update_status'],
    },
    {
      'id': 'TK-1078',
      'title': 'CO2 Sensor Drift',
      'device': 'Grow Lab B',
      'assigned': 'Sam Green',
      'time': '1d ago',
      'priority': 'medium',
      'status': 'pending',
      'buttons': ['assign_technician', 'update_status'],
    },
    {
      'id': 'TK-1075',
      'title': 'Humidity Calibration',
      'device': 'Oyster Box 1',
      'assigned': null,
      'time': '1d ago',
      'priority': 'low',
      'status': 'pending',
      'buttons': ['assign_technician', 'update_status'],
    },
  ];

  static const Map<String, dynamic> summary = {
    'openTickets': 12,
    'highPriority': 4,
    'completedToday': 8,
  };
}
