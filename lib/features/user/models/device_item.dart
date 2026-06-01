enum DeviceStatus { online, offline }

class DeviceItem {
  const DeviceItem({
    required this.id,
    required this.name,
    required this.status,
    this.temperature,
    this.humidity,
    this.mushroomType,
    this.offlineMessage,
    this.isLedOn = false,
    this.isMistOn = false,
    this.isFanOn = false,
  });

  final String id;
  final String name;
  final DeviceStatus status;
  final String? temperature;
  final String? humidity;
  final String? mushroomType;
  final String? offlineMessage;
  final bool isLedOn;
  final bool isMistOn;
  final bool isFanOn;
}
