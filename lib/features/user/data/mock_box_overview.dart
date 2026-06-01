import 'package:smartmush_farmer/features/user/models/box_overview_data.dart';

const _defaultTrend = [22.0, 23.0, 24.0, 23.5, 24.0, 24.5, 24.0];
const _humidityTrend = [80.0, 82.0, 84.0, 85.0, 84.0, 85.0, 85.0];

final mockBoxOverviewById = <String, BoxOverviewData>{
  'oyster-box-1': const BoxOverviewData(
    id: 'oyster-box-1',
    name: 'Hộp Nấm Sò 1',
    growStatusLabel: 'Tối ưu',
    sensors: BoxSensorReading(
      temperatureCelsius: 24,
      temperatureTrend: 0.5,
      humidityPercent: 85,
      co2Ppm: 600,
      co2LevelProgress: 0.4,
      substrateMoisturePercent: 62,
    ),
    devices: BoxDeviceState(ledOn: true, fanOn: true, mistOn: false),
    temperatureTrend: _defaultTrend,
    humidityTrend: _humidityTrend,
    activityLogs: [
      ActivityLogEntry(
        timeLabel: '10:42 AM',
        message: 'Độ ẩm ổn định ở 85%',
      ),
      ActivityLogEntry(
        timeLabel: '09:15 AM',
        message: 'Chu kỳ phun sương hoàn tất',
      ),
      ActivityLogEntry(
        timeLabel: '08:00 AM',
        message: 'Lịch đèn LED bắt đầu',
      ),
    ],
  ),
  'shiitake-tub-a': const BoxOverviewData(
    id: 'shiitake-tub-a',
    name: 'Khối Nấm Shiitake A',
    growStatusLabel: 'Tối ưu',
    sensors: BoxSensorReading(
      temperatureCelsius: 21,
      temperatureTrend: -0.2,
      humidityPercent: 90,
      co2Ppm: 520,
      co2LevelProgress: 0.35,
      substrateMoisturePercent: 58,
    ),
    devices: BoxDeviceState(ledOn: false, fanOn: true, mistOn: true),
    temperatureTrend: [20.0, 20.5, 21.0, 21.0, 20.8, 21.0, 21.0],
    humidityTrend: [88.0, 89.0, 90.0, 89.0, 90.0, 90.0, 90.0],
    activityLogs: [
      ActivityLogEntry(
        timeLabel: '11:05 AM',
        message: 'Tốc độ quạt tăng',
      ),
      ActivityLogEntry(
        timeLabel: '10:30 AM',
        message: 'Mức CO2 trong phạm vi',
      ),
    ],
  ),
};

BoxOverviewData? mockBoxOverviewFor(String boxId) =>
    mockBoxOverviewById[boxId];
