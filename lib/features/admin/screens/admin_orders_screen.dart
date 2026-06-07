import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_orders_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_order_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_order_filter_chip.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  String _selectedFilter = 'All Orders';

  List<Map<String, dynamic>> get _filteredOrders {
    final all = AdminOrdersData.orders;
    switch (_selectedFilter) {
      case 'Pending':
        return all.where((o) => o['status'] == 'pending').toList();
      case 'Shipping':
        return all.where((o) => o['status'] == 'shipped').toList();
      case 'Delivered':
        return all.where((o) => o['status'] == 'delivered').toList();
      default:
        return all;
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = AdminOrdersData.summary;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildSummaryCards(summary),
                    const SizedBox(height: 16),
                    _buildFilterChips(),
                    const SizedBox(height: 16),
                    _buildOrdersList(),
                    const SizedBox(height: 16),
                  ],
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
              'SmartFarm Admin',
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
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Text(
                  'A',
                  style: TextStyle(
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

  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            label: 'Orders Today',
            value: '${summary['ordersToday']}',
            icon: Icons.shopping_bag,
            color: const Color(0xFF43B94E),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Pending',
            value: '${summary['pendingOrders']}',
            icon: Icons.pending_actions,
            color: const Color(0xFFF59E0B),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Revenue Today',
            value: summary['revenueToday'] as String,
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
        children: AdminOrdersData.filterOptions.map((filter) {
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
          'Recent Activity',
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
                    color: AppColors.textSecondary.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No orders',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...orders.map((o) => AdminOrderCard(
                id: o['id'] as String,
                customer: o['customer'] as String,
                items: o['items'] as String,
                total: o['total'] as String,
                status: _statusFromString(o['status'] as String),
                buttons: List<String>.from(o['buttons'] as List),
              )),
      ],
    );
  }

  OrderStatus _statusFromString(String s) {
    switch (s) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.pending;
    }
  }
}
