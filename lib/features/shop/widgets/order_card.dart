import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/order_item.dart';
import 'package:smartmush_farmer/features/shop/widgets/order_status_badge.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
  });

  final OrderItem order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
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
                  'Mã đơn: ${order.orderCode}',
                  style: AppTextStyles.orderCardId,
                ),
                OrderStatusBadge(status: order.status),
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
                  'Ngày đặt: ${order.date}',
                  style: AppTextStyles.orderCardDate,
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Products
            Text(
              order.products,
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
                      order.total,
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
}
