import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';
import 'package:smartmush_farmer/core/widgets/app_primary_button.dart';
import 'package:smartmush_farmer/core/widgets/app_text_field.dart';
import 'package:smartmush_farmer/core/widgets/brand_logo_chip.dart';

class LoginFormCard extends StatelessWidget {
  const LoginFormCard({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onLogin,
    required this.onForgotPassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const BrandLogoChip(),
            const SizedBox(height: 8),
            Text(
              'Chào mừng trở lại',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.loginTitle(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Đăng nhập để quản lý chu kỳ trồng tự động.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Email',
              controller: emailController,
              hintText: 'farmer@smartmush.com',
              prefixIcon: Icons.mail_outline,
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
              label: 'Password',
              controller: passwordController,
              hintText: '••••••••',
              prefixIcon: Icons.lock_outline,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Mật khẩu bắt buộc';
                }
                if (value.length < 6) {
                  return 'Mật khẩu phải có ít nhất 6 ký tự';
                }
                return null;
              },
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onForgotPassword,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.only(top: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Quên mật khẩu?',
                  style: GoogleFonts.inter(textStyle: AppTextStyles.loginLink),
                ),
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              label: 'Đăng nhập',
              isLoading: isLoading,
              onPressed: onLogin,
            ),
            const SizedBox(height: 32),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  'Chưa có tài khoản? ',
                  style: GoogleFonts.inter(textStyle: AppTextStyles.loginFooter),
                ),
                GestureDetector(
                  onTap: () => context.push('/register'),
                  child: Text(
                    'Tạo tài khoản',
                    style: GoogleFonts.inter(textStyle: AppTextStyles.loginLink),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
