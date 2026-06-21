import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_tickets_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_priority_badge.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_ticket_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_stat_card.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_notification_bell.dart';

class AdminTicketsScreen extends StatelessWidget {
  const AdminTicketsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final summary = AdminTicketsData.summary;
    final tickets = AdminTicketsData.tickets;

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
                    _buildSectionHeader(context),
                    const SizedBox(height: 12),
                    ...tickets.map((t) => AdminTicketCard(
                          id: t['id'] as String,
                          title: t['title'] as String,
                          device: t['device'] as String,
                          assigned: t['assigned'] as String?,
                          time: t['time'] as String,
                          priority: _priorityFromString(t['priority'] as String),
                          status: _statusFromString(t['status'] as String),
                          buttons: List<String>.from(t['buttons'] as List),
                          onViewDetails: () => _showDetails(context, t),
                        )),
                    const SizedBox(height: 8),
                    _buildEmptyState(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'MycoAdmin',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const AdminNotificationBell(),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(Map<String, dynamic> summary) {
    return Row(
      children: [
        Expanded(
          child: AdminStatCard(
            label: 'Open Tickets',
            value: '${summary['openTickets']}',
            icon: Icons.confirmation_number,
            color: const Color(0xFFF59E0B),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'High Priority',
            value: '${summary['highPriority']}',
            icon: Icons.priority_high,
            color: const Color(0xFFEF4444),
            compact: true,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AdminStatCard(
            label: 'Completed Today',
            value: '${summary['completedToday']}',
            icon: Icons.check_circle,
            color: const Color(0xFF22C55E),
            compact: true,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      children: [
        const Text(
          'Maintenance Queue',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        const Spacer(),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Filter options coming soon'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.tune, size: 16, color: Color(0xFF6B7280)),
                SizedBox(width: 4),
                Text(
                  'Filter',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.check_circle,
                color: Color(0xFF22C55E),
                size: 30,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'No more active tickets',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'All systems are currently functioning within normal parameters.',
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF6B7280),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, Map<String, dynamic> ticket) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.confirmation_number, color: Color(0xFF6B7280), size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '#${ticket['id']}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ticket['title'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _DetailRow(label: 'Device', value: ticket['device'] as String),
            if (ticket['assigned'] != null)
              _DetailRow(label: 'Assigned', value: ticket['assigned'] as String),
            _DetailRow(label: 'Time', value: ticket['time'] as String),
            _DetailRow(
              label: 'Priority',
              value: (ticket['priority'] as String).toUpperCase(),
            ),
            _DetailRow(label: 'Status', value: (ticket['status'] as String).replaceAll('_', ' ')),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(ctx).padding.bottom),
          ],
        ),
      ),
    );
  }

  TicketPriority _priorityFromString(String s) {
    switch (s) {
      case 'high':
        return TicketPriority.high;
      case 'medium':
        return TicketPriority.medium;
      case 'low':
        return TicketPriority.low;
      default:
        return TicketPriority.medium;
    }
  }

  TicketStatus _statusFromString(String s) {
    switch (s) {
      case 'pending':
        return TicketStatus.pending;
      case 'in_progress':
        return TicketStatus.inProgress;
      case 'completed':
        return TicketStatus.completed;
      default:
        return TicketStatus.pending;
    }
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111827),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
