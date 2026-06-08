import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';

class AdminProfileScreen extends StatefulWidget {
  const AdminProfileScreen({super.key});

  @override
  State<AdminProfileScreen> createState() => _AdminProfileScreenState();
}

class _AdminProfileScreenState extends State<AdminProfileScreen> {
  UserModel? _admin;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAdmin();
  }

  Future<void> _loadAdmin() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final admin = await AuthService.fetchMe();
      if (mounted) {
        setState(() {
          _admin = admin;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    String initials = "A";
    if (_admin?.name != null && _admin!.name!.isNotEmpty) {
      initials = _admin!.name![0].toUpperCase();
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                              border: Border.all(color: AppColors.primary, width: 2),
                            ),
                            child: Center(
                              child: Text(
                                initials,
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            _admin?.name ?? 'Admin',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            _admin?.email ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          _buildInfoTile(Icons.phone, 'Phone', _admin?.phone ?? 'Not set'),
                          _buildInfoTile(Icons.location_on, 'Address', _admin?.address ?? 'Not set'),
                          _buildInfoTile(Icons.admin_panel_settings, 'Role', _admin?.role?.toUpperCase() ?? 'ADMIN'),
                          const SizedBox(height: 40),
                          const Text(
                            'Admin Settings',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Account Settings'),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () {
                              context.push('/admin/profile/settings');
                            },
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      subtitle: Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: const Row(
        children: [
          SizedBox(width: 52),
          Expanded(
            child: Text(
              'Admin Profile',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 52),
        ],
      ),
    );
  }
}
