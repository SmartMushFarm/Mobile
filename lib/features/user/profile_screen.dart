import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/widgets/profile_menu_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const _avatarUrl =
      'https://www.figma.com/api/mcp/asset/e3f455fa-3d3c-477f-9403-67e769798b24';

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/login');
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(color: AppColors.orderStatusCancelled),
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavSelected(BuildContext context, UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.go('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    _buildAvatar(),
                    const SizedBox(height: 16),
                    _buildUserInfo(),
                    const SizedBox(height: 24),
                    _buildFarmOperationsSection(context),
                    const SizedBox(height: 24),
                    _buildAccountSection(context),
                    const SizedBox(height: 32),
                    _buildLogoutButton(context),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.profile,
        onItemSelected: (item) => _onBottomNavSelected(context, item),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          const Icon(
            Icons.eco,
            size: 20,
            color: AppColors.shopPrice,
          ),
          const SizedBox(width: 12),
          Text(
            'SmartMush Farmer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return Stack(
      children: [
        Container(
          width: 112,
          height: 112,
          decoration: BoxDecoration(
            color: AppColors.profileAvatarBorder,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.loginBackground,
              width: 4,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x264CAF50),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Image.network(
            _avatarUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.person,
              size: 56,
              color: AppColors.shopTextSecondary,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.shopPrice,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.loginBackground,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.camera_alt,
              size: 14,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    return Column(
      children: [
        Text(
          'Farmer Joe',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: AppColors.shopTextPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Người trồng nấm',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.shopTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.shopCategoryBorder.withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.alertCardShadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(17),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: AppTextStyles.profileSectionHeader,
      ),
    );
  }

  Widget _buildFarmOperationsSection(BuildContext context) {
    return _buildSectionCard(
      children: [
        _buildSectionHeader('Hoạt động nông trại'),
        ProfileMenuItem(
          icon: Icons.developer_board_outlined,
          label: 'Thiết bị của tôi',
          onTap: () => context.push('/profile/devices'),
        ),
        const Divider(color: AppColors.orderCardBorder, height: 1),
        ProfileMenuItem(
          icon: Icons.build_outlined,
          label: 'Bảo trì',
          onTap: () => context.push('/maintenance'),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    return _buildSectionCard(
      children: [
        _buildSectionHeader('Tài khoản & mua hàng'),
        ProfileMenuItem(
          icon: Icons.settings_outlined,
          label: 'Cài đặt tài khoản',
          onTap: () => context.push('/profile/settings'),
        ),
        const Divider(color: AppColors.orderCardBorder, height: 1),
        ProfileMenuItem(
          icon: Icons.receipt_long_outlined,
          label: 'Lịch sử đơn hàng',
          onTap: () => context.push('/shop/order-history'),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _logout(context),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x334CAF50),
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout,
              size: 18,
              color: Color(0xFF003C0B),
            ),
            const SizedBox(width: 8),
            Text(
              'Đăng xuất',
              style: AppTextStyles.profileLogoutBtn,
            ),
          ],
        ),
      ),
    );
  }
}
