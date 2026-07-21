import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/app_primary_button.dart';
import 'package:smartmush_farmer/core/widgets/app_text_field.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/auth/models/user_model.dart';
import 'package:smartmush_farmer/features/user/services/preset_service.dart';

class CreatePresetScreen extends StatefulWidget {
  const CreatePresetScreen({super.key, this.preset});
  final Map<String, dynamic>? preset;

  @override
  State<CreatePresetScreen> createState() => _CreatePresetScreenState();
}

class _CreatePresetScreenState extends State<CreatePresetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _presetService = PresetService();
  bool _isLoading = false;
  bool _isAdmin = false;
  bool _isOwner = false;
  bool _isRecommended = false;

  late final TextEditingController _nameController;
  late final TextEditingController _typeController;
  late final TextEditingController _descController;
  late final TextEditingController _mistOnController;
  late final TextEditingController _mistOffController;
  late final TextEditingController _fanOnController;
  late final TextEditingController _fanOffController;
  late final TextEditingController _heaterOnController;
  late final TextEditingController _heaterOffController;
  late final TextEditingController _dangerHumController;
  late final TextEditingController _maxTempController;
  late final TextEditingController _pulseOnController;
  late final TextEditingController _pulseOffController;

  @override
  void initState() {
    super.initState();
    final p = widget.preset;
    _nameController = TextEditingController(text: p?['preset_name']);
    _typeController = TextEditingController(text: p?['mushroom_type']);
    _descController = TextEditingController(text: p?['description']);
    _mistOnController = TextEditingController(text: (p?['mist_on_humidity'] ?? '75').toString());
    _mistOffController = TextEditingController(text: (p?['mist_off_humidity'] ?? '85').toString());
    _fanOnController = TextEditingController(text: (p?['fan_on_humidity'] ?? '95').toString());
    _fanOffController = TextEditingController(text: (p?['fan_off_humidity'] ?? '90').toString());
    _heaterOnController = TextEditingController(text: (p?['heater_on_temp'] ?? '20').toString());
    _heaterOffController = TextEditingController(text: (p?['heater_off_temp'] ?? '25').toString());
    _dangerHumController = TextEditingController(text: (p?['danger_humidity'] ?? '98').toString());
    _maxTempController = TextEditingController(text: (p?['max_temp_danger'] ?? '32').toString());
    _pulseOnController = TextEditingController(text: (p?['mist_pulse_on_seconds'] ?? '10').toString());
    _pulseOffController = TextEditingController(text: (p?['mist_pulse_off_seconds'] ?? '60').toString());
    
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    try {
      final user = await AuthService.fetchMe();
      final myId = user.id?.toString();
      final p = widget.preset;
      if (mounted) {
        setState(() {
          _isAdmin = (user.role ?? '').toLowerCase() == 'admin';
          final rawRec = p?['is_recommended'];
          _isRecommended = rawRec == true || rawRec == 1 || rawRec?.toString() == '1' || rawRec?.toString().toLowerCase() == 'true';
          
          final creatorId = p?['created_by']?.toString() ?? p?['userId']?.toString() ?? p?['user_id']?.toString();
          _isOwner = (myId != null && creatorId != null && myId == creatorId);
          if (p == null) _isOwner = true;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _nameController.dispose(); _typeController.dispose(); _descController.dispose();
    _mistOnController.dispose(); _mistOffController.dispose(); _fanOnController.dispose();
    _fanOffController.dispose(); _heaterOnController.dispose(); _heaterOffController.dispose();
    _dangerHumController.dispose(); _maxTempController.dispose(); _pulseOnController.dispose();
    _pulseOffController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);
    try {
      final data = {
        'preset_name': _nameController.text.trim(),
        'mushroom_type': _typeController.text.trim(),
        'mist_on_humidity': double.tryParse(_mistOnController.text),
        'mist_off_humidity': double.tryParse(_mistOffController.text),
        'fan_on_humidity': double.tryParse(_fanOnController.text),
        'fan_off_humidity': double.tryParse(_fanOffController.text),
        'heater_on_temp': double.tryParse(_heaterOnController.text),
        'heater_off_temp': double.tryParse(_heaterOffController.text),
        'danger_humidity': double.tryParse(_dangerHumController.text),
        'max_temp_danger': double.tryParse(_maxTempController.text),
        'mist_pulse_on_seconds': int.tryParse(_pulseOnController.text),
        'mist_pulse_off_seconds': int.tryParse(_pulseOffController.text),
        'description': _descController.text.trim(),
      };
      
      final bool isEditing = widget.preset != null && widget.preset!['id'] != null;

      if (isEditing) {
        if (_isAdmin) data['is_recommended'] = _isRecommended;
        await _presetService.updatePreset(id: int.parse(widget.preset!['id'].toString()), data: data);
      } else {
        final user = await AuthService.getCurrentUser();
        data['created_by'] = user?['id'];
        if (_isAdmin) data['is_recommended'] = _isRecommended;
        await _presetService.createPreset(data);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!'), backgroundColor: AppColors.primary));
        Navigator.pop(context, true);
      }
    } on DioException catch (e) {
      String msg = e.response?.data?['message'] ?? 'Lỗi 403: Không có quyền cập nhật';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleDelete() async {
    final id = int.tryParse(widget.preset?['id']?.toString() ?? '');
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Xác nhận xóa Preset #$id'),
        content: const Text('Bạn có chắc chắn muốn xóa preset này?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Hủy')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Xóa', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
    if (confirmed != true) return;
    setState(() => _isLoading = true);
    try {
      await _presetService.deletePreset(id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa thành công')));
        Navigator.pop(context, true);
      }
    } on DioException catch (e) {
      final user = await AuthService.getCurrentUser();
      final myId = user?['id'];
      final creatorId = widget.preset?['created_by'];
      String msg = e.response?.data?['message'] ?? 'Bạn (ID $myId) không có quyền xóa Preset này (Chủ là $creatorId, Hệ thống: $_isRecommended)';
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.redAccent, duration: const Duration(seconds: 5)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.preset != null && widget.preset!['id'] != null;
    
    // PHÂN QUYỀN CHUẨN:
    // - Nếu Recommended == TRUE: Chỉ Admin.
    // - Nếu Recommended == FALSE: Admin HOẶC Chủ sở hữu (Owner).
    bool canEdit = false;
    if (isEditing) {
      canEdit = _isAdmin || (_isOwner && !_isRecommended);
    } else {
      canEdit = true; 
    }

    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa Preset #${widget.preset!['id']}' : 'Tạo Preset mới', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          if (isEditing && canEdit)
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: _isLoading ? null : _handleDelete),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isEditing && !canEdit)
                Container(
                  padding: const EdgeInsets.all(12), margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(color: Colors.amber.withOpacity(0.1), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.amber)),
                  child: Text(_isRecommended 
                    ? 'Đây là Preset hệ thống. Chỉ tài khoản Quản trị viên mới có quyền chỉnh sửa hoặc xóa.' 
                    : 'Bạn không có quyền chỉnh sửa Preset này.', style: TextStyle(color: Colors.amber[900], fontSize: 13)),
                ),
              AppTextField(label: 'Tên preset', controller: _nameController, enabled: canEdit, validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              const SizedBox(height: 12),
              AppTextField(label: 'Loại nấm', controller: _typeController, enabled: canEdit, validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              const SizedBox(height: 12),
              AppTextField(label: 'Mô tả', controller: _descController, enabled: canEdit, maxLines: 2),
              const SizedBox(height: 20),
              Text('Thông số kỹ thuật', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              AppTextField(label: 'Bật phun sương khi ẩm dưới (%)', controller: _mistOnController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 12),
              AppTextField(label: 'Tắt phun sương khi ẩm đạt (%)', controller: _mistOffController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 24),
              AppTextField(label: 'Bật quạt khi ẩm trên (%)', controller: _fanOnController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 12),
              AppTextField(label: 'Tắt quạt khi ẩm giảm còn (%)', controller: _fanOffController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 24),
              AppTextField(label: 'Bật sưởi khi nhiệt dưới (°C)', controller: _heaterOnController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 12),
              AppTextField(label: 'Tắt sưởi khi nhiệt đạt (°C)', controller: _heaterOffController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 24),
              AppTextField(label: 'Ngưỡng ẩm nguy hiểm (%)', controller: _dangerHumController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 12),
              AppTextField(label: 'Ngưỡng nhiệt nguy hiểm (°C)', controller: _maxTempController, keyboardType: TextInputType.number, enabled: canEdit),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Phun (giây)', controller: _pulseOnController, keyboardType: TextInputType.number, enabled: canEdit)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Nghỉ (giây)', controller: _pulseOffController, keyboardType: TextInputType.number, enabled: canEdit)),
                ],
              ),
              if (_isAdmin) ...[
                const SizedBox(height: 24),
                SwitchListTile(
                  title: const Text('Đặt làm Preset hệ thống', style: TextStyle(fontWeight: FontWeight.bold)),
                  value: _isRecommended, activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _isRecommended = v),
                ),
              ],
              const SizedBox(height: 32),
              if (canEdit) AppPrimaryButton(label: isEditing ? 'Cập nhật Preset' : 'Lưu Preset', isLoading: _isLoading, onPressed: _handleSave),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
