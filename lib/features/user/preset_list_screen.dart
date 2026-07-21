import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/services/preset_service.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';

class PresetListScreen extends StatefulWidget {
  const PresetListScreen({super.key});

  @override
  State<PresetListScreen> createState() => _PresetListScreenState();
}

class _PresetListScreenState extends State<PresetListScreen> {
  final _presetService = PresetService();
  List<dynamic> _presets = [];
  bool _isLoading = true;
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _fetchPresets();
    _checkAdmin();
  }

  Future<void> _checkAdmin() async {
    final userMap = await AuthService.getCurrentUser();
    if (userMap != null) {
      final user = UserModel.fromJson(userMap);
      if (mounted) {
        setState(() {
          _isAdmin = (user.role ?? '').toLowerCase() == 'admin';
        });
      }
    }
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

  Future<void> _deletePreset(dynamic rawId) async {
    final id = int.tryParse(rawId.toString());
    if (id == null) return;
    try {
      await _presetService.deletePreset(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã xóa Preset thành công')),
        );
        _fetchPresets();
      }
    } on DioException catch (e) {
      if (mounted) {
        String msg = 'Lỗi khi xóa: $e';
        if (e.response?.statusCode == 403) {
          msg = 'Bạn không có quyền xóa preset này (Lỗi 403)';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg), 
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
      }
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
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: Text('Danh sách Preset', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/presets/create').then((_) => _fetchPresets()),
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
                        child: ListTile(
                          onTap: () {
                            context.push('/presets/create', extra: preset).then((_) => _fetchPresets());
                          },
                          title: Text(preset['preset_name'] ?? 'Không tên', style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text('Loại nấm: ${preset['mushroom_type'] ?? 'N/A'}'),
                          trailing: (isRecommended && !_isAdmin)
                              ? const Icon(Icons.star, color: Colors.amber)
                              : IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                                  onPressed: () => _showDeleteConfirm(preset['id']),
                                ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  void _showDeleteConfirm(dynamic id) {
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
