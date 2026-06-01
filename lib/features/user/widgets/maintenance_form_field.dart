import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum FormFieldType { dropdown, textarea, datePicker }

class MaintenanceFormField extends StatelessWidget {
  const MaintenanceFormField({
    super.key,
    required this.label,
    required this.type,
    this.placeholder,
    this.value,
    this.items,
    this.onChanged,
    this.onTap,
    this.controller,
    this.maxLines = 5,
  });

  final String label;
  final FormFieldType type;
  final String? placeholder;
  final String? value;
  final List<String>? items;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.formFieldLabel,
        ),
        const SizedBox(height: 8),
        type == FormFieldType.dropdown
            ? _buildDropdown(context)
            : type == FormFieldType.textarea
                ? _buildTextarea()
                : _buildDatePicker(context),
      ],
    );
  }

  Widget _buildDropdown(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.loginInputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? placeholder ?? '',
                style: (value != null && value!.isNotEmpty)
                    ? AppTextStyles.formDropdownText
                    : AppTextStyles.formDropdownPlaceholder,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.shopTextSecondary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextarea() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.loginInputBorder),
      ),
      padding: const EdgeInsets.all(17),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: AppTextStyles.formDropdownText,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: AppTextStyles.formTextareaHint,
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.loginInputBorder),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value ?? placeholder ?? '',
                style: (value != null && value!.isNotEmpty)
                    ? AppTextStyles.formDropdownText
                    : AppTextStyles.formDropdownPlaceholder,
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              color: AppColors.shopTextSecondary,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
