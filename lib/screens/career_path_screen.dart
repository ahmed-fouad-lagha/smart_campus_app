import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/course.dart';
import '../services/ml_service.dart';

class CareerPathScreen extends StatefulWidget {
  const CareerPathScreen({Key? key}) : super(key: key);

  @override
  State<CareerPathScreen> createState() => _CareerPathScreenState();
}

class _CareerPathScreenState extends State<CareerPathScreen> {
  final MLService _mlService = MLService();

  bool _isLoading = true;
  List<Map<String, dynamic>> _careerPaths = [];
  String? _errorMessage;

  // Mock user data
  final List<Course> _completedCourses = [
    Course(
      id: '1',
      code: 'CS101',
      name: 'Introduction to Computer Science',
      instructor: 'Dr. Smith',
      schedule: 'MWF 10:00 AM - 11:30 AM',
      location: 'Faculty of ST, Amphi N',
      credits: 3,
    ),
    Course(
      id: '2',
      code: 'MATH201',
      name: 'Calculus II',
      instructor: 'Dr. Hamame',
      schedule: 'TR 1:00 PM - 2:30 PM',
      location: 'Faculty of ST, Amphi O',
      credits: 4,
    ),
  ];
  final List<String> _interests = ['Programming', 'Data Science', 'Design'];
  final Map<String, double> _skillScores = {
    'Programming': 4.2,
    'Problem Solving': 4.0,
    'Mathematics': 3.8,
    'Communication': 3.5,
    'Design': 3.2,
  };

  @override
  void initState() {
    super.initState();
    _loadCareerPaths();
  }

  Future<void> _loadCareerPaths() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final careerPaths = await _mlService.predictCareerPaths(
        _completedCourses,
        _interests,
        _skillScores,
      );
      setState(() {
        _careerPaths = careerPaths;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load career paths. Please try again.';
        _isLoading = false;
      });
      print('Error loading career paths: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Path Predictions'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadCareerPaths,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _careerPaths.isEmpty
            ? const Center(child: Text('No career paths available'))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const Text(
                'Your Career Matches',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Based on your courses, interests, and skills',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Skills section
              _buildSkillsSection(),
              const SizedBox(height: 24),

              // Career paths
              ..._careerPaths.map((career) => _buildCareerCard(career)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillsSection() {
    // Sort skills by score (descending)
    final sortedSkills = _skillScores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Top Skills',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...sortedSkills.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        entry.value.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: _getSkillColor(entry.value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearPercentIndicator(
                    lineHeight: 8,
                    percent: entry.value / 5.0,
                    backgroundColor: Colors.grey[200],
                    progressColor: _getSkillColor(entry.value),
                    barRadius: const Radius.circular(4),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildCareerCard(Map<String, dynamic> career) {
    final title = career['title'] as String;
    final matchScore = career['match_score'] as int;
    final description = career['description'] as String;
    final keySkills = career['key_skills'] as List<String>;
    final recommendedCourses = career['recommended_courses'] as List<String>;
    final jobOutlook = career['job_outlook'] as String;
    final salaryRange = career['salary_range'] as String;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: _getMatchColor(matchScore),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _getMatchColor(matchScore).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.work,
                  color: _getMatchColor(matchScore),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getMatchColor(matchScore),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$matchScore% Match',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),

                // Job outlook and salary
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoBox(
                        label: 'Job Outlook',
                        value: jobOutlook,
                        icon: Icons.trending_up,
                        color: _getOutlookColor(jobOutlook),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildInfoBox(
                        label: 'Salary Range',
                        value: salaryRange,
                        icon: Icons.attach_money,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Key skills
                const Text(
                  'Key Skills',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: keySkills.map((skill) => Chip(
                    label: Text(skill),
                    backgroundColor: Colors.blue.shade100,
                    labelStyle: TextStyle(color: Colors.blue.shade800),
                  )).toList(),
                ),
                const SizedBox(height: 16),

                // Recommended courses
                const Text(
                  'Recommended Courses',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                ...recommendedCourses.map((course) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.school,
                        size: 16,
                        color: Colors.blue,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(course),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.explore),
                label: const Text('Explore Career'),
                onPressed: () {
                  // Navigate to career details
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBox({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Color _getMatchColor(int matchScore) {
    if (matchScore >= 90) {
      return Colors.green;
    } else if (matchScore >= 80) {
      return Colors.blue;
    } else if (matchScore >= 70) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getSkillColor(double score) {
    if (score >= 4.0) {
      return Colors.green;
    } else if (score >= 3.0) {
      return Colors.blue;
    } else if (score >= 2.0) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  Color _getOutlookColor(String outlook) {
    switch (outlook) {
      case 'Excellent':
        return Colors.green;
      case 'Good':
        return Colors.blue;
      case 'Fair':
        return Colors.orange;
      case 'Poor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
