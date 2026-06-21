import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';
import 'package:smartmush_farmer/features/user/services/maintenance_service.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_ticket_card.dart';

class MaintenanceRequestsScreen extends StatefulWidget {
  const MaintenanceRequestsScreen({super.key});

  @override
  State<MaintenanceRequestsScreen> createState() => _MaintenanceRequestsScreenState();
}

class _MaintenanceRequestsScreenState extends State<MaintenanceRequestsScreen> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  List<MaintenanceTicket> _tickets = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final tickets = await _maintenanceService.getMyRequests();
      if (mounted) {
        setState(() {
          _tickets = tickets;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Không thể tải danh sách yêu cầu';
        });
      }
    }
  }

  Future<void> _handleCancelRequest(MaintenanceTicket ticket) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy yêu cầu'),
        content: Text('Bạn có chắc chắn muốn hủy yêu cầu "${ticket.title}" không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Đóng'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Hủy yêu cầu'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        final ticketId = int.tryParse(ticket.id) ?? 0;
        await _maintenanceService.cancelRequest(ticketId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đã hủy yêu cầu thành công')),
          );
          _fetchTickets();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi: ${e.toString()}')),
          );
        }
      }
    }
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

  List<MaintenanceTicket> get _filteredTickets {
    if (_selectedFilter == 'Đang xử lý') {
      return _tickets.where((t) => 
        t.status == MaintenanceStatus.pending || 
        t.status == MaintenanceStatus.received || 
        t.status == MaintenanceStatus.processing ||
        t.status == MaintenanceStatus.waitingConfirmation
      ).toList();
    } else if (_selectedFilter == 'Hoàn thành') {
      return _tickets.where((t) => t.status == MaintenanceStatus.completed).toList();
    }
    return _tickets;
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tickets.where((t) => t.status == MaintenanceStatus.pending).length;
    final processingCount = _tickets.where((t) => 
      t.status == MaintenanceStatus.received || 
      t.status == MaintenanceStatus.processing ||
      t.status == MaintenanceStatus.waitingConfirmation
    ).length;
    final completedCount = _tickets.where((t) => t.status == MaintenanceStatus.completed).length;

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: _fetchTickets,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
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
                      if (_isLoading)
                        const Center(child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: CircularProgressIndicator(),
                        ))
                      else if (_errorMessage != null)
                        Center(child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                        ))
                      else if (_filteredTickets.isEmpty)
                        const Center(child: Padding(
                          padding: EdgeInsets.only(top: 40),
                          child: Text('Chưa có yêu cầu nào.'),
                        ))
                      else
                        ..._filteredTickets.map((ticket) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: MaintenanceTicketCard(
                            ticket: ticket,
                            onTap: () {},
                            onCancel: () => _handleCancelRequest(ticket),
                          ),
                        )),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/maintenance/create').then((_) => _fetchTickets()),
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
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/profile');
              }
            },
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
            icon: const Icon(Icons.refresh, color: AppColors.shopPrice),
            onPressed: _fetchTickets,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Row(
      children: ['Tất cả', 'Đang xử lý', 'Hoàn thành'].map((label) {
        final isActive = _selectedFilter == label;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () => setState(() => _selectedFilter = label),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: isActive ? AppColors.shopPrice : const Color(0xFFEFEDED),
                borderRadius: BorderRadius.circular(999),
                border: isActive ? null : Border.all(color: AppColors.shopCategoryBorder.withValues(alpha: 0.3)),
              ),
              child: Text(
                label,
                style: AppTextStyles.maintenanceFilterChip.copyWith(
                  color: isActive ? Colors.white : AppColors.shopTextSecondary,
                ),
              ),
            ),
          ),
        );
      }).toList(),
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
