import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_status_badge.dart';

class MaintenanceTicketCard extends StatelessWidget {
  const MaintenanceTicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
    this.onCancel,
  });

  final MaintenanceTicket ticket;
  final VoidCallback onTap;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final canCancel = ticket.status == MaintenanceStatus.pending;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.shopCategoryBorder.withValues(alpha: 0.2),
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.alertCardShadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              ticket.deviceName.toUpperCase(),
                              style: AppTextStyles.maintenanceDeviceLabel,
                            ),
                          ),
                          MaintenanceStatusBadge(status: ticket.status),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.title,
                        style: AppTextStyles.maintenanceTicketTitle,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.description,
                        style: AppTextStyles.maintenanceTicketDesc,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 13,
                            color: AppColors.shopTextSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Gửi: ${DateFormat('dd/MM HH:mm').format(ticket.createdAt)}',
                            style: AppTextStyles.maintenanceSubmittedDate,
                          ),
                          if (ticket.priority.isNotEmpty) ...[
                            const Spacer(),
                            Text(
                              'Ưu tiên: ${ticket.priority}',
                              style: AppTextStyles.maintenanceSubmittedDate.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.shopTextSecondary,
                  size: 20,
                ),
              ],
            ),
            if (canCancel && onCancel != null) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  onPressed: onCancel,
                  icon: const Icon(Icons.cancel_outlined, size: 18, color: Colors.red),
                  label: const Text(
                    'Hủy yêu cầu',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
