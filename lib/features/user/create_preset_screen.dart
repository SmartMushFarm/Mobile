import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/app_primary_button.dart';
import 'package:smartmush_farmer/core/widgets/app_text_field.dart';
import 'package:smartmush_farmer/features/auth/services/auth_service.dart';
import 'package:smartmush_farmer/features/user/services/preset_service.dart';

class CreatePresetScreen extends StatefulWidget {
  const CreatePresetScreen({super.key});

  @override
  State<CreatePresetScreen> createState() => _CreatePresetScreenState();
}

class _CreatePresetScreenState extends State<CreatePresetScreen> {
  final _formKey = GlobalKey<FormState>();
  final _presetService = PresetService();
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _descController = TextEditingController();

  final _mistOnController = TextEditingController(text: '75');
  final _mistOffController = TextEditingController(text: '85');
  final _fanOnController = TextEditingController(text: '95');
  final _fanOffController = TextEditingController(text: '90');
  final _heaterOnController = TextEditingController(text: '20');
  final _heaterOffController = TextEditingController(text: '25');
  final _dangerHumController = TextEditingController(text: '98');
  final _maxTempController = TextEditingController(text: '35');
  final _pulseOnController = TextEditingController(text: '10');
  final _pulseOffController = TextEditingController(text: '60');

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
        'created_by': userId,
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
        'is_recommended': false,
        'description': _descController.text.trim(),
      };

      await _presetService.createPreset(data);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Preset created successfully')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.redAccent),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: Text('Tạo Preset mới', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
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
              AppPrimaryButton(label: 'Lưu Preset', isLoading: _isLoading, onPressed: _handleSave),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
