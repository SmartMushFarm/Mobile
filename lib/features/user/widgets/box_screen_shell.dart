import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_tab_bar.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';

class BoxScreenShell extends StatelessWidget {
  const BoxScreenShell({
    super.key,
    required this.boxId,
    this.selectedTab,
    this.onTabSelected,
    required this.header,
    required this.body,
  });

  final String boxId;
  final BoxTab? selectedTab;
  final ValueChanged<BoxTab>? onTabSelected;
  final Widget header;
  final Widget body;

  void _onBottomNavSelected(BuildContext context, UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.push('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.push('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.home,
        onItemSelected: (item) => _onBottomNavSelected(context, item),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.clamp(0.0, 448.0);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Column(
                  children: [
                    _BoxTopBar(onMenuTap: () {}),
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            header,
                            const SizedBox(height: 24),
                            if (selectedTab != null && onTabSelected != null)
                              BoxTabBar(
                                selectedTab: selectedTab!,
                                onTabSelected: onTabSelected!,
                              ),
                            if (selectedTab != null && onTabSelected != null)
                              const SizedBox(height: 24),
                            body,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BoxTopBar extends StatelessWidget {
  const _BoxTopBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(
            'assets/images/splash_logo.svg',
            width: 18,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'SmartMush Farmer',
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.homeAppBarTitle,
              ),
            ),
          ),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.more_vert, color: AppColors.loginLabel),
          ),
        ],
      ),
    );
  }
}
