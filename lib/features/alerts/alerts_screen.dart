import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/alerts/models/alert_item.dart';
import 'package:smartmush_farmer/features/alerts/widgets/alert_card.dart';
import 'package:smartmush_farmer/features/alerts/widgets/alert_summary_card.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  final List<AlertItem> _alerts = [
    const AlertItem(
      id: '1',
      title: 'Nhiệt độ quá cao',
      description: 'Hộp Nấm Số 1 vượt quá 35°C.',
      timestamp: '2 phút trước',
      severity: AlertSeverity.critical,
      icon: Icons.warning_amber_rounded,
      isRead: false,
      hasViewBox: true,
      boxId: 'box-1',
    ),
    const AlertItem(
      id: '2',
      title: 'Độ ẩm giảm dưới 70%',
      description: 'Tự động hóa đã kích hoạt hệ thống phun sương.',
      timestamp: '15 phút trước',
      severity: AlertSeverity.warning,
      icon: Icons.water_drop_outlined,
      isRead: false,
      automationBadge: 'TỰ ĐỘNG HÓA ĐÃ KÍCH HOẠT',
    ),
    const AlertItem(
      id: '3',
      title: 'Hệ thống phun sương đã bật',
      description: 'Đang ổn định môi trường trồng.',
      timestamp: '1 giờ trước',
      severity: AlertSeverity.automation,
      icon: Icons.cloud_outlined,
      isRead: true,
    ),
    const AlertItem(
      id: '4',
      title: 'Hộp Nấm Số 2 mất kết nối',
      description: 'Đang thử kết nối lại...',
      timestamp: '2 giờ trước',
      severity: AlertSeverity.device,
      icon: Icons.wifi_off,
      isRead: false,
    ),
    const AlertItem(
      id: '5',
      title: 'Yêu cầu bảo trì đang được xử lý',
      description: 'Kỹ thuật viên đã nhận yêu cầu.',
      timestamp: '4 giờ trước',
      severity: AlertSeverity.maintenance,
      icon: Icons.build_outlined,
      isRead: true,
    ),
    const AlertItem(
      id: '6',
      title: 'Đơn hàng phôi nấm đã được giao',
      description: 'Mã vận đơn: SM-8829-XJ',
      timestamp: 'Hôm qua',
      severity: AlertSeverity.info,
      icon: Icons.inventory_2_outlined,
      isRead: true,
    ),
  ];

  int get _activeCount => _alerts.where((a) => !a.isRead).length;

  void _markAllRead() {
    setState(() {
      for (int i = 0; i < _alerts.length; i++) {
        _alerts[i] = AlertItem(
          id: _alerts[i].id,
          title: _alerts[i].title,
          description: _alerts[i].description,
          timestamp: _alerts[i].timestamp,
          severity: _alerts[i].severity,
          icon: _alerts[i].icon,
          isRead: true,
          hasViewBox: _alerts[i].hasViewBox,
          boxId: _alerts[i].boxId,
          automationBadge: _alerts[i].automationBadge,
        );
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã đánh dấu tất cả là đã đọc'),
        behavior: SnackBarBehavior.floating,
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
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                itemCount: _alerts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  return AlertCard(
                    alert: alert,
                    onMarkRead: () => _markAllRead(),
                  );
                },
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
          // Mark all read button
          GestureDetector(
            onTap: _markAllRead,
            child: Text(
              'Đánh dấu đã đọc',
              style: AppTextStyles.alertSummaryLabel.copyWith(
                color: AppColors.shopPrice,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter icon
          GestureDetector(
            onTap: () {},
            child: const Icon(
              Icons.filter_list,
              color: AppColors.shopPrice,
              size: 22,
            ),
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
            label: 'Đang hoạt động',
            value: '$_activeCount',
            icon: Icons.warning_amber_rounded,
            iconBgColor: AppColors.alertRedBg,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          AlertSummaryCard(
            label: 'Thiết bị ngoại tuyến',
            value: '1',
            icon: Icons.wifi_off,
            iconBgColor: AppColors.alertOfflineBg,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          AlertSummaryCard(
            label: 'Tự động hóa hôm nay',
            value: '12',
            icon: Icons.auto_mode,
            iconBgColor: AppColors.alertGreenBg,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
