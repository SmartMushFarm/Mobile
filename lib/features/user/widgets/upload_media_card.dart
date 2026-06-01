import 'package:flutter/material.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class UploadMediaCard extends StatelessWidget {
  const UploadMediaCard({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
    this.isUploaded = false,
    this.imageUrl,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final bool isUploaded;
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isUploaded && imageUrl != null
          ? _buildUploadedPreview()
          : _buildUploadPlaceholder(),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: AppColors.profileAvatarBorder,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.loginInputBorder,
          style: BorderStyle.solid,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color: AppColors.shopPrice,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: AppTextStyles.formDropdownText.copyWith(
              color: AppColors.shopPrice,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadedPreview() {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: const Color(0xFFEFEDED),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: double.infinity,
            errorBuilder: (context, error, stackTrace) => const Center(
              child: Icon(
                Icons.image_not_supported_outlined,
                color: AppColors.shopTextSecondary,
              ),
            ),
          ),
          Positioned(
            right: 8,
            top: 8,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Icon(
                  Icons.close,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
