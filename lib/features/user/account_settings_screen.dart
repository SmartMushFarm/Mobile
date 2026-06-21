import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_item.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_section.dart';
import 'package:smartmush_farmer/features/user/widgets/settings_toggle_item.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  bool _notifications = true;
  bool _autoSync = true;
  bool _darkMode = false;

  UserModel? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    // Thử lấy user từ storage trước để tránh flicker UI (admin/user bottom nav)
    final userMap = await AuthService.getCurrentUser();
    if (userMap != null) {
      setState(() {
        _user = UserModel.fromJson(userMap);
      });
    }
    // Sau đó mới load data mới nhất từ API
    _loadUser();
  }

  Future<void> _loadUser() async {
    // Nếu đã có user từ storage rồi thì không hiện loading to đùng nữa
    if (_user == null) {
      setState(() => _isLoading = true);
    }
    
    try {
      final user = await AuthService.fetchMe();
      if (mounted) {
        setState(() {
          _user = user;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
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
            onPressed: () async {
              await AuthService.logout();
              if (mounted) {
                Navigator.pop(ctx);
                context.go('/login');
              }
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

  void _showEditProfileDialog() {
    final nameController = TextEditingController(text: _user?.name);
    final phoneController = TextEditingController(text: _user?.phone);
    final addressController = TextEditingController(text: _user?.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa hồ sơ'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Họ và tên'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Địa chỉ'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                _showSnackBar('Tên không được để trống', isError: true);
                return;
              }
              try {
                final updatedUser = await AuthService.updateMe(
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );
                setState(() => _user = updatedUser);
                if (mounted) {
                  Navigator.pop(context);
                  _showSnackBar('Cập nhật hồ sơ thành công');
                }
              } catch (e) {
                if (mounted) _showSnackBar('Cập nhật thất bại: $e', isError: true);
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() async {
    // 1. Hiện thông báo đang gửi OTP
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 2. Gọi API gửi OTP ngay lập tức
      await AuthService.requestChangePasswordOTP();
      if (mounted) {
        Navigator.pop(context); // Đóng loading
        _showVerifyAndChangePasswordDialog(); // Hiện form nhập liệu
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Đóng loading
        _showSnackBar('Không thể gửi mã OTP. Vui lòng thử lại.', isError: true);
      }
    }
  }

  void _showVerifyAndChangePasswordDialog() {
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();
    final otpController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Xác thực đổi mật khẩu'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mã OTP đã được gửi đến email của bạn. Vui lòng kiểm tra và nhập thông tin bên dưới.',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: otpController,
                  decoration: const InputDecoration(
                    labelText: 'Mã OTP (6 số)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Xác nhận mật khẩu mới',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : () async {
                if (otpController.text.length < 6) {
                  _showSnackBar('Vui lòng nhập đủ mã OTP', isError: true);
                  return;
                }
                if (newPasswordController.text != confirmPasswordController.text) {
                  _showSnackBar('Mật khẩu xác nhận không khớp', isError: true);
                  return;
                }
                if (newPasswordController.text.length < 8) {
                  _showSnackBar('Mật khẩu phải từ 8 ký tự', isError: true);
                  return;
                }

                setDialogState(() => isSubmitting = true);
                try {
                  await AuthService.changePasswordOTP(
                    otp: otpController.text.trim(),
                    newPassword: newPasswordController.text,
                  );
                  if (mounted) {
                    Navigator.pop(context);
                    _showSnackBar('Đổi mật khẩu thành công');
                  }
                } catch (e) {
                  setDialogState(() => isSubmitting = false);
                  _showSnackBar('Mã OTP không đúng hoặc đã hết hạn', isError: true);
                }
              },
              child: isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Xác nhận'),
            ),
          ],
        ),
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
        if (_user?.role == 'admin') {
          context.go('/admin/profile');
        } else {
          context.go('/profile');
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Xác định bottom nav dựa trên role
    Widget? bottomNav;
    if (_user != null) {
      bottomNav = _user?.role == 'admin'
          ? const AdminBottomNav(currentIndex: 4)
          : UserBottomNav(
              currentItem: UserNavItem.profile,
              onItemSelected: _onBottomNavSelected,
            );
    }

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: (_isLoading && _user == null) 
          ? const Center(child: CircularProgressIndicator())
          : Column(
          children: [
            _buildHeader(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadUser,
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
                      _buildDangerSection(),
                      const SizedBox(height: 32),
                      _buildAppInfo(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: bottomNav,
    );
  }

  Widget _buildHeader() {
    String initials = "A";
    if (_user?.name != null && _user!.name!.isNotEmpty) {
      initials = _user!.name![0].toUpperCase();
    }

    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () {
              if (_user?.role == 'admin') {
                context.go('/admin/profile');
              } else {
                context.go('/profile');
              }
            },
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
            child: Text(
              initials,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF003C0B),
              ),
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
                child: Center(
                  child: Text(
                    (_user?.name != null && _user!.name!.isNotEmpty) ? _user!.name![0].toUpperCase() : "A",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.shopTextSecondary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.name ?? 'Chưa cập nhật',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 20,
                        height: 28 / 20,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _user?.email ?? 'Chưa cập nhật',
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
                          _user?.phone ?? 'Chưa cập nhật',
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
            onTap: _showEditProfileDialog,
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
          onTap: _showChangePasswordDialog,
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
