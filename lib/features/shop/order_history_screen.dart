import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/order_item.dart';
import 'package:smartmush_farmer/features/shop/widgets/order_card.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  OrderFilter _selectedFilter = OrderFilter.all;

  static const _mockOrders = [
    OrderItem(
      id: '1',
      orderCode: 'SM-829-XJ',
      products: 'Đèn LED trồng nấm thông minh x1, Phôi nấm bào ngư vàng x2',
      date: '24/10/2026',
      total: '3.330.000đ',
      status: OrderStatus.delivering,
    ),
    OrderItem(
      id: '2',
      orderCode: 'SM-761-KQ',
      products: 'Bộ khởi động nấm IoT x1',
      date: '20/10/2026',
      total: '1.490.000đ',
      status: OrderStatus.delivered,
    ),
    OrderItem(
      id: '3',
      orderCode: 'SM-602-LP',
      products: 'Cảm biến khí hậu thông minh x1',
      date: '18/10/2026',
      total: '890.000đ',
      status: OrderStatus.pending,
    ),
  ];

  List<OrderItem> get _filteredOrders {
    if (_selectedFilter == OrderFilter.all) return _mockOrders;
    return _mockOrders
        .where((o) => o.status.type == _selectedFilter.type)
        .toList();
  }

  void _onOrderTap(OrderItem order) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chi tiết đơn hàng sẽ được cập nhật sau'),
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
        context.push('/alerts');
      case UserNavItem.profile:
        context.go('/profile');
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
            _buildFilterChips(),
            Expanded(
              child: _filteredOrders.isEmpty
                  ? _buildEmptyState()
                  : _buildOrderList(),
            ),
            _buildSuggestionCard(),
          ],
        ),
      ),
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.profile,
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
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.go('/profile'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          Text(
            'Lịch sử đơn hàng',
            style: AppTextStyles.registerTitle.copyWith(
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: OrderFilter.values.map((filter) {
            final isActive = _selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.orderChipActiveBg
                        : AppColors.orderChipBg,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    filter.label,
                    style: isActive
                        ? AppTextStyles.orderChipLabelActive
                        : AppTextStyles.orderChipLabel,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 56,
            color: AppColors.shopTextSecondary.withValues(alpha: 0.4),
          ),
          const SizedBox(height: 12),
          Text(
            'Không có đơn hàng nào',
            style: AppTextStyles.loginSubtitle,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      itemCount: _filteredOrders.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = _filteredOrders[index];
        return OrderCard(
          order: order,
          onTap: () => _onOrderTap(order),
        );
      },
    );
  }

  Widget _buildSuggestionCard() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      decoration: const BoxDecoration(
        color: AppColors.orderSuggestionBg,
        border: Border(
          top: BorderSide(color: AppColors.orderCardBorder, width: 0.5),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            const Icon(
              Icons.eco_outlined,
              size: 20,
              color: AppColors.shopPrice,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Cần mua thêm vật tư trồng nấm?',
                style: AppTextStyles.orderSuggestionText,
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => context.go('/shop'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.shopPrice,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  'Đến cửa hàng',
                  style: AppTextStyles.orderChipLabelActive,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
