import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_user_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/admin/data/admin_user_service.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final AdminUserService _userService = AdminUserService();
  List<UserModel> _users = [];
  UserModel? _admin;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        AuthService.fetchMe(),
        _userService.getUsers(),
      ]);
      if (mounted) {
        setState(() {
          _admin = results[0] as UserModel;
          _users = results[1] as List<UserModel>;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = 'Failed to load users. Please try again.';
        });
      }
    }
  }

  Future<void> _loadUsers() async {
    await _loadData();
  }

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _updateUserStatus(UserModel user, String newStatus) async {
    try {
      await _userService.updateUserStatus(id: user.id!, status: newStatus);
      _showSnackBar('Updated status for ${user.name}');
      _loadUsers();
    } catch (e) {
      _showSnackBar('Failed to update status: $e', isError: true);
    }
  }

  void _showEditUserDialog(UserModel user) {
    final nameController = TextEditingController(text: user.name);
    final phoneController = TextEditingController(text: user.phone);
    final addressController = TextEditingController(text: user.address);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit User: ${user.name}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await _userService.updateUser(
                  id: user.id!,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  address: addressController.text.trim(),
                );
                if (mounted) {
                  Navigator.pop(context);
                  _showSnackBar('User updated successfully');
                  _loadUsers();
                }
              } catch (e) {
                if (mounted) _showSnackBar('Update failed: $e', isError: true);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int totalUsers = _users.length;
    int activeUsers = _users.where((u) => u.status?.toLowerCase() == 'active').length;
    int suspendedUsers = _users.where((u) => u.status?.toLowerCase() != 'active').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_error!, style: const TextStyle(color: Colors.red)),
                              const SizedBox(height: 16),
                              ElevatedButton(onPressed: _loadUsers, child: const Text('Retry')),
                            ],
                          ),
                        )
                      : RefreshIndicator(
                          onRefresh: _loadUsers,
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 16),
                                _buildSummaryCards(totalUsers, activeUsers, suspendedUsers),
                                const SizedBox(height: 12),
                                _buildInviteButton(context),
                                const SizedBox(height: 20),
                                const Text(
                                  'User List',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ..._users.map((u) => AdminUserCard(
                                      id: u.id?.toString() ?? '',
                                      name: u.name ?? 'No Name',
                                      email: u.email ?? 'No Email',
                                      devices: u.deviceCount ?? 0,
                                      lastActive: u.lastActive ?? 'Unknown',
                                      status: u.status?.toLowerCase() == 'active' ? UserStatus.active : UserStatus.suspended,
                                      actions: const ['edit', 'status'],
                                      onStatusToggle: () {
                                        final newStatus = u.status?.toLowerCase() == 'active' ? 'Inactive' : 'Active';
                                        _updateUserStatus(u, newStatus);
                                      },
                                      onEdit: () => _showEditUserDialog(u),
                                    )),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String initials = "A";
    if (_admin?.name != null && _admin!.name!.isNotEmpty) {
      initials = _admin!.name![0].toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'SmartFarm Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AdminNotificationBell(badgeCount: 3),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.logout,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/admin/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int total, int active, int suspended) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            label: 'Total Users',
            value: '$total',
            icon: Icons.people,
            color: AppColors.primary,
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Active Users',
            value: '$active',
            icon: Icons.check_circle,
            color: const Color(0xFF22C55E),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Suspended',
            value: '$suspended',
            icon: Icons.block,
            color: const Color(0xFFEF4444),
            compact: true,
          ),
        ),
      ],
    );
  }

  Widget _buildInviteButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Invite User Coming Soon'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Invite User',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.metricIconBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}
