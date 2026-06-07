class AdminAlertsData {
  static const List<Map<String, dynamic>> alerts = [
    {
      'id': 'ALT001',
      'device': 'Grow Lab A',
      'time': '2 mins ago',
      'title': 'High Temperature: 34°C',
      'description':
          'Internal temperature in Grow Lab A has exceeded the 28°C threshold. Immediate cooling required to prevent contamination and ensure crop health.',
      'severity': 'critical',
      'isResolved': false,
      'buttons': ['resolve', 'assign_tech'],
    },
    {
      'id': 'ALT002',
      'device': 'Oyster Box 1',
      'time': '45 mins ago',
      'title': 'Low Water Level',
      'description':
          'Mixing reservoir tank level is below 15%. Device will be unable to maintain humidity within 4-6 hours at current cycle rates.',
      'severity': 'warning',
      'isResolved': false,
      'buttons': ['resolve', 'assign_tech'],
    },
    {
      'id': 'ALT003',
      'device': 'Smart Box 3',
      'time': '1 hour ago',
      'title': 'Firmware Update Complete',
      'description':
          'Successfully updated to v2.4.1. Network stability patches and CO2 sensor calibration enhancements have been applied.',
      'severity': 'success',
      'isResolved': true,
      'buttons': ['archive'],
    },
    {
      'id': 'ALT004',
      'device': 'Gateway 04',
      'time': '3 hours ago',
      'title': 'CO2 Sensor Offline',
      'description':
          'Connectivity lost with the main CO2 sensor array. Data logging has paused. This may lead to stale environment readings.',
      'severity': 'critical',
      'isResolved': false,
      'buttons': ['resolve', 'assign_tech'],
    },
    {
      'id': 'ALT005',
      'device': 'Grow Lab B',
      'time': '5 hours ago',
      'title': 'Humidity Spike Detected',
      'description':
          'Humidity level reached 95% in Grow Lab B. Fungus growth risk elevated. Automated dehumidification cycle triggered.',
      'severity': 'warning',
      'isResolved': false,
      'buttons': ['resolve', 'assign_tech'],
    },
    {
      'id': 'ALT006',
      'device': 'Oyster Box 2',
      'time': 'Yesterday',
      'title': 'Device Reconnected',
      'description':
          'Oyster Box 2 has reconnected to the network after 12 hours offline. All systems nominal.',
      'severity': 'success',
      'isResolved': true,
      'buttons': ['archive'],
    },
  ];

  static const List<String> filterOptions = [
    'All',
    'Critical',
    'Warning',
    'Resolved',
  ];

  static const Map<String, dynamic> stats = {
    'alertVolumeChange': '+12%',
    'meanTimeToResolve': '14.2m',
    'meanTimeNote': 'Fastest this week',
  };
}
