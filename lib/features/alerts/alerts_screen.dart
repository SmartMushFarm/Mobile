import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/alerts/models/alert_item.dart';
import 'package:smartmush_farmer/features/alerts/widgets/alert_card.dart';
import 'package:smartmush_farmer/features/alerts/widgets/alert_summary_card.dart';
import 'package:smartmush_farmer/features/alerts/services/notification_service.dart';
import 'package:smartmush_farmer/features/alerts/models/notification_model.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final results = await Future.wait([
        _notificationService.getNotifications(page: 1, limit: 50),
        _notificationService.getUnreadCount(),
      ]);

      final notificationData = results[0] as Map<String, dynamic>;
      final unreadCount = results[1] as int;

      List list = [];
      if (notificationData['data'] is List) {
        list = notificationData['data'];
      } else if (notificationData['notifications'] is List) {
        list = notificationData['notifications'];
      }

      setState(() {
        _notifications = list.map((json) => NotificationModel.fromJson(json)).toList();
        _unreadCount = unreadCount;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _markAllRead() async {
    try {
      await _notificationService.markAllAsRead();
      await _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã đánh dấu tất cả là đã đọc'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);
      // Update local state for better UX
      setState(() {
        final index = _notifications.indexWhere((n) => n.id == id);
        if (index != -1) {
          final n = _notifications[index];
          _notifications[index] = NotificationModel(
            id: n.id,
            userId: n.userId,
            deviceId: n.deviceId,
            type: n.type,
            title: n.title,
            message: n.message,
            isRead: true,
            createdAt: n.createdAt,
            updatedAt: n.updatedAt,
          );
          _unreadCount = (_unreadCount - 1).clamp(0, 999);
        }
      });
    } catch (e) {
      // Silent fail or show error
    }
  }

  Future<void> _deleteNotification(int id) async {
    try {
      await _notificationService.deleteNotification(id);
      setState(() {
        _notifications.removeWhere((n) => n.id == id);
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Không thể xóa thông báo: $e')),
        );
      }
    }
  }

  AlertItem _convertToAlertItem(NotificationModel n) {
    AlertSeverity severity = AlertSeverity.info;
    IconData icon = Icons.info_outline;

    switch (n.type.toLowerCase()) {
      case 'critical':
      case 'danger':
        severity = AlertSeverity.critical;
        icon = Icons.warning_amber_rounded;
        break;
      case 'warning':
        severity = AlertSeverity.warning;
        icon = Icons.warning_amber_rounded;
        break;
      case 'automation':
        severity = AlertSeverity.automation;
        icon = Icons.auto_mode;
        break;
      case 'maintenance':
        severity = AlertSeverity.maintenance;
        icon = Icons.build_outlined;
        break;
      case 'device':
        severity = AlertSeverity.device;
        icon = Icons.sensors;
        break;
      default:
        severity = AlertSeverity.info;
        icon = Icons.notifications_none;
    }

    String timestamp = 'Vừa xong';
    if (n.createdAt != null) {
      final now = DateTime.now();
      final diff = now.difference(n.createdAt!);
      if (diff.inMinutes < 1) {
        timestamp = 'Vừa xong';
      } else if (diff.inHours < 1) {
        timestamp = '${diff.inMinutes} phút trước';
      } else if (diff.inDays < 1) {
        timestamp = '${diff.inHours} giờ trước';
      } else {
        timestamp = DateFormat('dd/MM').format(n.createdAt!);
      }
    }

    return AlertItem(
      id: n.id.toString(),
      title: n.title,
      description: n.message,
      timestamp: timestamp,
      severity: severity,
      icon: icon,
      isRead: n.isRead,
      hasViewBox: n.deviceId != null,
      boxId: n.deviceId?.toString(),
    );
  }

  void _onBottomNavSelected(UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.go('/shop');
      case UserNavItem.alerts:
        break;
      case UserNavItem.profile:
        context.push('/profile');
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
            _buildSummaryCards(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Lỗi: $_errorMessage'),
                              ElevatedButton(
                                onPressed: _loadData,
                                child: const Text('Thử lại'),
                              ),
                            ],
                          ),
                        )
                      : _notifications.isEmpty
                          ? const Center(child: Text('Không có thông báo nào'))
                          : RefreshIndicator(
                              onRefresh: _loadData,
                              child: ListView.separated(
                                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                                itemCount: _notifications.length,
                                separatorBuilder: (context, index) => const SizedBox(height: 12),
                                itemBuilder: (context, index) {
                                  final notification = _notifications[index];
                                  return GestureDetector(
                                    onTap: () {
                                      if (!notification.isRead && notification.id != null) {
                                        _markAsRead(notification.id!);
                                      }
                                    },
                                    child: Dismissible(
                                      key: Key(notification.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: const EdgeInsets.only(right: 20),
                                        color: Colors.red,
                                        child: const Icon(Icons.delete, color: Colors.white),
                                      ),
                                      onDismissed: (_) {
                                        if (notification.id != null) {
                                          _deleteNotification(notification.id!);
                                        }
                                      },
                                      child: AlertCard(
                                        alert: _convertToAlertItem(notification),
                                        onMarkRead: () {
                                          if (notification.id != null) {
                                            _markAsRead(notification.id!);
                                          }
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.alerts,
        onItemSelected: _onBottomNavSelected,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // App logo + name
          const Icon(
            Icons.eco,
            size: 20,
            color: AppColors.shopPrice,
          ),
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
          // Delete all button
          if (_notifications.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined, color: Colors.redAccent, size: 22),
              onPressed: () => _showDeleteAllConfirm(),
            ),
          // Mark all read button
          GestureDetector(
            onTap: _unreadCount > 0 ? _markAllRead : null,
            child: Text(
              'Đánh dấu đã đọc',
              style: AppTextStyles.alertSummaryLabel.copyWith(
                color: _unreadCount > 0 ? AppColors.shopPrice : Colors.grey,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter icon
          GestureDetector(
            onTap: _loadData,
            child: const Icon(
              Icons.refresh,
              color: AppColors.shopPrice,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllConfirm() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa tất cả?'),
        content: const Text('Bạn có chắc muốn xóa tất cả thông báo?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await _notificationService.deleteAllNotifications();
                await _loadData();
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Xóa hết', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
      child: Row(
        children: [
          AlertSummaryCard(
            label: 'Chưa đọc',
            value: '$_unreadCount',
            icon: Icons.notifications_active_outlined,
            iconBgColor: AppColors.alertRedBg,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          AlertSummaryCard(
            label: 'Tổng số',
            value: '${_notifications.length}',
            icon: Icons.list_alt,
            iconBgColor: AppColors.alertOfflineBg,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          AlertSummaryCard(
            label: 'Tự động hóa',
            value: '${_notifications.where((n) => n.type.toLowerCase() == 'automation').length}',
            icon: Icons.auto_mode,
            iconBgColor: AppColors.alertGreenBg,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
