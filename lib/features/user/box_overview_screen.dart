import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/features/user/data/mock_box_overview.dart';
import 'package:smartmush_farmer/features/user/widgets/box_overview_tab_content.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';

class BoxOverviewScreen extends StatelessWidget {
  const BoxOverviewScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  void _onTabSelected(BuildContext context, BoxTab tab) {
    switch (tab) {
      case BoxTab.overview:
        break;
      case BoxTab.control:
        context.push('/box/control', extra: boxId);
      case BoxTab.automation:
        context.push('/box/automation', extra: boxId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = mockBoxOverviewFor(boxId);

    if (data == null) {
      return Scaffold(
        backgroundColor: AppColors.loginBackground,
        appBar: AppBar(
          backgroundColor: AppColors.loginBackground,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.pop(),
          ),
        ),
        body: Center(
          child: Text(
            'Không tìm thấy hộp',
            style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
          ),
        ),
      );
    }

    return BoxScreenShell(
      boxId: boxId,
      selectedTab: BoxTab.overview,
      onTabSelected: (tab) => _onTabSelected(context, tab),
      header: BoxPageHeader(
        boxName: data.name,
        statusLabel: data.growStatusLabel,
      ),
      body: BoxOverviewTabContent(data: data),
    );
  }
}
