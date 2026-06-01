import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smartmush_farmer/app/theme/app_theme.dart';

class SimpleLineChart extends StatelessWidget {
  const SimpleLineChart({
    super.key,
    required this.temperatureValues,
    required this.humidityValues,
  });

  final List<double> temperatureValues;
  final List<double> humidityValues;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 192,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _LegendDot(
                color: AppColors.loginLink,
                label: 'Nhiệt',
              ),
              const SizedBox(width: 16),
              _LegendDot(
                color: AppColors.chartHumidityLine,
                label: 'Ẩm',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.splashTrack,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: (temperatureValues.length - 1).toDouble(),
                lineBarsData: [
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < temperatureValues.length; i++)
                        FlSpot(i.toDouble(), temperatureValues[i]),
                    ],
                    isCurved: true,
                    color: AppColors.loginLink,
                    barWidth: 2.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < humidityValues.length; i++)
                        FlSpot(i.toDouble(), humidityValues[i]),
                    ],
                    isCurved: true,
                    color: AppColors.chartHumidityLine,
                    barWidth: 2,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: const LineTouchData(enabled: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(textStyle: AppTextStyles.metricLabel),
        ),
      ],
    );
  }
}
