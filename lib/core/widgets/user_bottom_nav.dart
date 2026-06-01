import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum UserNavItem { home, shop, alerts, profile }

class UserBottomNav extends StatelessWidget {
  const UserBottomNav({
    super.key,
    required this.currentItem,
    required this.onItemSelected,
  });

  final UserNavItem currentItem;
  final ValueChanged<UserNavItem> onItemSelected;

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
            isActive: currentItem == UserNavItem.home,
            onTap: () => onItemSelected(UserNavItem.home),
          ),
          _NavItemButton(
            label: 'Cửa hàng',
            icon: Icons.shopping_cart_outlined,
            iconActive: Icons.shopping_cart,
            isActive: currentItem == UserNavItem.shop,
            onTap: () => onItemSelected(UserNavItem.shop),
          ),
          _NavItemButton(
            label: 'Thông báo',
            icon: Icons.notifications_outlined,
            iconActive: Icons.notifications,
            isActive: currentItem == UserNavItem.alerts,
            onTap: () => onItemSelected(UserNavItem.alerts),
          ),
          _NavItemButton(
            label: 'Hồ sơ',
            icon: Icons.person_outline,
            iconActive: Icons.person,
            isActive: currentItem == UserNavItem.profile,
            onTap: () => onItemSelected(UserNavItem.profile),
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
  });

  final String label;
  final IconData icon;
  final IconData iconActive;
  final bool isActive;
  final VoidCallback onTap;

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
              Icon(
                isActive ? iconActive : icon,
                size: 18,
                color: isActive ? AppColors.navActiveText : AppColors.loginLabel,
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
