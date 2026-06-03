class BoxSensorReading {
  const BoxSensorReading({
    required this.temperatureCelsius,
    required this.temperatureTrend,
    required this.humidityPercent,
    required this.co2Ppm,
    required this.co2LevelProgress,
    required this.substrateMoisturePercent,
  });

  final int temperatureCelsius;
  final double temperatureTrend;
  final int humidityPercent;
  final int co2Ppm;
  final double co2LevelProgress;
  final int substrateMoisturePercent;
}

class BoxDeviceState {
  const BoxDeviceState({
    required this.ledOn,
    required this.fanOn,
    required this.mistOn,
    required this.heaterOn,
  });

  final bool ledOn;
  final bool fanOn;
  final bool mistOn;
  final bool heaterOn;
}

class ActivityLogEntry {
  const ActivityLogEntry({
    required this.timeLabel,
    required this.message,
  });

  final String timeLabel;
  final String message;
}

class BoxOverviewData {
  const BoxOverviewData({
    required this.id,
    required this.name,
    required this.growStatusLabel,
    required this.sensors,
    required this.devices,
    required this.temperatureTrend,
    required this.humidityTrend,
    required this.activityLogs,
  });

  final String id;
  final String name;
  final String growStatusLabel;
  final BoxSensorReading sensors;
  final BoxDeviceState devices;
  final List<double> temperatureTrend;
  final List<double> humidityTrend;
  final List<ActivityLogEntry> activityLogs;
}
