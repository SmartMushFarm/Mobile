import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/user_bottom_nav.dart';
import 'package:smartmush_farmer/features/user/widgets/maintenance_form_field.dart';
import 'package:smartmush_farmer/features/user/widgets/urgency_chip.dart';
import 'package:smartmush_farmer/features/user/widgets/upload_media_card.dart';

class CreateMaintenanceRequestScreen extends StatefulWidget {
  const CreateMaintenanceRequestScreen({super.key});

  @override
  State<CreateMaintenanceRequestScreen> createState() =>
      _CreateMaintenanceRequestScreenState();
}

class _CreateMaintenanceRequestScreenState
    extends State<CreateMaintenanceRequestScreen> {
  final _descriptionController = TextEditingController();
  String? _selectedDevice;
  String? _selectedIssue;
  int _selectedUrgency = 1;
  String? _selectedDate;
  bool _hasMedia = false;

  static const _devices = [
    'Hộp Nấm Số 1',
    'Hộp Nấm Số 2',
    'Hộp Nấm Số 3',
  ];

  static const _issues = [
    'Cảm biến bị lỗi',
    'Quạt hoạt động bất thường',
    'Đèn LED không phản hồi',
    'Máy phun sương bị lỗi',
    'Mất nguồn',
    'Khác',
  ];

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _submitRequest() {
    if (_selectedDevice == null) {
      _showSnackBar('Vui lòng chọn thiết bị');
      return;
    }
    if (_selectedIssue == null) {
      _showSnackBar('Vui lòng chọn loại sự cố');
      return;
    }
    _showSnackBar('Đã gửi yêu cầu bảo trì');
    context.go('/maintenance');
  }

  void _showDevicePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => _PickerSheet(
        title: 'Chọn thiết bị',
        items: _devices,
        selected: _selectedDevice,
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
      builder: (ctx) => _PickerSheet(
        title: 'Loại sự cố',
        items: _issues,
        selected: _selectedIssue,
        onSelected: (v) {
          setState(() => _selectedIssue = v);
          Navigator.pop(ctx);
        },
      ),
    );
  }

  void _showDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.shopPrice,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: AppColors.shopTextPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      setState(() {
        _selectedDate =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      });
    }
  }

  void _onBottomNavSelected(UserNavItem item) {
    switch (item) {
      case UserNavItem.home:
        context.go('/home');
      case UserNavItem.shop:
        context.go('/shop');
      case UserNavItem.alerts:
        context.push('/alerts');
      case UserNavItem.profile:
        context.go('/profile');
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.loginBackground,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Tạo yêu cầu bảo trì',
                      style: AppTextStyles.registerTitle.copyWith(
                        fontSize: 22,
                        color: AppColors.shopTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Mô tả sự cố để đội kỹ thuật hỗ trợ bạn',
                      style: AppTextStyles.loginSubtitle,
                    ),
                    const SizedBox(height: 24),
                    _buildFormSection(),
                    const SizedBox(height: 24),
                    _buildMediaSection(),
                    const SizedBox(height: 24),
                    _buildUrgencySection(),
                    const SizedBox(height: 24),
                    _buildDateSection(),
                    const SizedBox(height: 24),
                    _buildInfoCard(),
                    const SizedBox(height: 24),
                    _buildSubmitButton(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: UserBottomNav(
        currentItem: UserNavItem.profile,
        onItemSelected: _onBottomNavSelected,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      color: AppColors.loginBackground,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.loginLabel),
            onPressed: () => context.go('/maintenance'),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.eco, size: 20, color: AppColors.shopPrice),
          const SizedBox(width: 8),
          Text(
            'SmartMush Farmer',
            style: AppTextStyles.registerTitle.copyWith(
              fontSize: 18,
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mô tả sự cố',
          style: AppTextStyles.registerTitle.copyWith(
            fontSize: 20,
            color: AppColors.shopTextPrimary,
          ),
        ),
        const SizedBox(height: 12),
        MaintenanceFormField(
          label: 'Chọn thiết bị',
          type: FormFieldType.dropdown,
          placeholder: 'Chọn thiết bị',
          value: _selectedDevice,
          onTap: _showDevicePicker,
        ),
        const SizedBox(height: 12),
        MaintenanceFormField(
          label: 'Loại sự cố',
          type: FormFieldType.dropdown,
          placeholder: 'Chọn loại sự cố',
          value: _selectedIssue,
          onTap: _showIssuePicker,
        ),
        const SizedBox(height: 12),
        MaintenanceFormField(
          label: 'Mô tả chi tiết',
          type: FormFieldType.textarea,
          placeholder: 'Nhập mô tả sự cố...',
          controller: _descriptionController,
          maxLines: 5,
        ),
      ],
    );
  }

  Widget _buildMediaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tải ảnh/video',
          style: AppTextStyles.formFieldLabel,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: UploadMediaCard(
                label: 'Thêm hình ảnh',
                icon: Icons.add_a_photo_outlined,
                isUploaded: _hasMedia,
                imageUrl: _hasMedia
                    ? 'https://www.figma.com/api/mcp/asset/fcdcbc2d-9f5a-4bb5-b7ac-ceb242e2441e'
                    : null,
                onTap: _hasMedia
                    ? () => setState(() => _hasMedia = false)
                    : () => _showSnackBar('Tính năng tải ảnh sẽ được cập nhật'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: UploadMediaCard(
                label: 'Thêm video',
                icon: Icons.videocam_outlined,
                onTap: () => _showSnackBar('Tính năng tải video sẽ được cập nhật'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUrgencySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mức độ khẩn cấp',
          style: AppTextStyles.formFieldLabel,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            UrgencyChip(
              label: 'Thấp',
              isActive: _selectedUrgency == 0,
              onTap: () => setState(() => _selectedUrgency = 0),
            ),
            const SizedBox(width: 12),
            UrgencyChip(
              label: 'Trung bình',
              isActive: _selectedUrgency == 1,
              onTap: () => setState(() => _selectedUrgency = 1),
            ),
            const SizedBox(width: 12),
            UrgencyChip(
              label: 'Cao',
              isActive: _selectedUrgency == 2,
              onTap: () => setState(() => _selectedUrgency = 2),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thời gian hỗ trợ mong muốn',
          style: AppTextStyles.formFieldLabel,
        ),
        const SizedBox(height: 8),
        MaintenanceFormField(
          label: '',
          type: FormFieldType.datePicker,
          placeholder: 'Chọn thời gian',
          value: _selectedDate,
          onTap: _showDatePicker,
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFBEF3BE).withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.alertGreenBg),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.info_outline,
            size: 20,
            color: AppColors.alertGreenText,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Đội kỹ thuật sẽ xem xét yêu cầu và phản hồi sớm nhất có thể.',
              style: AppTextStyles.loginSubtitle.copyWith(
                color: AppColors.alertGreenText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitRequest,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.shopPrice,
          borderRadius: BorderRadius.circular(999),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Gửi yêu cầu',
              style: AppTextStyles.formUrgencyActive,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerSheet extends StatelessWidget {
  const _PickerSheet({
    required this.title,
    required this.items,
    required this.selected,
    required this.onSelected,
  });

  final String title;
  final List<String> items;
  final String? selected;
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
              title: Text(
                item,
                style: AppTextStyles.formDropdownText.copyWith(
                  color: item == selected
                      ? AppColors.shopPrice
                      : AppColors.shopTextPrimary,
                ),
              ),
              trailing: item == selected
                  ? const Icon(Icons.check, color: AppColors.shopPrice)
                  : null,
              onTap: () => onSelected(item),
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
