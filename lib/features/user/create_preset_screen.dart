import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/app_primary_button.dart';
import 'package:smartmush_farmer/core/widgets/app_text_field.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
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
    _maxTempController = TextEditingController(text: (p?['max_temp_danger'] ?? '35').toString());
    _pulseOnController = TextEditingController(text: (p?['mist_pulse_on_seconds'] ?? '10').toString());
    _pulseOffController = TextEditingController(text: (p?['mist_pulse_off_seconds'] ?? '60').toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _descController.dispose();
    _mistOnController.dispose();
    _mistOffController.dispose();
    _fanOnController.dispose();
    _fanOffController.dispose();
    _heaterOnController.dispose();
    _heaterOffController.dispose();
    _dangerHumController.dispose();
    _maxTempController.dispose();
    _pulseOnController.dispose();
    _pulseOffController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    try {
      final user = await AuthService.getCurrentUser();
      int? userId;
      if (user != null) {
        final rawId = user['id'] ?? (user['data'] != null ? user['data']['id'] : null);
        if (rawId != null) userId = int.tryParse(rawId.toString());
      }

      final double mistOn = double.parse(_mistOnController.text);
      final double mistOff = double.parse(_mistOffController.text);
      final double fanOn = double.parse(_fanOnController.text);
      final double fanOff = double.parse(_fanOffController.text);
      final double heaterOn = double.parse(_heaterOnController.text);
      final double heaterOff = double.parse(_heaterOffController.text);

      if (mistOn >= mistOff) throw Exception('Mist ON humidity must be less than OFF humidity');
      if (fanOff >= fanOn) throw Exception('Fan OFF humidity must be less than ON humidity');
      if (heaterOn >= heaterOff) throw Exception('Heater ON temp must be less than OFF temp');

      final data = {
        'created_by': widget.preset?['created_by'] ?? userId,
        'preset_name': _nameController.text.trim(),
        'mushroom_type': _typeController.text.trim(),
        'mist_on_humidity': mistOn,
        'mist_off_humidity': mistOff,
        'fan_on_humidity': fanOn,
        'fan_off_humidity': fanOff,
        'heater_on_temp': heaterOn,
        'heater_off_temp': heaterOff,
        'danger_humidity': double.parse(_dangerHumController.text),
        'max_temp_danger': double.parse(_maxTempController.text),
        'mist_pulse_on_seconds': int.parse(_pulseOnController.text),
        'mist_pulse_off_seconds': int.parse(_pulseOffController.text),
        'is_recommended': widget.preset?['is_recommended'] ?? false,
        'description': _descController.text.trim(),
      };

      if (widget.preset != null) {
        final id = int.parse(widget.preset!['id'].toString());
        await _presetService.updatePreset(id: id, data: data);
      } else {
        await _presetService.createPreset(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.preset != null ? 'Preset updated successfully' : 'Preset created successfully'),
            backgroundColor: AppColors.primary,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (e is DioException && e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data.containsKey('message')) {
          errorMessage = data['message'];
        } else {
          errorMessage = data.toString();
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: $errorMessage'),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.preset != null;
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: Text(isEditing ? 'Chỉnh sửa Preset' : 'Tạo Preset mới', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(label: 'Tên Preset', controller: _nameController, hintText: 'VD: Nấm Bào Ngư Mùa Đông', validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              const SizedBox(height: 12),
              AppTextField(label: 'Loại nấm', controller: _typeController, hintText: 'VD: nam_bao_ngu', validator: (v) => v!.isEmpty ? 'Bắt buộc' : null),
              const SizedBox(height: 12),
              AppTextField(label: 'Mô tả', controller: _descController, hintText: 'Thông tin thêm...', maxLines: 2),
              const SizedBox(height: 20),
              Text('Thông số môi trường', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Mist ON (%)', controller: _mistOnController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Mist OFF (%)', controller: _mistOffController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Fan ON (%)', controller: _fanOnController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Fan OFF (%)', controller: _fanOffController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Heater ON (°C)', controller: _heaterOnController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Heater OFF (°C)', controller: _heaterOffController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 20),
              Text('Ngưỡng nguy hiểm & Xung', style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Độ ẩm nguy hiểm (%)', controller: _dangerHumController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Nhiệt độ tối đa (°C)', controller: _maxTempController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: AppTextField(label: 'Xung ON (giây)', controller: _pulseOnController, keyboardType: TextInputType.number)),
                  const SizedBox(width: 12),
                  Expanded(child: AppTextField(label: 'Xung OFF (giây)', controller: _pulseOffController, keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 32),
              AppPrimaryButton(label: isEditing ? 'Cập nhật Preset' : 'Lưu Preset', isLoading: _isLoading, onPressed: _handleSave),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
