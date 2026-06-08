import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/order_model.dart';
import 'package:smartmush_farmer/features/admin/data/admin_order_service.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_order_filter_chip.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_order_card.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:intl/intl.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  final AdminOrderService _adminOrderService = AdminOrderService();
  List<OrderModel> _orders = [];
  UserModel? _admin;
  bool _isLoading = true;
  String? _error;
  String _selectedFilter = 'All Orders';

  final List<String> _filterOptions = ['All Orders', 'Pending', 'Shipping', 'Delivered'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        AuthService.fetchMe(),
        _adminOrderService.getAllOrders(),
      ]);
      setState(() {
        _admin = results[0] as UserModel;
        _orders = results[1] as List<OrderModel>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load orders';
      });
    }
  }

  Future<void> _loadOrders() async {
    _loadData();
  }

  Future<void> _updateOrderStatus(int orderId, String status) async {
    // Optimistic UI update
    final oldOrders = List<OrderModel>.from(_orders);
    setState(() {
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        final oldOrder = _orders[index];
        _orders[index] = OrderModel(
          id: oldOrder.id,
          userId: oldOrder.userId,
          promotionId: oldOrder.promotionId,
          orderDate: oldOrder.orderDate,
          status: status,
          totalAmount: oldOrder.totalAmount,
          shippingAddress: oldOrder.shippingAddress,
          createdAt: oldOrder.createdAt,
          userName: oldOrder.userName,
          details: oldOrder.details,
        );
      }
    });

    try {
      await _adminOrderService.updateOrderStatus(orderId: orderId, status: status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Updated order #$orderId to $status')),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _orders = oldOrders); // Rollback
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status'), backgroundColor: Colors.red),
        );
      }
    }
  }

  List<OrderModel> get _filteredOrders {
    switch (_selectedFilter) {
      case 'Pending':
        return _orders.where((o) => o.status.toLowerCase() == 'pending').toList();
      case 'Shipping':
        return _orders.where((o) => o.status.toLowerCase() == 'shipping').toList();
      case 'Delivered':
        return _orders.where((o) => o.status.toLowerCase() == 'delivered' || o.status.toLowerCase() == 'completed').toList();
      default:
        return _orders;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_error!, style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: 16),
                            ElevatedButton(onPressed: _loadOrders, child: const Text('Retry')),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                  onRefresh: _loadOrders,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16),
                        _buildSummaryCards(),
                        const SizedBox(height: 16),
                        _buildFilterChips(),
                        const SizedBox(height: 16),
                        _buildOrdersList(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 3),
    );
  }

  Widget _buildHeader(BuildContext context) {
    String initials = "A";
    if (_admin?.name != null && _admin!.name!.isNotEmpty) {
      initials = _admin!.name![0].toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.eco, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Orders',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          AdminNotificationBell(badgeCount: 3),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.logout,
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Đăng xuất'),
                  content: const Text('Bạn có chắc chắn muốn đăng xuất không?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Hủy'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await AuthService.logout();
                if (context.mounted) {
                  context.go('/login');
                }
              }
            },
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.go('/admin/profile'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    int total = _orders.length;
    int pending = _orders.where((o) => o.status.toLowerCase() == 'pending').length;
    double revenue = _orders.fold(0.0, (sum, o) => sum + o.totalAmount);

    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            label: 'Total Orders',
            value: '$total',
            icon: Icons.shopping_bag,
            color: const Color(0xFF43B94E),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Pending',
            value: '$pending',
            icon: Icons.pending_actions,
            color: const Color(0xFFF59E0B),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Revenue',
            value: currencyFormat.format(revenue),
            icon: Icons.attach_money,
            color: const Color(0xFF22C55E),
            compact: true,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterOptions.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AdminOrderFilterChip(
              label: filter,
              isActive: _selectedFilter == filter,
              onTap: () => setState(() => _selectedFilter = filter),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildOrdersList() {
    final orders = _filteredOrders;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 12),
        if (orders.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40),
              child: Column(
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 48,
                    color: AppColors.textSecondary.withOpacity(0.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'No orders found',
                    style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          )
        else
          ...orders.map((o) => AdminOrderCard(
                order: o,
                onStatusUpdate: (newStatus) => _updateOrderStatus(o.id, newStatus),
              )),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _HeaderIconButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.metricIconBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.textPrimary, size: 22),
      ),
    );
  }
}
