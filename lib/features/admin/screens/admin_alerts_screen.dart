import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_app_bar.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_bottom_nav.dart';
import 'package:smartmush_farmer/features/alerts/services/notification_service.dart';
import 'package:smartmush_farmer/features/alerts/models/notification_model.dart';
import 'package:smartmush_farmer/features/admin/data/admin_user_service.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class AdminAlertsScreen extends StatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  State<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends State<AdminAlertsScreen> {
  final NotificationService _notificationService = NotificationService();
  final AdminUserService _userService = AdminUserService();
  List<NotificationModel> _notifications = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'Tất cả';
  final List<String> _filters = ['Tất cả', 'Nghiêm trọng', 'Cảnh báo', 'Đã xử lý'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final response = await _notificationService.getNotifications(page: 1, limit: 100);
      List list = [];
      if (response['data'] is List) {
        list = response['data'];
      } else if (response['notifications'] is List) {
        list = response['notifications'];
      }

      setState(() {
        _notifications = list.map((json) => NotificationModel.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _markAsRead(int id) async {
    try {
      await _notificationService.markAsRead(id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  Future<void> _deleteNotification(int id) async {
    try {
      await _notificationService.deleteNotification(id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var filtered = _notifications;
    if (_selectedFilter == 'Đã xử lý') {
      filtered = _notifications.where((n) => n.isRead).toList();
    } else if (_selectedFilter == 'Nghiêm trọng') {
      filtered = _notifications.where((n) => n.type.toLowerCase() == 'critical' || n.type.toLowerCase() == 'danger').toList();
    } else if (_selectedFilter == 'Cảnh báo') {
      filtered = _notifications.where((n) => n.type.toLowerCase() == 'warning').toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAF8),
      appBar: const AdminAppBar(title: 'Trung tâm Thông báo', showBack: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateNotificationDialog(),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _loadData,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? _buildErrorState()
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildTopCards(),
                              const SizedBox(height: 24),
                              const Text(
                                'Danh sách Thông báo',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1B1C1C),
                                ),
                              ),
                              const SizedBox(height: 12),
                              if (filtered.isEmpty)
                                Center(child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 40),
                                  child: Column(
                                    children: [
                                      Icon(Icons.notifications_none, size: 64, color: Colors.grey[300]),
                                      const SizedBox(height: 16),
                                      const Text('Không tìm thấy thông báo', style: TextStyle(color: Colors.grey)),
                                    ],
                                  ),
                                ))
                              else
                                ...filtered.map((n) => _buildAlertCard(n)),
                              const SizedBox(height: 80),
                            ],
                          ),
                        ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: Colors.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isActive = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isActive,
              onSelected: (selected) {
                if (selected) setState(() => _selectedFilter = filter);
              },
              selectedColor: AppColors.primary,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : const Color(0xFF6F7A6B),
                fontWeight: FontWeight.w600,
              ),
              backgroundColor: const Color(0xFFF1F3F1),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopCards() {
    final now = DateTime.now();
    final last24h = _notifications.where((n) {
      if (n.createdAt == null) return false;
      return now.difference(n.createdAt!).inHours <= 24;
    }).length;
    
    final resolvedCount = _notifications.where((n) => n.isRead && n.updatedAt != null && n.createdAt != null).toList();
    double avgResolveTimeMinutes = 0;
    if (resolvedCount.isNotEmpty) {
      final totalMinutes = resolvedCount.fold<int>(0, (sum, n) => sum + n.updatedAt!.difference(n.createdAt!).inMinutes);
      avgResolveTimeMinutes = totalMinutes / resolvedCount.length;
    }

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE3E2E2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LƯỢNG THÔNG BÁO 24H', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6F7A6B))),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: List.generate(7, (i) {
                    double factor = (last24h > 0) ? (0.3 + (i % 3) * 0.2) : 0.1;
                    if (i == 6) factor = 0.9;
                    return _buildBar(factor);
                  }),
                ),
                const SizedBox(height: 8),
                Text('$last24h', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1C1C))),
                const Text('Tổng trong 24 giờ qua', style: TextStyle(fontSize: 10, color: Color(0xFF6F7A6B))),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE3E2E2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('THỜI GIAN XỬ LÝ TRUNG BÌNH', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6F7A6B))),
                const SizedBox(height: 12),
                Text('${avgResolveTimeMinutes.toStringAsFixed(1)}p', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1B1C1C))),
                const SizedBox(height: 4),
                const Text('Dựa trên dữ liệu thực tế', style: TextStyle(fontSize: 10, color: Color(0xFF6F7A6B))),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBar(double heightFactor) {
    return Expanded(
      child: Container(
        height: 40 * heightFactor,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        decoration: BoxDecoration(
          color: const Color(0xFFBDEFBE),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildAlertCard(NotificationModel n) {
    final bool isCritical = n.type.toLowerCase() == 'critical' || n.type.toLowerCase() == 'danger';
    final bool isWarning = n.type.toLowerCase() == 'warning';
    
    final Color statusColor = isCritical ? const Color(0xFFBA1A1A) : (isWarning ? const Color(0xFFEAB308) : AppColors.primary);
    final Color bgColor = isCritical ? const Color(0xFFFFDAD6) : (isWarning ? const Color(0xFFFEF9C3) : const Color(0xFFF1F8E9));
    final String statusLabel = isCritical ? 'Nghiêm trọng' : (isWarning ? 'Cảnh báo' : 'Thông tin');

    String timeAgo = 'Vừa xong';
    if (n.createdAt != null) {
      final diff = DateTime.now().difference(n.createdAt!);
      if (diff.inMinutes < 60) timeAgo = '${diff.inMinutes} phút trước';
      else if (diff.inHours < 24) timeAgo = '${diff.inHours} giờ trước';
      else timeAgo = DateFormat('dd MMM').format(n.createdAt!);
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE3E2E2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                  child: Icon(isCritical ? Icons.error : (isWarning ? Icons.warning : Icons.info), color: statusColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(n.deviceId != null ? 'Thiết bị ID: ${n.deviceId}' : 'Thông báo Hệ thống', 
                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1B1C1C))),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Container(width: 6, height: 6, decoration: BoxDecoration(color: statusColor, shape: BoxShape.circle)),
                                const SizedBox(width: 4),
                                Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(timeAgo, style: const TextStyle(fontSize: 12, color: Color(0xFF6F7A6B))),
                      const SizedBox(height: 8),
                      Text(n.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1B1C1C))),
                      const SizedBox(height: 4),
                      Text(n.message, style: const TextStyle(fontSize: 13, color: Color(0xFF3F4A3C))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE3E2E2)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: n.isRead ? null : () => _markAsRead(n.id!),
                    icon: Icon(Icons.check, size: 16, color: n.isRead ? Colors.grey : const Color(0xFF426E47)),
                    label: Text(n.isRead ? 'Đã xử lý' : 'Xử lý', style: TextStyle(color: n.isRead ? Colors.grey : const Color(0xFF426E47))),
                    style: TextButton.styleFrom(backgroundColor: const Color(0xFFF1F3F1), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => _deleteNotification(n.id!),
                    icon: const Icon(Icons.delete_outline, size: 16, color: Color(0xFFBA1A1A)),
                    label: const Text('Xóa', style: TextStyle(color: Color(0xFFBA1A1A))),
                    style: TextButton.styleFrom(backgroundColor: const Color(0xFFFEE2E2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateNotificationDialog() {
    final titleController = TextEditingController();
    final messageController = TextEditingController();
    final userIdController = TextEditingController();
    final deviceIdController = TextEditingController();
    String selectedType = 'Info';
    bool sendToAll = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Thông báo mới', style: TextStyle(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SwitchListTile(
                  title: const Text('Gửi cho tất cả người dùng', style: TextStyle(fontSize: 14)),
                  value: sendToAll,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setDialogState(() => sendToAll = v),
                ),
                if (!sendToAll)
                  TextField(
                    controller: userIdController, 
                    decoration: const InputDecoration(labelText: 'User ID người nhận', hintText: 'VD: 1'),
                    keyboardType: TextInputType.number
                  ),
                const SizedBox(height: 8),
                TextField(
                  controller: deviceIdController, 
                  decoration: const InputDecoration(labelText: 'ID Thiết bị (Tùy chọn)', hintText: 'VD: 101'),
                  keyboardType: TextInputType.number
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  items: ['Info', 'Warning', 'Critical'].map((t) => DropdownMenuItem(value: t, child: Text(t == 'Info' ? 'Thông tin' : (t == 'Warning' ? 'Cảnh báo' : 'Nghiêm trọng')))).toList(),
                  onChanged: (v) => selectedType = v!,
                  decoration: const InputDecoration(labelText: 'Loại thông báo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: titleController, 
                  decoration: const InputDecoration(labelText: 'Tiêu đề', hintText: 'Nhập tiêu đề...')
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: messageController, 
                  decoration: const InputDecoration(labelText: 'Nội dung', hintText: 'Nhập nội dung chi tiết...'), 
                  maxLines: 3
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Hủy')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
              onPressed: () async {
                if (titleController.text.isEmpty || messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng điền đầy đủ các trường bắt buộc')));
                  return;
                }
                if (!sendToAll && userIdController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập User ID')));
                  return;
                }
                
                Navigator.pop(ctx);
                try {
                  if (sendToAll) {
                    final users = await _userService.getUsers();
                    final userIds = users.map((u) => u.id!).toList();
                    await _notificationService.batchCreateNotifications(
                      userIds: userIds,
                      deviceId: int.tryParse(deviceIdController.text),
                      type: selectedType,
                      title: titleController.text,
                      message: messageController.text,
                    );
                  } else {
                    await _notificationService.createNotification(
                      userId: int.parse(userIdController.text),
                      deviceId: int.tryParse(deviceIdController.text),
                      type: selectedType,
                      title: titleController.text,
                      message: messageController.text,
                    );
                  }
                  _loadData();
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi thông báo thành công')));
                  }
                } catch (e) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
                }
              },
              child: const Text('Gửi Thông báo'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
            const SizedBox(height: 16),
            Text('Lỗi: $_errorMessage', textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _loadData, child: const Text('Thử lại')),
          ],
        ),
      ),
    );
  }
}
