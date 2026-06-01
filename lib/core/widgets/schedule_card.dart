import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({
    super.key,
    required this.title,
    required this.scheduleText,
    required this.isEnabled,
    required this.onToggle,
    this.onEdit,
  });

  final String title;
  final String scheduleText;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.splashTrack),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.splashTitle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  scheduleText,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.loginLabel,
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ScheduleToggle(isOn: isEnabled, onToggle: onToggle),
              if (onEdit != null) ...[
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: onEdit,
                  child: const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.loginLabel,
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

class _ScheduleToggle extends StatelessWidget {
  const _ScheduleToggle({
    required this.isOn,
    required this.onToggle,
  });

  final bool isOn;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isOn),
      child: SizedBox(
        width: 52,
        height: 32,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: isOn
                      ? const Color(0xFF68D391)
                      : AppColors.splashTrack,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              top: isOn ? -4 : 0,
              right: isOn ? -4 : 0,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: isOn ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isOn ? AppColors.primary : AppColors.splashTrack,
                    width: 4,
                  ),
                ),
                child: isOn
                    ? const Icon(
                        Icons.power_settings_new,
                        size: 14,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
