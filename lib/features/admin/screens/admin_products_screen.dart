import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_products_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_product_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = AdminProductsData.summary;
    final products = AdminProductsData.products;

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
                    const SizedBox(height: 20),
                    const Text(
                      'Inventory List',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...products.map((p) => AdminProductCard(
                          id: p['id'] as String,
                          name: p['name'] as String,
                          price: p['price'] as String,
                          stock: p['stock'] as int,
                          stockStatus: _stockStatusFromString(p['status'] as String),
                        )),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Add Product Coming Soon'),
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 4),
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
              'Product Management',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
                letterSpacing: -0.3,
              ),
            ),
          ),
          _HeaderIconButton(
            icon: Icons.search,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _HeaderIconButton(
            icon: Icons.tune,
            onTap: () {},
          ),
          const SizedBox(width: 8),
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
            label: 'Total Inventory',
            value: '${summary['totalInventory']}',
            icon: Icons.inventory_2,
            color: const Color(0xFF43B94E),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Low Stock',
            value: '${summary['lowStock']}',
            icon: Icons.warning,
            color: const Color(0xFFF59E0B),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Out Of stock',
            value: '${summary['outOfStock']}',
            icon: Icons.error_outline,
            color: const Color(0xFFEF4444),
            compact: true,
          ),
        ),
      ],
    );
  }

  ProductStockStatus _stockStatusFromString(String s) {
    switch (s) {
      case 'in_stock':
        return ProductStockStatus.inStock;
      case 'low_stock':
        return ProductStockStatus.lowStock;
      case 'out_of_stock':
        return ProductStockStatus.outOfStock;
      default:
        return ProductStockStatus.inStock;
    }
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
