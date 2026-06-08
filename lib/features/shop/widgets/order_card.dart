import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/order_model.dart';
import 'package:intl/intl.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  final OrderModel order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');
    final dateFormat = DateFormat('dd/MM/yyyy');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.orderCardBorder),
          boxShadow: const [
            BoxShadow(
              color: AppColors.checkoutCardShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: order code + status badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Mã đơn: #${order.id}',
                  style: AppTextStyles.orderCardId,
                ),
                _buildStatusBadge(order.status),
              ],
            ),
            const SizedBox(height: 10),
            // Date
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: AppColors.shopTextSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  'Ngày đặt: ${dateFormat.format(order.createdAt ?? DateTime.now())}',
                  style: AppTextStyles.orderCardDate,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Products summary
            if (order.details != null && order.details!.isNotEmpty)
              Text(
                order.details!.map((d) => '${d.productName} x${d.quantity}').join(', '),
                style: AppTextStyles.orderCardProducts,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 12),
            // Footer: total + arrow
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng tiền',
                      style: AppTextStyles.orderCardDate,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currencyFormat.format(order.totalAmount),
                      style: AppTextStyles.orderCardTotal,
                    ),
                  ],
                ),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.shopTextSecondary,
                  size: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String label = status;
    switch (status.toLowerCase()) {
      case 'pending': color = Colors.orange; break;
      case 'confirmed': color = Colors.blue; break;
      case 'shipping': color = Colors.purple; break;
      case 'completed':
      case 'delivered': color = Colors.green; break;
      case 'cancelled': color = Colors.red; break;
      default: color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}
