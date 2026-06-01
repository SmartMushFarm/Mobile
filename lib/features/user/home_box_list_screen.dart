import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/box_card.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/data/mock_boxes.dart';

class HomeBoxListScreen extends StatefulWidget {
  const HomeBoxListScreen({super.key});

  @override
  State<HomeBoxListScreen> createState() => _HomeBoxListScreenState();
}

class _HomeBoxListScreenState extends State<HomeBoxListScreen> {
  UserNavItem _currentNav = UserNavItem.home;

  void _onNavSelected(UserNavItem item) {
    if (item == UserNavItem.home) {
      setState(() => _currentNav = item);
      return;
    }

    switch (item) {
      case UserNavItem.shop:
        context.push('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.push('/profile');
      case UserNavItem.home:
        break;
    }
  }

  void _onAddDevice() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chức năng thêm thiết bị sắp ra mắt'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddDevice,
        backgroundColor: AppColors.loginLink,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: UserBottomNav(
        currentItem: _currentNav,
        onItemSelected: _onNavSelected,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth.clamp(0.0, 448.0);

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: _HomeHeader(),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                      sliver: SliverList.separated(
                        itemCount: mockMushroomBoxes.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final box = mockMushroomBoxes[index];
                          return BoxCard(
                            box: box,
                            onTap: () => context.push(
                              '/box/overview',
                              extra: box.id,
                            ),
                          );
                        },
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

class _HomeHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: AppColors.loginBackground,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/images/splash_logo.svg',
                width: 18,
                height: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'SmartMush Farmer',
                style: GoogleFonts.plusJakartaSans(
                  textStyle: AppTextStyles.homeAppBarTitle,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'T2, 24 thg 10',
                      style: GoogleFonts.inter(
                        textStyle: AppTextStyles.loginSubtitle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chào buổi sáng,',
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.homeGreeting,
                      ),
                    ),
                    Text(
                      'Người trồng nấm',
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.homeGreeting,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.avatarBorder, width: 2),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x1A4CAF50),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/user_avatar.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
