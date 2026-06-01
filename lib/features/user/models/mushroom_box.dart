class MushroomBox {
  const MushroomBox({
    required this.id,
    required this.name,
    required this.isOnline,
    required this.temperatureCelsius,
    required this.humidityPercent,
    required this.lightActive,
    required this.fanActive,
  });

  final String id;
  final String name;
  final bool isOnline;
  final int temperatureCelsius;
  final int humidityPercent;
  final bool lightActive;
  final bool fanActive;
}
