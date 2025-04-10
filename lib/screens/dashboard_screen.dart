import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../services/api_service.dart';
import '../services/ml_service.dart';
import '../services/storage_service.dart';
import '../models/course.dart';
import '../utils/date_formatter.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  final MLService _mlService = MLService();

  bool _isLoading = true;
  List<Course> _courses = [];
  Map<String, dynamic> _enrollmentTrends = {};
  Map<String, double> _attendanceData = {};
  List<Map<String, dynamic>> _eventPopularity = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load courses
      final courses = await _apiService.fetchCourses();

      // Generate mock attendance data
      final attendanceData = <String, double>{};
      for (final course in courses) {
        // Random attendance percentage between 70% and 100%
        attendanceData[course.code] = 70 + (30 * (course.hashCode % 100) / 100);
      }

      // Get enrollment trends prediction
      final enrollmentTrends = await _mlService.predictEnrollmentTrends(courses);

      // Generate mock event popularity data
      final events = await _apiService.fetchEvents();
      final eventPopularity = events.map((event) {
        // Random popularity score between 10 and 100
        final popularity = 10 + (90 * (event.hashCode % 100) / 100).round();
        return {
          'name': event.title,
          'popularity': popularity,
          'date': event.date,
        };
      }).toList();

      // Sort events by popularity
      eventPopularity.sort((a, b) => (b['popularity'] as int).compareTo(a['popularity'] as int));

      setState(() {
        _courses = courses;
        _attendanceData = attendanceData;
        _enrollmentTrends = enrollmentTrends;
        _eventPopularity = eventPopularity;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);
    final userName = storageService.getUserName() ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: _isLoading
            ? _buildLoadingState()
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome message
              Text(
                'Hello, $userName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Here\'s your academic overview',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Summary cards
              _buildSummaryCards(),
              const SizedBox(height: 24),

              // Course attendance chart
              _buildSectionHeader('Course Attendance'),
              const SizedBox(height: 8),
              _buildAttendanceChart(),
              const SizedBox(height: 24),

              // Enrollment trends
              _buildSectionHeader('Enrollment Trends'),
              const SizedBox(height: 8),
              _buildEnrollmentTrendsChart(),
              const SizedBox(height: 24),

              // Event popularity
              _buildSectionHeader('Event Popularity'),
              const SizedBox(height: 8),
              _buildEventPopularityChart(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome message placeholder
            Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 250,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            // Summary cards placeholder
            Row(
              children: List.generate(
                3,
                    (index) => Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    height: 100,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Chart placeholders
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.white,
            ),
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

  Widget _buildSummaryCards() {
    // Calculate overall attendance
    double overallAttendance = 0;
    if (_attendanceData.isNotEmpty) {
      overallAttendance = _attendanceData.values.reduce((a, b) => a + b) / _attendanceData.length;
    }

    // Calculate overall growth
    double overallGrowth = 0;
    if (_enrollmentTrends.isNotEmpty) {
      int count = 0;
      double totalGrowth = 0;
      _enrollmentTrends.forEach((key, value) {
        if (value is Map && value.containsKey('growth_percentage')) {
          totalGrowth += value['growth_percentage'] as double;
          count++;
        }
      });
      if (count > 0) {
        overallGrowth = totalGrowth / count;
      }
    }

    // Calculate upcoming events
    int upcomingEvents = _eventPopularity.where((event) {
      final eventDate = event['date'] as DateTime;
      return eventDate.isAfter(DateTime.now());
    }).length;

    return Row(
      children: [
        _buildSummaryCard(
          title: 'Attendance',
          value: '${overallAttendance.toStringAsFixed(1)}%',
          icon: Icons.people,
          color: Colors.blue,
        ),
        _buildSummaryCard(
          title: 'Enrollment Growth',
          value: '${overallGrowth >= 0 ? '+' : ''}${overallGrowth.toStringAsFixed(1)}%',
          icon: Icons.trending_up,
          color: overallGrowth >= 0 ? Colors.green : Colors.red,
        ),
        _buildSummaryCard(
          title: 'Upcoming Events',
          value: '$upcomingEvents',
          icon: Icons.event,
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.only(right: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceChart() {
    if (_attendanceData.isEmpty) {
      return const Center(
        child: Text('No attendance data available'),
      );
    }

    // Sort courses by attendance (descending)
    final sortedCourses = _attendanceData.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

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
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        '${sortedCourses[groupIndex].key}: ${rod.toY.toStringAsFixed(1)}%',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < sortedCourses.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              sortedCourses[value.toInt()].key,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
                      reservedSize: 30,
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
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 20,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(
                  sortedCourses.length > 5 ? 5 : sortedCourses.length,
                      (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: sortedCourses[index].value,
                        color: _getAttendanceColor(sortedCourses[index].value),
                        width: 20,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Course Attendance Rates',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
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

  Widget _buildEnrollmentTrendsChart() {
    if (_enrollmentTrends.isEmpty) {
      return const Center(
        child: Text('No enrollment trend data available'),
      );
    }

    // Convert enrollment trends to list for chart
    final trendsList = _enrollmentTrends.entries.map((entry) {
      final courseCode = entry.key;
      final data = entry.value as Map<String, dynamic>;
      return {
        'code': courseCode,
        'current': data['current_enrollment'] as int,
        'predicted': data['predicted_next_term'] as int,
        'growth': data['growth_percentage'] as double,
      };
    }).toList();

    // Sort by growth percentage (descending)
    trendsList.sort((a, b) => (b['growth'] as double).compareTo(a['growth'] as double));

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
      child: Column(
        children: [
          Expanded(
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: trendsList.map((e) => (e['predicted'] as int) * 1.1).reduce((a, b) => a > b ? a : b),
                barTouchData: BarTouchData(
                  enabled: true,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.blueGrey,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final course = trendsList[groupIndex];
                      final isCurrentEnrollment = rodIndex == 0;
                      return BarTooltipItem(
                        '${course['code']}: ${isCurrentEnrollment ? 'Current' : 'Predicted'} ${rod.toY.toInt()}',
                        const TextStyle(color: Colors.white),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value >= 0 && value < trendsList.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              trendsList[value.toInt()]['code'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
                        if (value % 50 == 0) {
                          return Text(
                            value.toInt().toString(),
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
                gridData: FlGridData(
                  show: true,
                  horizontalInterval: 50,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.withOpacity(0.2),
                      strokeWidth: 1,
                    );
                  },
                ),
                barGroups: List.generate(
                  trendsList.length > 3 ? 3 : trendsList.length,
                      (index) {
                    final course = trendsList[index];
                    final current = course['current'] as int;
                    final predicted = course['predicted'] as int;
                    final growth = course['growth'] as double;

                    return BarChartGroupData(
                      x: index,
                      groupVertically: false,
                      barRods: [
                        BarChartRodData(
                          toY: current.toDouble(),
                          color: Colors.blue,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                        BarChartRodData(
                          toY: predicted.toDouble(),
                          color: growth >= 0 ? Colors.green : Colors.red,
                          width: 16,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Current', Colors.blue),
              const SizedBox(width: 16),
              _buildLegendItem('Predicted', Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildEventPopularityChart() {
    if (_eventPopularity.isEmpty) {
      return const Center(
        child: Text('No event popularity data available'),
      );
    }

    // Take top 5 events
    final topEvents = _eventPopularity.take(5).toList();

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
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: topEvents.length,
              itemBuilder: (context, index) {
                final event = topEvents[index];
                final name = event['name'] as String;
                final popularity = event['popularity'] as int;
                final date = event['date'] as DateTime;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            DateFormatter.formatShortDate(date),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      LinearPercentIndicator(
                        lineHeight: 12,
                        percent: popularity / 100,
                        backgroundColor: Colors.grey[200],
                        progressColor: _getPopularityColor(popularity),
                        barRadius: const Radius.circular(8),
                        trailing: Text(
                          '$popularity%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _getPopularityColor(popularity),
                          ),
                        ),
                        padding: const EdgeInsets.only(right: 8),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Most Popular Events',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getPopularityColor(int popularity) {
    if (popularity >= 80) {
      return Colors.purple;
    } else if (popularity >= 60) {
      return Colors.blue;
    } else if (popularity >= 40) {
      return Colors.green;
    } else if (popularity >= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
