import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../models/course.dart';
import '../services/ml_service.dart';
import '../services/storage_service.dart';

class CourseRecommendationsScreen extends StatefulWidget {
  const CourseRecommendationsScreen({Key? key}) : super(key: key);

  @override
  State<CourseRecommendationsScreen> createState() => _CourseRecommendationsScreenState();
}

class _CourseRecommendationsScreenState extends State<CourseRecommendationsScreen> {
  final MLService _mlService = MLService();

  bool _isLoading = true;
  List<Course> _recommendedCourses = [];
  String? _errorMessage;

  // Mock user data
  final List<String> _takenCourses = ['CS101', 'MATH201', 'ENG150'];
  final List<String> _interests = ['Computer Science', 'AI', 'Data Science'];

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final recommendations = await _mlService.recommendCourses(_takenCourses, _interests);
      setState(() {
        _recommendedCourses = recommendations;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load recommendations. Please try again.';
        _isLoading = false;
      });
      print('Error loading recommendations: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final storageService = Provider.of<StorageService>(context);
    final userName = storageService.getUserName() ?? 'User';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Course Recommendations'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadRecommendations,
        child: _isLoading
            ? _buildLoadingState()
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _recommendedCourses.isEmpty
            ? const Center(child: Text('No recommendations available'))
            : SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                'Hello, $userName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Here are your personalized course recommendations',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // Interests and taken courses
              _buildInterestsSection(),
              const SizedBox(height: 24),

              // Recommendations
              const Text(
                'Recommended Courses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Course cards
              ...List.generate(
                _recommendedCourses.length,
                    (index) => _buildCourseCard(_recommendedCourses[index]),
              ),
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
            // Header placeholder
            Container(
              width: 200,
              height: 24,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Container(
              width: 300,
              height: 16,
              color: Colors.white,
            ),
            const SizedBox(height: 24),

            // Interests placeholder
            Container(
              width: 150,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Row(
              children: List.generate(
                3,
                    (index) => Container(
                  width: 80,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8),
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recommendations placeholder
            Container(
              width: 200,
              height: 20,
              color: Colors.white,
            ),
            const SizedBox(height: 16),

            // Course cards placeholder
            ...List.generate(
              5,
                  (index) => Container(
                width: double.infinity,
                height: 150,
                margin: const EdgeInsets.only(bottom: 16),
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Based on your interests',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _interests.map((interest) => Chip(
            label: Text(interest),
            backgroundColor: Colors.blue.shade100,
            labelStyle: TextStyle(color: Colors.blue.shade800),
          )).toList(),
        ),
        const SizedBox(height: 16),
        const Text(
          'Courses you\'ve taken',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _takenCourses.map((course) => Chip(
            label: Text(course),
            backgroundColor: Colors.green.shade100,
            labelStyle: TextStyle(color: Colors.green.shade800),
          )).toList(),
        ),
      ],
    );
  }

  Widget _buildCourseCard(Course course) {
    final matchScore = course.matchScore ?? 0;

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
                  Icons.recommend,
                  color: _getMatchColor(matchScore),
                ),
                const SizedBox(width: 8),
                Text(
                  '$matchScore% Match',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getMatchColor(matchScore),
                  ),
                ),
                const Spacer(),
                if (course.matchReason != null)
                  Tooltip(
                    message: course.matchReason!,
                    child: const Icon(Icons.info_outline),
                  ),
              ],
            ),
          ),
          Padding(
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  course.description ?? 'No description available',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(
                      label: course.instructor,
                      icon: Icons.person,
                    ),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                      label: '${course.credits} credits',
                      icon: Icons.school,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      label: course.schedule,
                      icon: Icons.access_time,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                      label: course.location,
                      icon: Icons.location_on,
                    ),
                  ],
                ),
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add to Schedule'),
                onPressed: () {
                  // Add course to schedule
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${course.code} to your schedule'),
                    ),
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.info_outline),
                label: const Text('Details'),
                onPressed: () {
                  // Show course details
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required String label,
    required IconData icon,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
}
