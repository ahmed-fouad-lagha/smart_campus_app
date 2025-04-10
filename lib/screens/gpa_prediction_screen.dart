import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../models/course.dart';
import '../services/ml_service.dart';

class GPAPredictionScreen extends StatefulWidget {
  const GPAPredictionScreen({Key? key}) : super(key: key);

  @override
  State<GPAPredictionScreen> createState() => _GPAPredictionScreenState();
}

class _GPAPredictionScreenState extends State<GPAPredictionScreen> {
  final MLService _mlService = MLService();

  bool _isLoading = true;
  Map<String, dynamic>? _prediction;
  String? _errorMessage;

  // Mock user data
  final double _currentGPA = 3.5;
  final int _creditsCompleted = 60;
  final List<Course> _currentCourses = [
    Course(
      id: '1',
      code: 'CS301',
      name: 'Data Structures and Algorithms',
      instructor: 'Dr. Garcia',
      schedule: 'MWF 1:00 PM - 2:30 PM',
      location: 'Science Building 201',
      credits: 4,
    ),
    Course(
      id: '2',
      code: 'MATH301',
      name: 'Linear Algebra',
      instructor: 'Dr. Patel',
      schedule: 'MWF 11:00 AM - 12:00 PM',
      location: 'Math Building 201',
      credits: 3,
    ),
    Course(
      id: '3',
      code: 'CS350',
      name: 'Machine Learning',
      instructor: 'Dr. Chen',
      schedule: 'TR 3:00 PM - 4:30 PM',
      location: 'Science Building 305',
      credits: 3,
    ),
  ];
  final Map<String, String> _studyHabits = {
    'study_time': 'moderate',
    'note_taking': 'good',
    'group_study': 'sometimes',
    'office_hours': 'rarely',
  };

  @override
  void initState() {
    super.initState();
    _loadPrediction();
  }

  Future<void> _loadPrediction() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prediction = await _mlService.predictGPA(
        _currentGPA,
        _creditsCompleted,
        _currentCourses,
        _studyHabits,
      );
      setState(() {
        _prediction = prediction;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load prediction. Please try again.';
        _isLoading = false;
      });
      print('Error loading prediction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GPA Prediction'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadPrediction,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _prediction == null
            ? const Center(child: Text('No prediction available'))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // GPA prediction card
              _buildGPAPredictionCard(),
              const SizedBox(height: 24),

              // Course predictions
              const Text(
                'Course Grade Predictions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildCoursePredictions(),
              const SizedBox(height: 24),

              // Improvement suggestions
              const Text(
                'Improvement Suggestions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildImprovementSuggestions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGPAPredictionCard() {
    final currentGPA = _prediction!['current_gpa'] as double;
    final predictedGPA = _prediction!['predicted_gpa'] as double;
    final confidence = _prediction!['confidence'] as double;

    final isImprovement = predictedGPA > currentGPA;
    final difference = (predictedGPA - currentGPA).abs();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'GPA Prediction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildGPAIndicator(
                  label: 'Current GPA',
                  gpa: currentGPA,
                  color: Colors.blue,
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.grey,
                ),
                _buildGPAIndicator(
                  label: 'Predicted GPA',
                  gpa: predictedGPA,
                  color: isImprovement ? Colors.green : Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              isImprovement
                  ? 'Your GPA is predicted to improve by ${difference.toStringAsFixed(2)} points'
                  : difference < 0.01
                  ? 'Your GPA is predicted to remain stable'
                  : 'Your GPA is predicted to decrease by ${difference.toStringAsFixed(2)} points',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isImprovement
                    ? Colors.green
                    : difference < 0.01
                    ? Colors.blue
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Prediction confidence: ${(confidence * 100).toStringAsFixed(0)}%',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGPAIndicator({
    required String label,
    required double gpa,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 8),
        CircularPercentIndicator(
          radius: 50,
          lineWidth: 10,
          percent: gpa / 4.0,
          center: Text(
            gpa.toStringAsFixed(2),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          progressColor: color,
          backgroundColor: Colors.grey[200]!,
          circularStrokeCap: CircularStrokeCap.round,
        ),
      ],
    );
  }

  Widget _buildCoursePredictions() {
    final coursePredictions = _prediction!['course_predictions'] as Map<String, dynamic>;

    return Column(
      children: _currentCourses.map((course) {
        final prediction = coursePredictions[course.code] as Map<String, dynamic>?;
        if (prediction == null) {
          return const SizedBox.shrink();
        }

        final predictedGrade = prediction['predicted_grade'] as double;
        final confidence = prediction['confidence'] as double;
        final difficulty = prediction['difficulty_level'] as String;
        final studyHours = prediction['recommended_study_hours'] as int;

        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        course.code,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        course.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Predicted Grade',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _getLetterGrade(predictedGrade),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(predictedGrade),
                          ),
                        ),
                        Text(
                          predictedGrade.toStringAsFixed(2),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getGradeColor(predictedGrade),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Difficulty',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          difficulty,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getDifficultyColor(difficulty),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Study Hours/Week',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '$studyHours hrs',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearPercentIndicator(
                  lineHeight: 8,
                  percent: confidence,
                  backgroundColor: Colors.grey[200],
                  progressColor: Colors.blue,
                  barRadius: const Radius.circular(4),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                Text(
                  'Prediction confidence: ${(confidence * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildImprovementSuggestions() {
    final suggestions = _prediction!['improvement_suggestions'] as List<String>;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(suggestion),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  String _getLetterGrade(double gpa) {
    if (gpa >= 3.7) return 'A';
    if (gpa >= 3.3) return 'A-';
    if (gpa >= 3.0) return 'B+';
    if (gpa >= 2.7) return 'B';
    if (gpa >= 2.3) return 'B-';
    if (gpa >= 2.0) return 'C+';
    if (gpa >= 1.7) return 'C';
    if (gpa >= 1.3) return 'C-';
    if (gpa >= 1.0) return 'D';
    return 'F';
  }

  Color _getGradeColor(double gpa) {
    if (gpa >= 3.7) return Colors.green;
    if (gpa >= 3.0) return Colors.blue;
    if (gpa >= 2.0) return Colors.orange;
    return Colors.red;
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Low':
        return Colors.green;
      case 'Moderate':
        return Colors.blue;
      case 'High':
        return Colors.orange;
      case 'Very High':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
