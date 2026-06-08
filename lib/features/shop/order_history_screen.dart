import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/shop/models/order_model.dart';
import 'package:smartmush_farmer/features/shop/data/order_api_service.dart';
import 'package:smartmush_farmer/features/shop/widgets/order_card.dart';

enum OrderFilter {
  all('Tất cả'),
  pending('Chờ xử lý'),
  delivering('Đang giao'),
  delivered('Đã giao'),
  cancelled('Đã hủy');

  final String label;
  const OrderFilter(this.label);
}

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final OrderApiService _orderService = OrderApiService();
  List<OrderModel> _orders = [];
  bool _isLoading = true;
  String? _error;
  OrderFilter _selectedFilter = OrderFilter.all;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final orders = await _orderService.getMyOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Không thể tải lịch sử đơn hàng. Vui lòng thử lại sau.';
      });
    }
  }

  List<OrderModel> get _filteredOrders {
    if (_selectedFilter == OrderFilter.all) return _orders;
    return _orders.where((o) {
      final status = o.status.toLowerCase();
      switch (_selectedFilter) {
        case OrderFilter.pending:
          return status == 'pending';
        case OrderFilter.delivering:
          return status == 'shipping' || status == 'confirmed';
        case OrderFilter.delivered:
          return status == 'completed' || status == 'delivered';
        case OrderFilter.cancelled:
          return status == 'cancelled';
        default:
          return true;
      }
    }).toList();
  }

  void _onOrderTap(OrderModel order) {
    context.push('/shop/order-detail', extra: order.id);
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
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(_error!, style: AppTextStyles.loginSubtitle),
                              const SizedBox(height: 16),
                              ElevatedButton(onPressed: _loadOrders, child: const Text('Thử lại')),
                            ],
                          ),
                        )
                      : _filteredOrders.isEmpty
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
