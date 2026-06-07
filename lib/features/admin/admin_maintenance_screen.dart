import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/data/admin_mock_data.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_app_bar.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_status_badge.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';

class AdminMaintenanceScreen extends StatefulWidget {
  const AdminMaintenanceScreen({super.key});

  @override
  State<AdminMaintenanceScreen> createState() => _AdminMaintenanceScreenState();
}

class _AdminMaintenanceScreenState extends State<AdminMaintenanceScreen> {
  String _selectedFilter = 'Tất cả';

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Tất cả', 'status': null},
    {'label': 'Chờ tiếp nhận', 'status': 'pending'},
    {'label': 'Đã tiếp nhận', 'status': 'accepted'},
    {'label': 'Đã phân công', 'status': 'assigned'},
    {'label': 'Hoàn thành', 'status': 'completed'},
  ];

  @override
  Widget build(BuildContext context) {
    final tickets = AdminMockData.maintenanceTickets;
    final selectedStatus = _filters
        .firstWhere((f) => f['label'] == _selectedFilter)['status'];

    var filtered = selectedStatus == null
        ? tickets
        : tickets.where((t) => t['status'] == selectedStatus).toList();

    final pendingCount = tickets.where((t) => t['status'] == 'pending').length;
    final completedCount = tickets.where((t) => t['status'] == 'completed').length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(title: 'Quản lý bảo trì'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.pending_actions, color: AppColors.warning, size: 22),
                            const SizedBox(height: 8),
                            Text(
                              '$pendingCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.warning,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Chờ tiếp nhận',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle, color: AppColors.success, size: 22),
                            const SizedBox(height: 8),
                            Text(
                              '$completedCount',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.success,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Hoàn thành',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.build, color: AppColors.primary, size: 22),
                            const SizedBox(height: 8),
                            Text(
                              '${tickets.length}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Tổng phiếu',
                              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  height: 38,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _filters.map((f) {
                      final isActive = _selectedFilter == f['label'];
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _selectedFilter = f['label'] as String),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                            decoration: BoxDecoration(
                              color: isActive ? AppColors.primary : AppColors.metricIconBackground,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              f['label'] as String,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isActive ? Colors.white : AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filtered.length,
              itemBuilder: (context, index) => _buildTicketCard(filtered[index]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 5),
    );
  }

  Widget _buildTicketCard(Map<String, dynamic> ticket) {
    final statusConfig = {
      'pending': (AdminStatusType.pending, 'Chờ tiếp nhận', AppColors.warning),
      'accepted': (AdminStatusType.processing, 'Đã tiếp nhận', const Color(0xFF0EA5E9)),
      'assigned': (AdminStatusType.active, 'Đã phân công', AppColors.primary),
      'completed': (AdminStatusType.success, 'Hoàn thành', AppColors.success),
    };
    final entry = statusConfig[ticket['status']] ??
        (AdminStatusType.pending, 'Chờ tiếp nhận', AppColors.warning);

    final urgencyConfig = {
      'high': (AppColors.danger, 'Cao'),
      'medium': (AppColors.warning, 'Trung bình'),
      'low': (AppColors.success, 'Thấp'),
    };
    final urgency = urgencyConfig[ticket['urgency']] ?? (AppColors.warning, 'Trung bình');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: urgency.$1.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.build, color: AppColors.warning, size: 26),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            ticket['deviceName'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: urgency.$1.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Khẩn: ${urgency.$2}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: urgency.$1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      ticket['issue'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.person, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          ticket['userName'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Icon(Icons.access_time, size: 13, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Text(
                          ticket['submittedAt'],
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              AdminStatusBadge(label: entry.$2, type: entry.$1, small: true),
              const Spacer(),
              if (ticket['status'] == 'pending')
                OutlinedButton(
                  onPressed: () => _showAcceptDialog(context, ticket),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Tiếp nhận',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                )
              else if (ticket['status'] == 'accepted')
                OutlinedButton(
                  onPressed: () => _showAssignDialog(context, ticket),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Phân công',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                )
              else if (ticket['status'] == 'assigned')
                OutlinedButton(
                  onPressed: () => _showCompleteDialog(context, ticket),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.success,
                    side: const BorderSide(color: AppColors.success),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Hoàn thành',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAcceptDialog(BuildContext context, Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Tiếp nhận yêu cầu',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(
          'Xác nhận tiếp nhận yêu cầu bảo trì cho ${ticket['deviceName']}?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã tiếp nhận yêu cầu bảo trì'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAssignDialog(BuildContext context, Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Phân công kỹ thuật viên',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: const Text(
          'Chức năng phân công kỹ thuật viên đang được phát triển.',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCompleteDialog(BuildContext context, Map<String, dynamic> ticket) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hoàn thành bảo trì',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        content: Text(
          'Xác nhận hoàn thành bảo trì cho ${ticket['deviceName']}?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Đã hoàn thành bảo trì'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
