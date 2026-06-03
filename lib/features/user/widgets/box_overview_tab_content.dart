import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/device_status_chip.dart';
import 'package:smartmush_farmer/core/widgets/sensor_card.dart';
import 'package:smartmush_farmer/core/widgets/simple_line_chart.dart';
import 'package:smartmush_farmer/features/user/models/box_overview_data.dart';

class BoxOverviewTabContent extends StatelessWidget {
  const BoxOverviewTabContent({
    super.key,
    required this.data,
  });

  final BoxOverviewData data;

  @override
  Widget build(BuildContext context) {
    final sensors = data.sensors;
    final devices = data.devices;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SensorCard.temperature(
          value: '${sensors.temperatureCelsius}',
          unit: '°C',
          trend: sensors.temperatureTrend,
        ),
        const SizedBox(height: 12),
        SensorCard.humidity(
          value: '${sensors.humidityPercent}',
          unit: '%',
        ),
        const SizedBox(height: 24),
        Text(
          'Trạng thái thiết bị',
          style: GoogleFonts.plusJakartaSans(
            textStyle: AppTextStyles.boxCardTitle,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            DeviceStatusChip(
              label: 'Quạt',
              icon: Icons.air,
              isActive: devices.fanOn,
            ),
            DeviceStatusChip(
              label: 'Phun sương',
              icon: Icons.water_outlined,
              isActive: devices.mistOn,
            ),
            DeviceStatusChip(
              label: 'Máy sưởi',
              icon: Icons.wb_sunny_outlined,
              isActive: devices.heaterOn,
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          'Xu hướng 24h',
          style: GoogleFonts.plusJakartaSans(
            textStyle: AppTextStyles.boxCardTitle,
          ),
        ),
        const SizedBox(height: 16),
        SimpleLineChart(
          temperatureValues: data.temperatureTrend,
          humidityValues: data.humidityTrend,
        ),
        const SizedBox(height: 24),
        Text(
          'Hoạt động gần đây',
          style: GoogleFonts.plusJakartaSans(
            textStyle: AppTextStyles.boxCardTitle,
          ),
        ),
        const SizedBox(height: 12),
        ...data.activityLogs.map(
          (entry) => _ActivityLogTile(entry: entry),
        ),
      ],
    );
  }
}

class _ActivityLogTile extends StatelessWidget {
  const _ActivityLogTile({required this.entry});

  final ActivityLogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.loginInputBorder),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            entry.timeLabel,
            style: GoogleFonts.inter(textStyle: AppTextStyles.activityTime),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              entry.message,
              style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
            ),
          ),
        ],
      ),
    );
  }
}
