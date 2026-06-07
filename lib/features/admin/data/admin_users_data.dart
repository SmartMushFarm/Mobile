class AdminUsersData {
  static const List<Map<String, dynamic>> users = [
    {
      'id': 'USR001',
      'name': 'Alex Farmer',
      'email': 'alex@smartmush.com',
      'devices': 3,
      'lastActive': '2 hours ago',
      'status': 'active',
      'actions': ['view', 'edit', 'suspend'],
    },
    {
      'id': 'USR002',
      'name': 'Sarah Bloom',
      'email': 'sarah@biologger.net',
      'devices': 4,
      'lastActive': '5 mins ago',
      'status': 'active',
      'actions': ['view', 'edit', 'suspend'],
    },
    {
      'id': 'USR003',
      'name': 'James Gray',
      'email': 'james@grayfarm.com',
      'devices': 5,
      'lastActive': '12 days ago',
      'status': 'suspended',
      'actions': ['view', 'edit', 'activate'],
    },
    {
      'id': 'USR004',
      'name': 'Maya Chen',
      'email': 'maya@fungitech.io',
      'devices': 5,
      'lastActive': 'Just now',
      'status': 'active',
      'actions': ['view', 'edit', 'suspend'],
    },
    {
      'id': 'USR005',
      'name': 'David Park',
      'email': 'david@mycotools.com',
      'devices': 2,
      'lastActive': '1 day ago',
      'status': 'active',
      'actions': ['view', 'edit', 'suspend'],
    },
    {
      'id': 'USR006',
      'name': 'Lisa Wong',
      'email': 'lisa@growlab.io',
      'devices': 6,
      'lastActive': '3 days ago',
      'status': 'active',
      'actions': ['view', 'edit', 'suspend'],
    },
  ];

  static const Map<String, dynamic> summary = {
    'totalUsers': 1284,
    'activeUsers': 1102,
    'suspended': 12,
  };
}
