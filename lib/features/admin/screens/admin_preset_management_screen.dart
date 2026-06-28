import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/services/preset_service.dart';
import 'package:smartmush_farmer/features/admin/widgets/admin_app_bar.dart';

class AdminPresetManagementScreen extends StatefulWidget {
  const AdminPresetManagementScreen({super.key});

  @override
  State<AdminPresetManagementScreen> createState() => _AdminPresetManagementScreenState();
}

class _AdminPresetManagementScreenState extends State<AdminPresetManagementScreen> {
  final _presetService = PresetService();
  List<dynamic> _presets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPresets();
  }

  Future<void> _fetchPresets() async {
    setState(() => _isLoading = true);
    try {
      final data = await _presetService.getPresets();
      setState(() {
        _presets = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi: $e')),
        );
      }
    }
  }

  Future<void> _deletePreset(int id) async {
    try {
      await _presetService.deletePreset(id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã xóa Preset')),
      );
      _fetchPresets();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi xóa: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AdminAppBar(title: 'Quản lý Presets', showBack: true),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Khi Admin tạo, bạn có thể truyền flag để Backend biết đây là Recommended
          context.push('/presets/create', extra: {'is_admin': true}).then((_) => _fetchPresets());
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPresets,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _presets.isEmpty
                ? const Center(child: Text('Chưa có preset nào.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _presets.length,
                    itemBuilder: (context, index) {
                      final preset = _presets[index];
                      final bool isRecommended = preset['is_recommended'] == true || preset['is_recommended'] == 1;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: isRecommended ? Colors.amber.shade100 : Colors.green.shade100,
                            child: Icon(
                              isRecommended ? Icons.star : Icons.settings,
                              color: isRecommended ? Colors.amber : Colors.green,
                            ),
                          ),
                          title: Text(
                            preset['preset_name'] ?? 'Không tên',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Nấm: ${preset['mushroom_type'] ?? 'N/A'} • ${isRecommended ? "Recommended" : "User"}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: Colors.blueAccent),
                                onPressed: () {
                                  context.push('/presets/create', extra: preset).then((_) => _fetchPresets());
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                onPressed: () => _showDeleteConfirm(preset['id']),
                              ),
                            ],
                          ),
                          onTap: () {
                            context.push('/presets/create', extra: preset).then((_) => _fetchPresets());
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _showDeleteConfirm(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa preset này không?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deletePreset(id);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
