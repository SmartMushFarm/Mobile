import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';
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
    if (temperatureValues.isEmpty || humidityValues.isEmpty) {
      return Container(
        height: 220,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.loginInputBorder),
        ),
        child: const Text('Chưa có dữ liệu lịch sử'),
      );
    }

    // Tính toán khoảng hiển thị tối ưu cho trục Y
    double minTemp = temperatureValues.reduce(min);
    double maxTemp = temperatureValues.reduce(max);
    double minHum = humidityValues.reduce(min);
    double maxHum = humidityValues.reduce(max);

    double minY = min(minTemp, minHum) - 2;
    double maxY = max(maxTemp, maxHum) + 5;
    
    // Đảm bảo minY không âm
    minY = minY < 0 ? 0 : minY;

    return Container(
      height: 280,
      padding: const EdgeInsets.fromLTRB(10, 16, 10, 10),
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
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 20),
            child: Row(
              children: [
                _LegendDot(color: AppColors.loginLink, label: 'Nhiệt độ (°C)'),
                const SizedBox(width: 16),
                _LegendDot(color: AppColors.chartHumidityLine, label: 'Độ ẩm (%)'),
              ],
            ),
          ),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: (maxY - minY) / 5,
                  getDrawingHorizontalLine: (value) => const FlLine(
                    color: AppColors.splashTrack,
                    strokeWidth: 0.5,
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22,
                      getTitlesWidget: (value, meta) {
                        if (value % 5 != 0) return const SizedBox.shrink();
                        return Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 10));
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 10));
                      },
                      reservedSize: 28,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: const Border(
                    bottom: BorderSide(color: AppColors.splashTrack, width: 1),
                    left: BorderSide(color: AppColors.splashTrack, width: 1),
                  ),
                ),
                minX: 0,
                maxX: (temperatureValues.length - 1).toDouble(),
                minY: minY,
                maxY: maxY,
                lineBarsData: [
                  // Đường Nhiệt độ
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < temperatureValues.length; i++)
                        FlSpot(i.toDouble(), temperatureValues[i]),
                    ],
                    isCurved: true,
                    color: AppColors.loginLink,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x % 4 == 0 || spot.x == barData.spots.length - 1,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 2, strokeColor: AppColors.loginLink),
                    ),
                    belowBarData: BarAreaData(show: true, color: AppColors.loginLink.withOpacity(0.1)),
                  ),
                  // Đường Độ ẩm
                  LineChartBarData(
                    spots: [
                      for (var i = 0; i < humidityValues.length; i++)
                        FlSpot(i.toDouble(), humidityValues[i]),
                    ],
                    isCurved: true,
                    color: AppColors.chartHumidityLine,
                    barWidth: 2,
                    dashArray: [5, 5],
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) => spot.x % 4 == 0 || spot.x == barData.spots.length - 1,
                      getDotPainter: (spot, percent, barData, index) =>
                          FlDotCirclePainter(radius: 3, color: Colors.white, strokeWidth: 2, strokeColor: AppColors.chartHumidityLine),
                    ),
                  ),
                ],
                // Hiển thị giá trị khi chạm
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => AppColors.primary,
                    getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
                      return touchedBarSpots.map((barSpot) {
                        return LineTooltipItem(
                          '${barSpot.y.toStringAsFixed(1)}${barSpot.barIndex == 0 ? "°C" : "%"}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Center(child: Text('Mẫu dữ liệu gần nhất', style: TextStyle(fontSize: 10, color: Colors.grey))),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: AppColors.loginLabel)),
      ],
    );
  }
}
