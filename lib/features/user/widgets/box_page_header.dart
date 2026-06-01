import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/device_status_chip.dart';

class BoxPageHeader extends StatelessWidget {
  const BoxPageHeader({
    super.key,
    required this.boxName,
    required this.statusLabel,
  });

  final String boxName;
  final String statusLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'ĐANG TRỒNG',
                style: GoogleFonts.inter(
                  textStyle: AppTextStyles.activeGrowLabel,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                boxName,
                style: GoogleFonts.plusJakartaSans(
                  textStyle: AppTextStyles.homeGreeting,
                ),
              ),
            ],
          ),
        ),
        OptimalStatusBadge(label: statusLabel),
      ],
    );
  }
}
