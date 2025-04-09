// Create a new file: lib/widgets/enrollment_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EnrollmentChart extends StatelessWidget {
  final Map<String, List<double>> courseData;

  const EnrollmentChart({super.key, required this.courseData});

  @override
  Widget build(BuildContext context) {
    if (courseData.isEmpty) {
      return const Center(child: Text('No data available'));
    }
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text('${value.toInt()}%');
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  const terms = ['Fall', 'Winter', 'Spring', 'Summer'];
                  if (value >= 0 && value < terms.length) {
                    return Text(terms[value.toInt()]);
                  }
                  return const Text('');
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: _createLineBarsData(),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((LineBarSpot spot) {
                  final courseNames = courseData.keys.toList();
                  final courseName = courseNames[spot.barIndex];
                  return LineTooltipItem(
                    '$courseName: ${spot.y.toInt()}%',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> _createLineBarsData() {
    if (courseData.isEmpty) return [];


    final List<Color> colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.purple,
    ];

    List<LineChartBarData> result = [];
    int colorIndex = 0;

    courseData.forEach((course, data) {
      result.add(
        LineChartBarData(
          spots: List.generate(data.length, (i) => FlSpot(i.toDouble(), data[i])),
          isCurved: true,
          color: colors[colorIndex % colors.length],
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(show: true),
          belowBarData: BarAreaData(show: false),
        ),
      );
      colorIndex++;
    });

    return result;
  }
}