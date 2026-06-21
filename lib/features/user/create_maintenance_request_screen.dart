import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/features/user/services/device_service.dart';
import 'package:smartmush_farmer/features/user/services/maintenance_service.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_form_field.dart';

class CreateMaintenanceRequestScreen extends StatefulWidget {
  const CreateMaintenanceRequestScreen({super.key});

  @override
  State<CreateMaintenanceRequestScreen> createState() =>
      _CreateMaintenanceRequestScreenState();
}

class _CreateMaintenanceRequestScreenState
    extends State<CreateMaintenanceRequestScreen> {
  final _descriptionController = TextEditingController();
  final _titleController = TextEditingController();
  final _deviceService = DeviceService();
  final _maintenanceService = MaintenanceService();
  
  bool _isLoadingDevices = true;
  bool _isSubmitting = false;
  List<dynamic> _myDevices = [];
  Map<String, dynamic>? _selectedDevice;

  static const _commonIssues = [
    'Cảm biến bị lỗi',
    'Quạt hoạt động bất thường',
    'Đèn LED không phản hồi',
    'Máy phun sương bị lỗi',
    'Mất nguồn',
    'Khác',
  ];

  @override
  void initState() {
    super.initState();
    _fetchMyDevices();
  }

  Future<void> _fetchMyDevices() async {
    try {
      final devices = await _deviceService.getMyDevices();
      if (mounted) {
        setState(() {
          _myDevices = devices;
          _isLoadingDevices = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingDevices = false);
        _showSnackBar('Không thể tải danh sách thiết bị');
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (_selectedDevice == null) {
      _showSnackBar('Vui lòng chọn thiết bị', isError: true);
      return;
    }
    if (_titleController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập vấn đề gặp phải', isError: true);
      return;
    }
    if (_descriptionController.text.trim().isEmpty) {
      _showSnackBar('Vui lòng nhập mô tả chi tiết', isError: true);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await _maintenanceService.createRequest(
        deviceId: int.parse(_selectedDevice!['id'].toString()),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
      );
      if (mounted) {
        _showSnackBar('Đã gửi yêu cầu bảo trì thành công');
        context.pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        _showSnackBar('Gửi yêu cầu thất bại: $e', isError: true);
      }
    }
  }

  void _showDevicePicker() {
    if (_myDevices.isEmpty && !_isLoadingDevices) {
      _showSnackBar('Bạn chưa có thiết bị nào để bảo trì');
      return;
    }
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PickerSheet(
        title: 'Chọn thiết bị',
        items: _myDevices,
        displayField: 'device_name',
        selectedId: _selectedDevice?['id']?.toString(),
        onSelected: (v) {
          setState(() => _selectedDevice = v);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showIssuePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _IssuePickerSheet(
        title: 'Vấn đề thường gặp',
        items: _commonIssues,
        selected: _titleController.text,
        onSelected: (v) {
          setState(() => _titleController.text = v);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      appBar: AppBar(
        title: const Text('Tạo yêu cầu bảo trì'),
        backgroundColor: AppColors.loginBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: _isLoadingDevices 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Text(
                    'Mô tả sự cố',
                    style: AppTextStyles.registerTitle.copyWith(
                      fontSize: 20,
                      color: AppColors.shopTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Đội kỹ thuật sẽ hỗ trợ bạn sớm nhất có thể',
                    style: AppTextStyles.loginSubtitle,
                  ),
                  const SizedBox(height: 24),
                  MaintenanceFormField(
                    label: 'Chọn thiết bị',
                    type: FormFieldType.dropdown,
                    placeholder: 'Chọn thiết bị cần bảo trì',
                    value: _selectedDevice?['device_name'],
                    onTap: _showDevicePicker,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: MaintenanceFormField(
                          label: 'Vấn đề gặp phải',
                          type: FormFieldType.textarea,
                          placeholder: 'Ví dụ: Máy phun sương bị lỗi',
                          controller: _titleController,
                          maxLines: 1,
                        ),
                      ),
                      IconButton(
                        onPressed: _showIssuePicker,
                        icon: const Icon(Icons.list_alt, color: AppColors.shopPrice),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  MaintenanceFormField(
                    label: 'Mô tả chi tiết',
                    type: FormFieldType.textarea,
                    placeholder: 'Vui lòng mô tả chi tiết tình trạng thiết bị...',
                    controller: _descriptionController,
                    maxLines: 5,
                  ),
                  const SizedBox(height: 32),
                  _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _isSubmitting ? null : _submitRequest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: _isSubmitting ? Colors.grey : AppColors.shopPrice,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: _isSubmitting 
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
            : Text(
                'Gửi yêu cầu',
                style: AppTextStyles.formUrgencyActive.copyWith(fontWeight: FontWeight.bold),
              ),
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.displayField,
    this.selectedId,
    required this.onSelected,
  });

  final String title;
  final List<dynamic> items;
  final String displayField;
  final String? selectedId;
  final ValueChanged<Map<String, dynamic>> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: AppTextStyles.registerTitle.copyWith(fontSize: 18),
          ),
        ),
        const Divider(height: 1),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (ctx, index) {
              final item = items[index] as Map<String, dynamic>;
              final id = item['id'].toString();
              final name = item[displayField] ?? 'Thiết bị #$id';
              final isSelected = id == selectedId;
              
              return ListTile(
                title: Text(name),
                trailing: isSelected ? const Icon(Icons.check, color: AppColors.shopPrice) : null,
                onTap: () => onSelected(item),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _IssuePickerSheet extends StatelessWidget {
  const _IssuePickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> items;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            title,
            style: AppTextStyles.registerTitle.copyWith(fontSize: 18),
          ),
        ),
        const Divider(height: 1),
        ...items.map((item) => ListTile(
          title: Text(item),
          trailing: item == selected ? const Icon(Icons.check, color: AppColors.shopPrice) : null,
          onTap: () => onSelected(item),
        )),
        const SizedBox(height: 16),
      ],
    );
  }
}
