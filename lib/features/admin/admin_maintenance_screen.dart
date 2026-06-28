import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_app_bar.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/admin/data/admin_maintenance_service.dart';
import 'package:smartmush_farmer/features/user/models/maintenance_ticket.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_status_badge.dart';

class AdminMaintenanceScreen extends StatefulWidget {
  const AdminMaintenanceScreen({super.key});

  @override
  State<AdminMaintenanceScreen> createState() => _AdminMaintenanceScreenState();
}

class _AdminMaintenanceScreenState extends State<AdminMaintenanceScreen> {
  final AdminMaintenanceService _service = AdminMaintenanceService();
  List<MaintenanceTicket> _tickets = [];
  bool _isLoading = true;
  String _selectedFilter = 'Tất cả';

  final List<Map<String, dynamic>> _filters = [
    {'label': 'Tất cả', 'status': null},
    {'label': 'Chờ duyệt', 'status': 'Pending'},
    {'label': 'Đã tiếp nhận', 'status': 'Received'},
    {'label': 'Đang xử lý', 'status': 'Processing'},
    {'label': 'Đợi xác nhận', 'status': 'WaitingConfirmation'},
    {'label': 'Hoàn thành', 'status': 'Completed'},
  ];

  @override
  void initState() {
    super.initState();
    _fetchTickets();
  }

  Future<void> _fetchTickets() async {
    setState(() => _isLoading = true);
    try {
      final status = _filters.firstWhere((f) => f['label'] == _selectedFilter)['status'];
      final data = await _service.getAllRequests(status: status);
      setState(() {
        _tickets = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi tải dữ liệu: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pendingCount = _tickets.where((t) => t.status == MaintenanceStatus.pending).length;
    final processingCount = _tickets.where((t) => t.status == MaintenanceStatus.processing).length;
    final completedCount = _tickets.where((t) => t.status == MaintenanceStatus.completed).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(title: 'Quản lý bảo trì', showBack: true),
      body: Column(
        children: [
          _buildSummarySection(pendingCount, processingCount, completedCount),
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchTickets,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _tickets.isEmpty
                      ? _buildEmptyState()
                      : ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _tickets.length,
                          itemBuilder: (context, index) => _buildTicketCard(_tickets[index]),
                        ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 5),
    );
  }

  Widget _buildSummarySection(int pending, int processing, int completed) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: Row(
        children: [
          _SummaryBox(label: 'Chờ duyệt', value: '$pending', color: AppColors.warning),
          const SizedBox(width: 12),
          _SummaryBox(label: 'Đang sửa', value: '$processing', color: Colors.blue),
          const SizedBox(width: 12),
          _SummaryBox(label: 'Xong', value: '$completed', color: AppColors.success),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 50,
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index]['label'];
          final isActive = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isActive,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedFilter = filter);
                  _fetchTickets();
                }
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTicketCard(MaintenanceTicket ticket) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(ticket.deviceName, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              MaintenanceStatusBadge(status: ticket.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(ticket.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(ticket.description, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(Icons.access_time, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(DateFormat('dd/MM HH:mm').format(ticket.createdAt), 
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const Spacer(),
              _buildActions(ticket),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActions(MaintenanceTicket ticket) {
    switch (ticket.status) {
      case MaintenanceStatus.pending:
        return ElevatedButton(
          onPressed: () => _handleApprove(ticket),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
          child: const Text('Duyệt', style: TextStyle(color: Colors.white)),
        );
      case MaintenanceStatus.received:
        return ElevatedButton(
          onPressed: () => _showScheduleDialog(ticket),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
          child: const Text('Đặt lịch', style: TextStyle(color: Colors.white)),
        );
      case MaintenanceStatus.waitingConfirmation:
        return ElevatedButton(
          onPressed: () => _handleConfirm(ticket),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
          child: const Text('Xác nhận xong', style: TextStyle(color: Colors.white)),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Future<void> _handleApprove(MaintenanceTicket ticket) async {
    try {
      await _service.approveRequest(int.parse(ticket.id));
      _fetchTickets();
      _showSnackBar('Đã tiếp nhận yêu cầu. Vui lòng Đặt lịch.');
    } catch (e) {
      _showSnackBar(_parseDioError(e), isError: true);
    }
  }

  Future<void> _handleConfirm(MaintenanceTicket ticket) async {
    try {
      await _service.confirmCompleted(int.parse(ticket.id));
      _fetchTickets();
      _showSnackBar('Đã xác nhận hoàn thành');
    } catch (e) {
      _showSnackBar(_parseDioError(e), isError: true);
    }
  }

  String _parseDioError(dynamic e) {
    if (e is DioException && e.response != null) {
      return "Status: ${e.response?.statusCode}\nData: ${e.response?.data}";
    }
    return e.toString();
  }

  void _showScheduleDialog(MaintenanceTicket ticket) {
    final noteController = TextEditingController();
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedPriority = 'Normal'; // Đổi từ Medium sang Normal
    int? selectedTechId;
    List<dynamic> technicians = [];
    bool isLoadingTechs = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          if (technicians.isEmpty && isLoadingTechs) {
            _service.getUsersByRole('Technician').then((list) {
              setDialogState(() {
                technicians = list;
                isLoadingTechs = false;
                if (technicians.isNotEmpty) {
                  // Ép kiểu ID về int để khớp với DropdownButtonFormField<int>
                  final firstId = technicians[0]['id'];
                  selectedTechId = firstId is int ? firstId : int.tryParse(firstId.toString());
                }
              });
            }).catchError((e) {
              setDialogState(() => isLoadingTechs = false);
            });
          }

          return AlertDialog(
            title: const Text('Đặt lịch bảo trì', style: TextStyle(fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Vui lòng gán kỹ thuật viên, chọn thời gian và mức độ ưu tiên.', 
                    style: TextStyle(fontSize: 13, color: Colors.grey)),
                  const SizedBox(height: 16),
                  if (isLoadingTechs)
                    const Center(child: CircularProgressIndicator())
                  else if (technicians.isEmpty)
                    const Text('Không tìm thấy kỹ thuật viên nào', style: TextStyle(color: Colors.red))
                  else
                    DropdownButtonFormField<int>(
                      value: selectedTechId,
                      decoration: const InputDecoration(
                        labelText: 'Chọn Kỹ thuật viên *',
                        border: OutlineInputBorder(),
                      ),
                      items: technicians.map((tech) {
                        // Ép kiểu ID từng item về int
                        final id = tech['id'] is int ? tech['id'] : int.tryParse(tech['id'].toString());
                        return DropdownMenuItem<int>(
                          value: id,
                          child: Text(tech['name'] ?? 'KTV #$id'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setDialogState(() => selectedTechId = val);
                      },
                    ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: selectedPriority,
                    decoration: const InputDecoration(
                      labelText: 'Mức độ ưu tiên',
                      border: OutlineInputBorder(),
                    ),
                    items: ['Low', 'Normal', 'High', 'Urgent'].map((p) => DropdownMenuItem(
                      value: p,
                      child: Text(p),
                    )).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedPriority = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController, 
                    decoration: const InputDecoration(
                      labelText: 'Ghi chú của Admin',
                      hintText: 'Ví dụ: Hẹn khách lúc 9h sáng',
                      border: OutlineInputBorder(),
                    )
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Ngày bảo trì', style: TextStyle(fontSize: 14)),
                    subtitle: Text(DateFormat('dd/MM/yyyy').format(selectedDate), 
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                    trailing: const Icon(Icons.calendar_today, color: AppColors.primary),
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (picked != null) {
                        setDialogState(() => selectedDate = picked);
                      }
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  _fetchTickets();
                }, 
                child: const Text('Để sau', style: TextStyle(color: Colors.grey))
              ),
              ElevatedButton(
                onPressed: (selectedTechId == null) ? null : () async {
                  try {
                    await _service.scheduleRequest(
                      id: int.parse(ticket.id),
                      scheduledDate: selectedDate,
                      adminNote: noteController.text,
                      technicianId: selectedTechId!,
                      priority: selectedPriority,
                    );
                    if (mounted) {
                      Navigator.pop(ctx);
                      _fetchTickets();
                      _showSnackBar('Đã đặt lịch thành công');
                    }
                  } catch (e) {
                    if (mounted) {
                      _showSnackBar(_parseDioError(e), isError: true);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return const Center(child: Text('Không có yêu cầu bảo trì nào'));
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    String finalMsg = msg;
    
    // Nếu là lỗi DioException, cố gắng lấy message chi tiết từ server
    if (isError && msg.contains('DioException')) {
      if (msg.contains('400')) {
        finalMsg = "Lỗi 400: Dữ liệu gửi lên không đúng. Hãy thử lại hoặc báo Admin.";
      }
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(finalMsg), 
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        duration: const Duration(seconds: 6),
        behavior: SnackBarBehavior.floating,
        action: isError ? SnackBarAction(
          label: "Chi tiết",
          textColor: Colors.white,
          onPressed: () {
            String detailedError = msg;
            // Cố gắng trích xuất data từ DioException
            if (msg.contains('DioException')) {
              // Tìm kiếm nội dung phản hồi trong chuỗi lỗi nếu có
            }
            
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text("Phản hồi từ Server (Debug)"),
                content: SingleChildScrollView(
                  child: Text(msg),
                ),
                actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Đóng"))],
              ),
            );
          },
        ) : null,
      )
    );
  }
}

class _SummaryBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryBox({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}
