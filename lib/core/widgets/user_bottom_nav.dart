import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/alerts/services/notification_service.dart';

enum UserNavItem { home, shop, alerts, profile }

class UserBottomNav extends StatefulWidget {
  const UserBottomNav({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  final UserNavItem currentItem;
  final ValueChanged<UserNavItem> onItemSelected;

  @override
  State<UserBottomNav> createState() => _UserBottomNavState();
}

class _UserBottomNavState extends State<UserBottomNav> {
  int _unreadCount = 0;
  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    try {
      final count = await _notificationService.getUnreadCount();
      if (mounted) {
        setState(() {
          _unreadCount = count;
        });
      }
    } catch (e) {
      // Silent error for bottom nav
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.loginBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A4CAF50),
            blurRadius: 6,
            offset: Offset(0, -4),
            spreadRadius: -1,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 16),
      child: Row(
        children: [
          _NavItemButton(
            label: 'Trang chủ',
            icon: Icons.home_outlined,
            iconActive: Icons.home,
            isActive: widget.currentItem == UserNavItem.home,
            onTap: () => widget.onItemSelected(UserNavItem.home),
          ),
          _NavItemButton(
            label: 'Cửa hàng',
            icon: Icons.shopping_cart_outlined,
            iconActive: Icons.shopping_cart,
            isActive: widget.currentItem == UserNavItem.shop,
            onTap: () => widget.onItemSelected(UserNavItem.shop),
          ),
          _NavItemButton(
            label: 'Thông báo',
            icon: Icons.notifications_outlined,
            iconActive: Icons.notifications,
            isActive: widget.currentItem == UserNavItem.alerts,
            onTap: () => widget.onItemSelected(UserNavItem.alerts),
            badgeCount: _unreadCount,
          ),
          _NavItemButton(
            label: 'Hồ sơ',
            icon: Icons.person_outline,
            iconActive: Icons.person,
            isActive: widget.currentItem == UserNavItem.profile,
            onTap: () => widget.onItemSelected(UserNavItem.profile),
          ),
        ],
      ),
    );
  }
}

class _NavItemButton extends StatelessWidget {
  const _NavItemButton({
    required this.label,
    required this.icon,
    required this.iconActive,
    required this.isActive,
    required this.onTap,
    this.badgeCount = 0,
  });

  final String label;
  final IconData icon;
  final IconData iconActive;
  final bool isActive;
  final VoidCallback onTap;
  final int badgeCount;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? AppColors.navActiveBackground : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(
                    isActive ? iconActive : icon,
                    size: 18,
                    color: isActive ? AppColors.navActiveText : AppColors.loginLabel,
                  ),
                  if (badgeCount > 0)
                    Positioned(
                      right: -6,
                      top: -6,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          badgeCount > 9 ? '9+' : '$badgeCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive ? AppColors.navActiveText : AppColors.loginLabel,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
