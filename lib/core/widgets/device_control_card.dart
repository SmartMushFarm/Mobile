import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class DeviceControlCard extends StatelessWidget {
  const DeviceControlCard({
    super.key,
    required this.icon,
    required this.label,
    required this.statusText,
    required this.isOn,
    required this.onToggle,
    this.isDimmable = false,
    this.subStatusText,
  });

  final IconData icon;
  final String label;
  final String statusText;
  final bool isOn;
  final ValueChanged<bool> onToggle;
  final bool isDimmable;
  final String? subStatusText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.splashTrack),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4CAF50),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: isOn ? 1.0 : 0.6,
                child: Icon(
                  icon,
                  size: 36,
                  color: AppColors.loginLink,
                ),
              ),
              _CustomToggle(isOn: isOn, onToggle: onToggle),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Opacity(
                opacity: isOn ? 1.0 : 0.6,
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.splashTitle,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          statusText,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                            color: isOn ? AppColors.loginLink : AppColors.loginLabel,
                          ),
                        ),
                        if (subStatusText != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subStatusText!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.6,
                              color: AppColors.loginLabel,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CustomToggle extends StatelessWidget {
  const _CustomToggle({
    required this.isOn,
    required this.onToggle,
  });

  final bool isOn;
  final ValueChanged<bool> onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onToggle(!isOn),
      child: ClipRect(
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
      ),
    );
  }
}
