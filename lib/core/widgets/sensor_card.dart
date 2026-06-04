import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

enum SensorCardType { temperature, humidity, co2, moisture }

class SensorCard extends StatelessWidget {
  const SensorCard.temperature({
    super.key,
    required this.value,
    required this.unit,
    required this.trend,
  })  : type = SensorCardType.temperature,
        progress = null;

  const SensorCard.humidity({
    super.key,
    required this.value,
    required this.unit,
  })  : type = SensorCardType.humidity,
        trend = null,
        progress = null;

  const SensorCard.co2({
    super.key,
    required this.value,
    required this.unit,
    required this.progress,
  })  : type = SensorCardType.co2,
        trend = null;

  const SensorCard.moisture({
    super.key,
    required this.value,
    required this.unit,
    required this.progress,
  })  : type = SensorCardType.moisture,
        trend = null;

  final SensorCardType type;
  final String value;
  final String unit;
  final double? trend;
  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.loginInputBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A4CAF50),
            blurRadius: 2,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: switch (type) {
        SensorCardType.temperature => _TemperatureLayout(
            value: value,
            unit: unit,
            trend: trend ?? 0,
          ),
        SensorCardType.humidity => _HumidityLayout(value: value, unit: unit),
        SensorCardType.co2 => _Co2Layout(
            value: value,
            unit: unit,
            progress: progress ?? 0,
          ),
        SensorCardType.moisture => _MoistureLayout(
            value: value,
            unit: unit,
            progress: progress ?? 0,
          ),
      },
    );
  }
}

class _SensorLabel extends StatelessWidget {
  const _SensorLabel({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.loginLabel),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(textStyle: AppTextStyles.sensorLabel),
        ),
      ],
    );
  }
}

class _TemperatureLayout extends StatelessWidget {
  const _TemperatureLayout({
    required this.value,
    required this.unit,
    required this.trend,
  });

  final String value;
  final String unit;
  final double trend;

  @override
  Widget build(BuildContext context) {
    // Format số lẻ của trend cho đẹp (VD: 0.03)
    final trendValue = trend.toStringAsFixed(2);
    final isPositive = trend >= 0;
    final trendText = '${isPositive ? '↑' : '↓'} $trendValue°';
    
    // Giả sử nhiệt độ tối đa hiển thị trên vòng cung là 50 độ
    final double tempVal = double.tryParse(value) ?? 0;
    final double progress = (tempVal / 50).clamp(0.0, 1.0);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SensorLabel(
                icon: Icons.thermostat_outlined,
                label: 'NHIỆT ĐỘ',
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    value,
                    style: GoogleFonts.plusJakartaSans(
                      textStyle: AppTextStyles.sensorLargeValue,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0, left: 2),
                    child: Text(
                      unit,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.sensorUnit,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isPositive ? Colors.orange : Colors.blue).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.arrow_downward,
                      size: 14,
                      color: isPositive ? Colors.orange : Colors.blue,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trendText,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isPositive ? Colors.orange : Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: _ModernGaugePainter(
                  progress: progress,
                  color: AppColors.loginLink,
                ),
              ),
            ),
            Icon(Icons.wb_sunny_outlined, color: AppColors.loginLink.withOpacity(0.5), size: 24),
          ],
        ),
      ],
    );
  }
}

class _HumidityLayout extends StatelessWidget {
  const _HumidityLayout({
    required this.value,
    required this.unit,
  });

  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final percent = int.tryParse(value) ?? 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              const _SensorLabel(
                icon: Icons.water_drop_outlined,
                label: 'ĐỘ ẨM',
              ),
        const SizedBox(height: 16),
        Center(
          child: SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  size: const Size(80, 80),
                  painter: _RingGaugePainter(progress: percent / 100),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.plusJakartaSans(
                        textStyle: AppTextStyles.boxCardTitle,
                      ),
                    ),
                    Text(
                      unit,
                      style: GoogleFonts.inter(
                        textStyle: AppTextStyles.loginSubtitle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _Co2Layout extends StatelessWidget {
  const _Co2Layout({
    required this.value,
    required this.unit,
    required this.progress,
  });

  final String value;
  final String unit;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
              const _SensorLabel(
                icon: Icons.cloud_outlined,
                label: 'MỨC CO2',
              ),
        const Spacer(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.metricValue,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.splashTrack,
            color: AppColors.loginLink,
          ),
        ),
      ],
    );
  }
}

class _MoistureLayout extends StatelessWidget {
  const _MoistureLayout({
    required this.value,
    required this.unit,
    required this.progress,
  });

  final String value;
  final String unit;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
              const _SensorLabel(
                icon: Icons.grass_outlined,
                label: 'GIÁ THỂ',
              ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                textStyle: AppTextStyles.metricValue,
              ),
            ),
            Text(
              unit,
              style: GoogleFonts.inter(textStyle: AppTextStyles.loginSubtitle),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            minHeight: 8,
            backgroundColor: AppColors.splashTrack,
            color: AppColors.loginLink,
          ),
        ),
      ],
    );
  }
}

class _ModernGaugePainter extends CustomPainter {
  _ModernGaugePainter({required this.progress, required this.color});

  final double progress;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    const strokeWidth = 6.0;

    final trackPaint = Paint()
      ..color = AppColors.splashTrack.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Vẽ vòng tròn nền
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      0.75 * math.pi,
      1.5 * math.pi,
      false,
      trackPaint,
    );

    // Vẽ phần tiến độ
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      0.75 * math.pi,
      1.5 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ModernGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _SemiCircleGaugePainter extends CustomPainter {
  _SemiCircleGaugePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 8.0;
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height * 2 - strokeWidth,
    );

    final trackPaint = Paint()
      ..color = AppColors.splashTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.loginLink
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, math.pi, math.pi, false, trackPaint);
    canvas.drawArc(
      rect,
      math.pi,
      math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SemiCircleGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _RingGaugePainter extends CustomPainter {
  _RingGaugePainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 6;
    const strokeWidth = 8.0;

    final trackPaint = Paint()
      ..color = AppColors.splashTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final progressPaint = Paint()
      ..color = AppColors.loginLink
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingGaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}
