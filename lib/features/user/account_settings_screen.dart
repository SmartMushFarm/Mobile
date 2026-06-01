import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_item.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_section.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_toggle_item.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _notifications = true;
  bool _autoSync = true;
  bool _darkMode = false;

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _logout() {
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

  void _deleteAccount() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa tài khoản'),
        content: const Text(
          'Bạn có chắc muốn xóa tài khoản? Hành động này không thể hoàn tác.',
        ),
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
              'Xóa',
              style: TextStyle(color: AppColors.orderStatusCancelled),
            ),
          ),
        ],
      ),
    );
  }

  void _onBottomNavSelected(UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.go('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.go('/profile');
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Cài đặt tài khoản',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 22,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quản lý hồ sơ, cảm biến và tùy chọn toàn cục.',
                      style: AppTextStyles.loginSubtitle,
                    ),
                    const SizedBox(height: 24),
                    _buildProfileSection(),
                    const SizedBox(height: 24),
                    _buildSecuritySection(),
                    const SizedBox(height: 24),
                    _buildPreferencesSection(),
                    const SizedBox(height: 24),
                    _buildSmartFarmSection(),
                    const SizedBox(height: 24),
                    _buildDangerSection(),
                    const SizedBox(height: 32),
                    _buildAppInfo(),
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
        onItemSelected: _onBottomNavSelected,
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.go('/profile'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.eco, size: 20, color: AppColors.shopPrice),
          const SizedBox(width: 8),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SmartMush',
                style: AppTextStyles.registerTitle.copyWith(
                  fontSize: 16,
                  height: 20 / 16,
                  color: AppColors.shopPrice,
                ),
              ),
              Text(
                'Farmer',
                style: AppTextStyles.registerTitle.copyWith(
                  fontSize: 16,
                  height: 20 / 16,
                  color: AppColors.shopPrice,
                ),
              ),
            ],
          ),
          const Spacer(),
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary,
            child: const Icon(
              Icons.person,
              size: 16,
              color: Color(0xFF003C0B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
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
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.profileAvatarBorder,
                ),
                child: const Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.shopTextSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Farmer Joe',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 20,
                        height: 28 / 20,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'farmer.joe@email.com',
                      style: AppTextStyles.loginSubtitle,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 12,
                          color: AppColors.shopTextSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '0901 234 567',
                          style: AppTextStyles.orderCardDate,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: AppColors.orderCardBorder, height: 1),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => _showSnackBar('Chỉnh sửa hồ sơ'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  'Chỉnh sửa hồ sơ',
                  style: AppTextStyles.settingsItemLabel.copyWith(
                    color: const Color(0xFF003C0B),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecuritySection() {
    return SettingsSection(
      title: 'Bảo mật',
      children: [
        SettingsItem(
          icon: Icons.lock_outline,
          label: 'Đổi mật khẩu',
          onTap: () => _showSnackBar('Đổi mật khẩu'),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsItem(
          icon: Icons.shield_outlined,
          label: 'Xác thực hai lớp',
          onTap: () => _showSnackBar('Xác thực hai lớp'),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsItem(
          icon: Icons.devices_outlined,
          label: 'Thiết bị đã đăng nhập',
          onTap: () => _showSnackBar('Thiết bị đã đăng nhập'),
        ),
      ],
    );
  }

  Widget _buildPreferencesSection() {
    return SettingsSection(
      title: 'Tùy chỉnh ứng dụng',
      children: [
        SettingsToggleItem(
          icon: Icons.dark_mode_outlined,
          label: 'Chế độ tối',
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsToggleItem(
          icon: Icons.notifications_outlined,
          label: 'Thông báo',
          value: _notifications,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsItem(
          icon: Icons.thermostat_outlined,
          label: 'Đơn vị nhiệt độ',
          value: '°C',
          onTap: () => _showSnackBar('Đơn vị nhiệt độ'),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsItem(
          icon: Icons.language,
          label: 'Ngôn ngữ',
          value: 'Tiếng Việt',
          onTap: () => _showSnackBar('Ngôn ngữ'),
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsToggleItem(
          icon: Icons.sync,
          label: 'Tự động đồng bộ',
          value: _autoSync,
          onChanged: (v) => setState(() => _autoSync = v),
        ),
      ],
    );
  }

  Widget _buildSmartFarmSection() {
    return SettingsSection(
      title: 'Cài đặt nông trại thông minh',
      children: [
        _SmartFarmCard(
          icon: Icons.water_drop_outlined,
          badgeLabel: 'ĐANG HOẠT ĐỘNG',
          badgeActive: true,
          title: 'Ngưỡng độ ẩm mặc định',
          subtitle: 'Duy trì khoảng 85% - 92%',
          onTap: () => _showSnackBar('Ngưỡng độ ẩm mặc định'),
        ),
        const Divider(height: 1, indent: 17, color: AppColors.orderCardBorder),
        _SmartFarmCard(
          icon: Icons.thermostat_outlined,
          badgeLabel: 'CHỈNH SỬA',
          badgeActive: false,
          title: 'Ngưỡng nhiệt độ mặc định',
          subtitle: 'Cảnh báo khi > 28°C',
          onTap: () => _showSnackBar('Ngưỡng nhiệt độ mặc định'),
        ),
        const Divider(height: 1, indent: 17, color: AppColors.orderCardBorder),
        _SmartFarmCard(
          icon: Icons.auto_mode,
          badgeLabel: 'TỐI ƯU',
          badgeActive: true,
          title: 'Cài đặt tự động hóa',
          subtitle: 'Chu trình thông minh quạt CO2',
          onTap: () => _showSnackBar('Cài đặt tự động hóa'),
        ),
      ],
    );
  }

  Widget _buildDangerSection() {
    return SettingsSection(
      title: 'Vùng nguy hiểm',
      isDanger: true,
      children: [
        SettingsItem(
          icon: Icons.logout,
          label: 'Đăng xuất',
          labelColor: AppColors.orderStatusCancelled,
          onTap: _logout,
        ),
        const Divider(height: 1, indent: 68, color: AppColors.orderCardBorder),
        SettingsItem(
          icon: Icons.delete_forever_outlined,
          label: 'Xóa tài khoản',
          labelColor: AppColors.orderStatusCancelled,
          onTap: _deleteAccount,
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Column(
      children: [
        Text(
          'SmartMush Farmer v1.0',
          style: AppTextStyles.settingsItemValue.copyWith(
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          'Kết nối qua IoT-Secure Grid',
          style: AppTextStyles.settingsItemValue.copyWith(
            fontSize: 12,
            color: const Color(0xFF6F7A6B),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _SmartFarmCard extends StatelessWidget {
  const _SmartFarmCard({
    required this.icon,
    required this.badgeLabel,
    required this.badgeActive,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String badgeLabel;
  final bool badgeActive;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(17),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: AppColors.shopTextPrimary),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: badgeActive
                        ? AppColors.alertGreenBg
                        : AppColors.alertOfflineBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    badgeLabel,
                    style: badgeActive
                        ? AppTextStyles.settingsSmartFarmBadge
                        : AppTextStyles.settingsSmartFarmBadgeInactive,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.settingsItemLabel,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: AppTextStyles.settingsItemValue,
            ),
          ],
        ),
      ),
    );
  }
}
