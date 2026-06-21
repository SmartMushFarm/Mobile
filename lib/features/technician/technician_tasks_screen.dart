import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/technician/services/technician_service.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_status_badge.dart';
import 'package:go_router/go_router.dart';

class TechnicianTasksScreen extends StatefulWidget {
  const TechnicianTasksScreen({super.key});

  @override
  State<TechnicianTasksScreen> createState() => _TechnicianTasksScreenState();
}

class _TechnicianTasksScreenState extends State<TechnicianTasksScreen> {
  final TechnicianService _service = TechnicianService();
  List<MaintenanceTicket> _tasks = [];
  bool _isLoading = true;
  String _selectedFilter = 'Đang thực hiện';

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      final tasks = await _service.getMyTasks();
      if (mounted) {
        setState(() {
          _tasks = tasks;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi tải công việc: $e')),
        );
      }
    }
  }

  List<MaintenanceTicket> get _filteredTasks {
    if (_selectedFilter == 'Đang thực hiện') {
      return _tasks.where((t) => t.status == MaintenanceStatus.processing).toList();
    } else if (_selectedFilter == 'Đã xong') {
      return _tasks.where((t) => 
        t.status == MaintenanceStatus.waitingConfirmation || 
        t.status == MaintenanceStatus.completed
      ).toList();
    }
    return _tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: const Text('Công việc bảo trì'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await AuthService.logout();
              if (mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchTasks,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredTasks.isEmpty
                      ? const Center(child: Text('Không có công việc nào.'))
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredTasks.length,
                          itemBuilder: (context, index) => _buildTaskCard(_filteredTasks[index]),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: ['Đang thực hiện', 'Đã xong', 'Tất cả'].map((label) {
          final isActive = _selectedFilter == label;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(label),
              selected: isActive,
              onSelected: (v) {
                if (v) setState(() => _selectedFilter = label);
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildTaskCard(MaintenanceTicket task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.deviceName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.shopPrice),
                ),
              ),
              MaintenanceStatusBadge(status: task.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(task.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(task.description, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.priority_high, size: 14, color: Colors.orange),
              const SizedBox(width: 4),
              Text('Ưu tiên: ${task.priority}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const Spacer(),
              if (task.status == MaintenanceStatus.processing)
                ElevatedButton(
                  onPressed: () => _showCompletionDialog(task),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Báo hoàn thành', style: TextStyle(color: Colors.white)),
                )
              else if (task.status == MaintenanceStatus.waitingConfirmation)
                const Text('Đang đợi Admin duyệt', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog(MaintenanceTicket task) {
    final noteController = TextEditingController();
    bool isSubmitting = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Báo cáo hoàn thành'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Vui lòng mô tả ngắn gọn những gì bạn đã xử lý.', style: TextStyle(fontSize: 13, color: Colors.grey)),
              const SizedBox(height: 16),
              TextField(
                controller: noteController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Ví dụ: Đã thay đầu phun sương...',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting ? null : () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: isSubmitting ? null : () async {
                if (noteController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập ghi chú')));
                  return;
                }
                
                setDialogState(() => isSubmitting = true);
                try {
                  await _service.requestCompletion(
                    id: int.parse(task.id),
                    technicianNote: noteController.text.trim(),
                  );
                  if (mounted) {
                    Navigator.pop(ctx);
                    _fetchTasks();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi yêu cầu xác nhận thành công')));
                  }
                } catch (e) {
                  setDialogState(() => isSubmitting = false);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
              child: isSubmitting 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Gửi xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
