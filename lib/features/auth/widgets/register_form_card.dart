import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/app_primary_button.dart';
import 'package:smartmush_farmer/core/widgets/app_text_field.dart';
class RegisterFormCard extends StatelessWidget {
  const RegisterFormCard({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePasswordVisibility,
    required this.onCreateAccount,
    required this.onLogin,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePasswordVisibility;
  final VoidCallback onCreateAccount;
  final VoidCallback onLogin;

  static const _fieldPadding = EdgeInsets.fromLTRB(49, 15, 17, 15);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.loginBackground,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Color(0x144CAF50),
            blurRadius: 24,
            offset: Offset(0, -8),
            spreadRadius: -4,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tạo tài khoản của bạn',
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.registerTitle,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng ký để bắt đầu quản lý nấm thông minh.',
              style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Họ và tên',
              controller: nameController,
              hintText: 'Người trồng nấm',
              prefixIcon: Icons.person_outline,
              labelSpacing: 8,
              labelPadding: EdgeInsets.zero,
              contentPadding: _fieldPadding,
              hintStyle: AppTextStyles.loginFieldHint.copyWith(
                color: AppColors.registerHintMuted,
              ),
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Họ và tên bắt buộc';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Địa chỉ Email',
              controller: emailController,
              hintText: 'nguoi@smartmush.com',
              prefixIcon: Icons.mail_outline,
              labelSpacing: 8,
              labelPadding: EdgeInsets.zero,
              contentPadding: _fieldPadding,
              hintStyle: AppTextStyles.loginFieldHint.copyWith(
                color: AppColors.registerHintMuted,
              ),
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email bắt buộc';
                }
                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Mật khẩu',
              controller: passwordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: obscurePassword,
              labelSpacing: 8,
              labelPadding: EdgeInsets.zero,
              contentPadding: const EdgeInsets.fromLTRB(49, 15, 49, 15),
              hintStyle: AppTextStyles.loginFieldHint.copyWith(
                color: AppColors.registerHintMuted,
              ),
              textInputAction: TextInputAction.done,
              suffix: IconButton(
                onPressed: onTogglePasswordVisibility,
                icon: Icon(
                  obscurePassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 20,
                  color: AppColors.loginHint,
                ),
              ),
              helperText: 'Phải có ít nhất 8 ký tự.',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu bắt buộc';
                }
                if (value.length < 8) {
                  return 'Mật khẩu phải có ít nhất 8 ký tự';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'Tạo tài khoản',
              isLoading: isLoading,
              onPressed: onCreateAccount,
              backgroundColor: AppColors.loginLink,
              borderRadius: 12,
            ),
            const SizedBox(height: 24),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    'Đã có tài khoản? ',
                    style: GoogleFonts.inter(textStyle: AppTextStyles.loginFooter),
                  ),
                  GestureDetector(
                    onTap: onLogin,
                    child: Text(
                      'Đăng nhập',
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.registerFooterLink,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
