import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/shop/models/order_item.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: TextStyle(
          fontSize: 11,
          height: 16 / 11,
          fontWeight: FontWeight.w600,
          color: _textColor,
        ),
      ),
    );
  }

  Color get _bgColor {
    switch (status.type) {
      case OrderStatusType.pending:
        return AppColors.orderStatusPendingBg;
      case OrderStatusType.delivering:
        return AppColors.orderStatusDeliveringBg;
      case OrderStatusType.delivered:
        return AppColors.orderStatusDeliveredBg;
      case OrderStatusType.cancelled:
        return AppColors.orderStatusCancelledBg;
    }
  }

  Color get _textColor {
    switch (status.type) {
      case OrderStatusType.pending:
        return AppColors.orderStatusPending;
      case OrderStatusType.delivering:
        return AppColors.orderStatusDelivering;
      case OrderStatusType.delivered:
        return AppColors.orderStatusDelivered;
      case OrderStatusType.cancelled:
        return AppColors.orderStatusCancelled;
    }
  }
}
