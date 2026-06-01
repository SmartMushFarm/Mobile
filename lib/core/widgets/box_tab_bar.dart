import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum BoxTab { overview, control, automation }

class BoxTabBar extends StatelessWidget {
  const BoxTabBar({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final BoxTab selectedTab;
  final ValueChanged<BoxTab> onTabSelected;

  static const _tabs = [
    (BoxTab.overview, 'Tổng quan'),
    (BoxTab.control, 'Điều khiển'),
    (BoxTab.automation, 'Tự động'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.splashTrack),
        ),
      ),
      child: Row(
        children: _tabs.map((tab) {
          final isSelected = tab.$1 == selectedTab;
          return Expanded(
            child: InkWell(
              onTap: () => onTabSelected(tab.$1),
              child: Container(
                padding: const EdgeInsets.only(bottom: 14),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.loginLink
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tab.$2,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    textStyle: isSelected
                        ? AppTextStyles.boxTabActive
                        : AppTextStyles.boxTabInactive,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
