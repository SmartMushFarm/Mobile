import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_ticket_card.dart';

class MaintenanceRequestsScreen extends StatelessWidget {
  const MaintenanceRequestsScreen({super.key});

  static const _mockTickets = [
    MaintenanceTicket(
      id: 'MT-102',
      deviceName: 'Hộp Nấm Số 1',
      issue: 'Quạt kêu to',
      description: 'Quạt hút bên trái phát ra tiếng ồn bất thường khi hoạt động.',
      submittedDate: 'Hôm nay, 09:30',
      status: MaintenanceStatus.pending,
    ),
    MaintenanceTicket(
      id: 'MT-098',
      deviceName: 'Hộp Nấm Số 2',
      issue: 'Cảm biến độ ẩm lỗi',
      description: 'Giá trị đọc bị kẹt ở 99% dù thực tế đã thấp hơn.',
      submittedDate: 'Hôm qua',
      status: MaintenanceStatus.accepted,
    ),
    MaintenanceTicket(
      id: 'MT-097',
      deviceName: 'Hộp Nấm Số 3',
      issue: 'Đèn LED không phản hồi',
      description: 'Dải LED phổ đỏ đang nhấp nháy bất thường trong quá trình vận hành.',
      submittedDate: '15/05/2026',
      status: MaintenanceStatus.technicianAssigned,
    ),
    MaintenanceTicket(
      id: 'MT-071',
      deviceName: 'Hộp Nấm Số 2',
      issue: 'Lỗi kết nối nguồn điện',
      description: 'Cổng nguồn phía sau cảm thấy lỏng lẽo khi cắm vào.',
      submittedDate: '08/05/2026',
      status: MaintenanceStatus.completed,
    ),
  ];

  void _showDetailSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chi tiết yêu cầu sẽ được cập nhật sau'),
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
    final pendingCount = _mockTickets
        .where((t) => t.status == MaintenanceStatus.pending)
        .length;
    final processingCount = _mockTickets
        .where((t) =>
            t.status == MaintenanceStatus.accepted ||
            t.status == MaintenanceStatus.technicianAssigned)
        .length;
    final completedCount = _mockTickets
        .where((t) => t.status == MaintenanceStatus.completed)
        .length;

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
                      'Bảo trì',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 22,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Theo dõi và quản lý yêu cầu hỗ trợ thiết bị',
                      style: AppTextStyles.loginSubtitle,
                    ),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 20),
                    _buildSummaryCards(pendingCount, processingCount, completedCount),
                    const SizedBox(height: 20),
                    ...List.generate(_mockTickets.length, (index) {
                      final ticket = _mockTickets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MaintenanceTicketCard(
                          ticket: ticket,
                          onTap: () => _showDetailSnackBar(context),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/maintenance/create'),
        backgroundColor: AppColors.primary,
        elevation: 4,
        icon: const Icon(Icons.add, color: Color(0xFF003C0B)),
        label: Text(
          'Tạo yêu cầu',
          style: AppTextStyles.shopBuyNowBtn,
        ),
      ),
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
          const Icon(Icons.eco, size: 20, color: AppColors.shopPrice),
          const SizedBox(width: 8),
          Text(
            'SmartMush Farmer',
            style: AppTextStyles.registerTitle.copyWith(
              fontSize: 18,
              color: AppColors.shopPrice,
            ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.notifications_outlined,
                color: AppColors.shopPrice),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _FilterChip(label: 'Tất cả', isActive: true),
          const SizedBox(width: 8),
          _FilterChip(label: 'Đang xử lý', isActive: false),
          const SizedBox(width: 8),
          _FilterChip(label: 'Hoàn thành', isActive: false),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(int pending, int processing, int completed) {
    return Row(
      children: [
        _SummaryCard(
          value: '$pending',
          label: 'Đang chờ',
          valueColor: AppColors.maintenancePendingText,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          value: '$processing',
          label: 'Đang xử lý',
          valueColor: AppColors.maintenanceAcceptedText,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          value: '$completed',
          label: 'Hoàn thành',
          valueColor: AppColors.maintenanceAssignedText,
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isActive});

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: isActive ? AppColors.shopPrice : const Color(0xFFEFEDED),
        borderRadius: BorderRadius.circular(999),
        border: isActive
            ? null
            : Border.all(
                color: AppColors.shopCategoryBorder.withValues(alpha: 0.3),
              ),
      ),
      child: Text(
        label,
        style: AppTextStyles.maintenanceFilterChip.copyWith(
          color: isActive ? Colors.white : AppColors.shopTextSecondary,
        ),
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
