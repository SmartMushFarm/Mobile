import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/status_badge.dart';
import 'package:smartmush_farmer/features/user/models/mushroom_box.dart';

class BoxCard extends StatelessWidget {
  const BoxCard({
    super.key,
    required this.box,
    required this.onTap,
    this.onRemove,
  });

  final MushroomBox box;
  final VoidCallback onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.boxCardBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A4CAF50),
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      box.name,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.boxCardTitle,
                      ),
                    ),
                  ),
                  StatusBadge(isOnline: box.isOnline),
                  if (onRemove != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        onTap: (onRemove),
                        child: const Icon(
                          Icons.remove_circle_outline,
                          color: Colors.redAccent,
                          size: 20,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _MetricTile(
                    icon: Icons.thermostat_outlined,
                    label: 'Nhiệt',
                    value: '${box.temperatureCelsius}°C',
                  ),
                  const SizedBox(width: 24),
                  _MetricTile(
                    icon: Icons.water_drop_outlined,
                    label: 'Độ ẩm',
                    value: '${box.humidityPercent}%',
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 9),
                child: Divider(
                  height: 1,
                  color: AppColors.splashTrack,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 9),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _DeviceIcon(
                      icon: Icons.wb_sunny_outlined,
                      isActive: box.lightActive,
                    ),
                    const SizedBox(width: 12),
                    _DeviceIcon(
                      icon: Icons.air,
                      isActive: box.fanActive,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.metricIconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 20, color: AppColors.loginLink),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(textStyle: AppTextStyles.metricLabel),
            ),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.metricValue,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DeviceIcon extends StatelessWidget {
  const _DeviceIcon({
    required this.icon,
    required this.isActive,
  });

  final IconData icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: 20,
      color: isActive ? AppColors.loginLink : AppColors.loginHint,
    );
  }
}
