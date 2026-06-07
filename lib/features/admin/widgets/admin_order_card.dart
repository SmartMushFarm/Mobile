import 'package:flutter/material.dart';

enum OrderStatus { pending, processing, shipped, delivered }

class AdminOrderCard extends StatelessWidget {
  final String id;
  final String customer;
  final String items;
  final String total;
  final OrderStatus status;
  final List<String> buttons;

  const AdminOrderCard({
    super.key,
    required this.id,
    required this.customer,
    required this.items,
    required this.total,
    required this.status,
    required this.buttons,
  });

  String get _statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
    }
  }

  Color get _statusColor {
    switch (status) {
      case OrderStatus.pending:
        return const Color(0xFFF59E0B);
      case OrderStatus.processing:
        return const Color(0xFF0EA5E9);
      case OrderStatus.shipped:
        return const Color(0xFF8B5CF6);
      case OrderStatus.delivered:
        return const Color(0xFF22C55E);
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#$id',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            _statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _statusColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFF43B94E).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Color(0xFF43B94E),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            items,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      total,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF22C55E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (buttons.isNotEmpty) ...[
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: buttons.asMap().entries.map((entry) {
                  final idx = entry.key;
                  final btn = entry.value;
                  final isLast = idx == buttons.length - 1;
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: isLast ? 0 : 4, right: isLast ? 0 : 4),
                      child: _OrderButton(
                        label: _buttonLabel(btn),
                        icon: _buttonIcon(btn),
                        color: _buttonColor(btn),
                        onTap: () => _handleButton(context, btn),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _buttonLabel(String btn) {
    switch (btn) {
      case 'confirm':
        return 'Confirm';
      case 'update':
        return 'Update';
      case 'mark_delivered':
        return 'Mark Delivered';
      case 'send_invoice':
        return 'Send Invoice';
      default:
        return btn;
    }
  }

  IconData _buttonIcon(String btn) {
    switch (btn) {
      case 'confirm':
        return Icons.check;
      case 'update':
        return Icons.edit;
      case 'mark_delivered':
        return Icons.local_shipping;
      case 'send_invoice':
        return Icons.send;
      default:
        return Icons.circle;
    }
  }

  Color _buttonColor(String btn) {
    switch (btn) {
      case 'confirm':
        return const Color(0xFF22C55E);
      case 'update':
        return const Color(0xFF0EA5E9);
      case 'mark_delivered':
        return const Color(0xFF8B5CF6);
      case 'send_invoice':
        return const Color(0xFFF59E0B);
      default:
        return const Color(0xFF43B94E);
    }
  }

  void _handleButton(BuildContext context, String btn) {
    switch (btn) {
      case 'confirm':
        _showSnackBar(context, 'Order #$id confirmed');
        break;
      case 'update':
        _showSnackBar(context, 'Updating order #$id...');
        break;
      case 'mark_delivered':
        _showSnackBar(context, 'Order #$id marked as delivered');
        break;
      case 'send_invoice':
        _showSnackBar(context, 'Invoice sent for order #$id');
        break;
    }
  }
}

class _OrderButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _OrderButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
