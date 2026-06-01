import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/models/device_item.dart';
import 'package:smartmush_farmer/features/user/widgets/device_card.dart';

class MyDevicesScreen extends StatelessWidget {
  const MyDevicesScreen({super.key});

  static const _mockDevices = [
    DeviceItem(
      id: 'box-1',
      name: 'Hộp Nấm Số 1',
      status: DeviceStatus.online,
      temperature: '25°C',
      humidity: '84%',
      mushroomType: 'Nấm bào ngư',
      isLedOn: true,
      isMistOn: true,
    ),
    DeviceItem(
      id: 'box-2',
      name: 'Hộp Nấm Số 2',
      status: DeviceStatus.online,
      temperature: '24°C',
      humidity: '87%',
      mushroomType: 'Nấm hầu thủ',
      isLedOn: true,
      isMistOn: false,
      isFanOn: true,
    ),
    DeviceItem(
      id: 'box-3',
      name: 'Hộp Nấm Số 3',
      status: DeviceStatus.offline,
      offlineMessage: 'Mất kết nối 15 phút trước',
    ),
  ];

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
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
        context.go('/profile');
    }
  }

  @override
  Widget build(BuildContext context) {
    final onlineCount = _mockDevices.where((d) => d.status == DeviceStatus.online).length;
    final offlineCount = _mockDevices.where((d) => d.status == DeviceStatus.offline).length;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Thiết bị của tôi',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 24,
                        height: 32 / 24,
                        letterSpacing: -0.24,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Quản lý các hệ thống trồng nấm đã kết nối',
                      style: AppTextStyles.loginSubtitle,
                    ),
                    const SizedBox(height: 20),
                    _buildSummaryCards(onlineCount, offlineCount),
                    const SizedBox(height: 24),
                    if (_mockDevices.isEmpty)
                      _buildEmptyState(context)
                    else
                      ...List.generate(_mockDevices.length, (index) {
                        final device = _mockDevices[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: DeviceCard(
                            device: device,
                            onRename: () => _showSnackBar(context, 'Đổi tên thiết bị'),
                            onRestart: () => _showSnackBar(context, 'Khởi động lại thiết bị'),
                            onRetry: () => _showSnackBar(context, 'Đang thử kết nối lại...'),
                            onRemove: () => _showSnackBar(context, 'Xóa thiết bị'),
                            onViewDetails: () => context.push('/box/overview', extra: device.id),
                          ),
                        );
                      }),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _mockDevices.isNotEmpty
          ? FloatingActionButton(
              onPressed: () => _showSnackBar(context, 'Tính năng thêm thiết bị sẽ được cập nhật sau'),
              backgroundColor: AppColors.primary,
              elevation: 4,
              child: const Icon(Icons.add, color: Color(0xFF003C0B)),
            )
          : null,
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.profile,
        onItemSelected: (item) => _onBottomNavSelected(context, item),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
          const SizedBox(width: 8),
          const Icon(Icons.eco, size: 25, color: AppColors.shopPrice),
          const SizedBox(width: 8),
          Text(
            'SmartMush Farmer',
            style: AppTextStyles.registerTitle.copyWith(
              fontSize: 18,
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int online, int offline) {
    return Row(
      children: [
        _SummaryCard(
          value: '$online',
          label: 'Đang hoạt động',
          valueColor: AppColors.shopPrice,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          value: '$offline',
          label: 'Ngoại tuyến',
          valueColor: AppColors.orderStatusCancelled,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          value: '${_mockDevices.length}',
          label: 'Tổng số thiết bị',
          valueColor: const Color(0xFF1B6D24),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.devices_other_outlined,
            size: 64,
            color: AppColors.shopTextSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 16),
          Text(
            'Bạn chưa kết nối thiết bị nào',
            style: AppTextStyles.loginSubtitle,
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: () => _showSnackBar(context, 'Tính năng thêm thiết bị sẽ được cập nhật sau'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.shopPrice,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                'Thêm thiết bị đầu tiên',
                style: AppTextStyles.shopBuyNowBtn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  final String value;
  final String label;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orderCardBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D4CAF50),
              blurRadius: 2,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              value,
              style: AppTextStyles.alertSummaryValue.copyWith(color: valueColor),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTextStyles.alertSummaryLabel,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
