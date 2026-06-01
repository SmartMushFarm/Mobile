import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/widgets/box_page_header.dart';
import 'package:smartmush_farmer/features/user/widgets/box_screen_shell.dart';

class BoxLogsScreen extends StatelessWidget {
  const BoxLogsScreen({
    super.key,
    required this.boxId,
  });

  final String boxId;

  @override
  Widget build(BuildContext context) {
    return BoxScreenShell(
      boxId: boxId,
      header: const BoxPageHeader(
        boxName: 'Grow Box',
        statusLabel: 'Optimal',
      ),
      body: Text(
        'Nhật ký hoạt động đầy đủ',
        style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
      ),
    );
  }
}
