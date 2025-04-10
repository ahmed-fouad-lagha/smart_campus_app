import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/course.dart';

class CourseAttendanceScreen extends StatefulWidget {
  final Course course;

  const CourseAttendanceScreen({
    Key? key,
    required this.course,
  }) : super(key: key);

  @override
  State<CourseAttendanceScreen> createState() => _CourseAttendanceScreenState();
}

class _CourseAttendanceScreenState extends State<CourseAttendanceScreen> {
  // Mock attendance data for the course
  late List<Map<String, dynamic>> _weeklyAttendance;
  late double _overallAttendance;
  late List<String> _topAttendingStudents;
  late List<String> _lowAttendingStudents;

  @override
  void initState() {
    super.initState();
    _generateMockData();
  }

  void _generateMockData() {
    // Generate weekly attendance data (last 10 weeks)
    _weeklyAttendance = List.generate(10, (index) {
      // Random attendance between 70% and 100%
      final weekNumber = index + 1;
      final baseAttendance = 70.0;
      final randomFactor = (widget.course.hashCode + weekNumber) % 30;
      final attendance = baseAttendance + randomFactor;

      return {
        'week': weekNumber,
        'attendance': attendance,
      };
    });

    // Calculate overall attendance
    _overallAttendance = _weeklyAttendance.map((e) => e['attendance'] as double).reduce((a, b) => a + b) / _weeklyAttendance.length;

    // Generate mock student data
    _topAttendingStudents = [
      'SID Aymen',
      'SEGHAIRI Ayad',
      'LALAOUNA Tarek',
    ];

    _lowAttendingStudents = [
      'LAGHA Fouad',
      'BENZAIM Abdelmouaine',
      'ZERDOUM Marouane',
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.course.code} Attendance'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Course info
            _buildCourseInfo(),
            const SizedBox(height: 24),

            // Overall attendance
            _buildOverallAttendance(),
            const SizedBox(height: 24),

            // Weekly attendance chart
            _buildSectionHeader('Weekly Attendance'),
            const SizedBox(height: 8),
            _buildWeeklyAttendanceChart(),
            const SizedBox(height: 24),

            // Student attendance
            _buildSectionHeader('Student Attendance'),
            const SizedBox(height: 8),
            _buildStudentAttendance(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildCourseInfo() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.course.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Instructor', widget.course.instructor),
            _buildInfoRow('Schedule', widget.course.schedule),
            _buildInfoRow('Location', widget.course.location),
            _buildInfoRow('Credits', widget.course.credits.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallAttendance() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Overall Attendance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 80,
              lineWidth: 15,
              percent: _overallAttendance / 100,
              center: Text(
                '${_overallAttendance.toStringAsFixed(1)}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              progressColor: _getAttendanceColor(_overallAttendance),
              backgroundColor: Colors.grey[200]!,
              circularStrokeCap: CircularStrokeCap.round,
              animation: true,
              animationDuration: 1000,
            ),
            const SizedBox(height: 16),
            Text(
              _getAttendanceMessage(_overallAttendance),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAttendanceMessage(double attendance) {
    if (attendance >= 90) {
      return 'Excellent attendance! Keep up the good work.';
    } else if (attendance >= 80) {
      return 'Good attendance. Try to maintain consistency.';
    } else if (attendance >= 70) {
      return 'Average attendance. Consider improving your attendance.';
    } else {
      return 'Poor attendance. Immediate improvement needed.';
    }
  }

  Color _getAttendanceColor(double attendance) {
    if (attendance >= 90) {
      return Colors.green;
    } else if (attendance >= 80) {
      return Colors.blue;
    } else if (attendance >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Widget _buildWeeklyAttendanceChart() {
    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            horizontalInterval: 10,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withOpacity(0.2),
                strokeWidth: 1,
              );
            },
            drawVerticalLine: false,
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  if (value % 1 == 0 && value >= 1 && value <= _weeklyAttendance.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Week ${value.toInt()}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  if (value % 20 == 0) {
                    return Text(
                      '${value.toInt()}%',
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 1,
          maxX: _weeklyAttendance.length.toDouble(),
          minY: 60,
          maxY: 100,
          lineBarsData: [
            LineChartBarData(
              spots: _weeklyAttendance.map((data) {
                return FlSpot(
                  data['week'].toDouble(),
                  data['attendance'].toDouble(),
                );
              }).toList(),
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.blue.withOpacity(0.2),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.blueGrey,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    'Week ${touchedSpot.x.toInt()}: ${touchedSpot.y.toStringAsFixed(1)}%',
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

  Widget _buildStudentAttendance() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStudentList(
            'Top Attending Students',
            _topAttendingStudents,
            Colors.green,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStudentList(
            'Low Attending Students',
            _lowAttendingStudents,
            Colors.red,
          ),
        ),
      ],
    );
  }

  Widget _buildStudentList(String title, List<String> students, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            ...students.map((student) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      student,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
}
