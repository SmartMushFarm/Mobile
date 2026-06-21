import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/alerts/services/notification_service.dart';

class AdminNotificationBell extends StatefulWidget {
  const AdminNotificationBell({
    super.key,
  });

  @override
  State<AdminNotificationBell> createState() => _AdminNotificationBellState();
}

class _AdminNotificationBellState extends State<AdminNotificationBell> {
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
      // Silent error
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/admin/alerts'),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.metricIconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: AppColors.textPrimary,
                size: 22,
              ),
            ),
            if (_unreadCount > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      _unreadCount > 9 ? '9+' : '$_unreadCount',
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
