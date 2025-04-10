import 'dart:math';
import 'package:flutter/material.dart';
import '../models/course.dart';

class MLService {
  // Recommend courses based on user preferences and history
  Future<List<Course>> recommendCourses(List<String> takenCourses, List<String> interests) async {
    // In a real app, this would use a machine learning model
    // For demo purposes, we'll simulate processing and return mock data
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock recommended courses
    return [
      Course(
        id: '5',
        code: 'CS301',
        name: 'Data Structures and Algorithms',
        instructor: 'Dr. Abbas',
        schedule: 'MWF 1:00 PM - 2:30 PM',
        location: 'Faculty of ST, Amphi N',
        credits: 4,
        description: 'Advanced data structures and algorithm analysis.',
        matchScore: 95,
        matchReason: 'Based on your interest in Computer Science and completion of CS101',
      ),
      Course(
        id: '6',
        code: 'CS350',
        name: 'Machine Learning',
        instructor: 'Dr. Rahab',
        schedule: 'TR 3:00 PM - 4:30 PM',
        location: 'Faculty of ST, room 64',
        credits: 3,
        description: 'Introduction to machine learning concepts and applications.',
        matchScore: 88,
        matchReason: 'Based on your interest in AI and Data Science',
      ),
      Course(
        id: '7',
        code: 'MATH301',
        name: 'Linear Algebra',
        instructor: 'Dr. Sahraoui',
        schedule: 'MWF 11:00 AM - 12:00 PM',
        location: 'Faculty of ST, Amphi O',
        credits: 3,
        description: 'Study of vector spaces, linear transformations, and matrices.',
        matchScore: 82,
        matchReason: 'Recommended for Machine Learning and Data Science paths',
      ),
      Course(
        id: '8',
        code: 'CS401',
        name: 'Database Systems',
        instructor: 'Dr. Belgroune',
        schedule: 'TR 1:00 PM - 2:30 PM',
        location: 'Faculty of ST, room 54',
        credits: 3,
        description: 'Design and implementation of database management systems.',
        matchScore: 78,
        matchReason: 'Complements your software development courses',
      ),
      Course(
        id: '9',
        code: 'CS450',
        name: 'Artificial Intelligence',
        instructor: 'Dr. Haouassi',
        schedule: 'MWF 3:00 PM - 4:30 PM',
        location: 'Faculty of ST, Amphi O',
        credits: 4,
        description: 'Fundamentals of artificial intelligence and intelligent systems.',
        matchScore: 75,
        matchReason: 'Based on your interest in AI technologies',
      ),
    ];
  }

  // Predict course enrollment trends
  Future<Map<String, dynamic>> predictEnrollmentTrends(List<Course> historicalData) async {
    // In a real app, this would use a time series prediction model
    // For demo purposes, we'll simulate processing and return mock data
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock prediction data
    final random = Random();

    return {
      'CS101': {
        'current_enrollment': 120,
        'predicted_next_term': 135,
        'growth_percentage': 12.5,
        'confidence': 0.85,
      },
      'MATH201': {
        'current_enrollment': 95,
        'predicted_next_term': 105,
        'growth_percentage': 10.5,
        'confidence': 0.78,
      },
      'ENG150': {
        'current_enrollment': 80,
        'predicted_next_term': 75,
        'growth_percentage': -6.25,
        'confidence': 0.72,
      },
    };
  }

  // Analyze sentiment from feedback
  Future<Map<String, dynamic>> analyzeSentiment(String text) async {
    // In a real app, this would use a natural language processing model
    // For demo purposes, we'll simulate processing and return mock data
    await Future.delayed(const Duration(seconds: 1));

    // Simple keyword-based sentiment analysis (for demo only)
    final lowerText = text.toLowerCase();

    int positiveScore = 0;
    int negativeScore = 0;

    // Check for positive keywords
    final positiveWords = ['good', 'great', 'excellent', 'amazing', 'helpful', 'enjoy', 'like', 'love'];
    for (final word in positiveWords) {
      if (lowerText.contains(word)) positiveScore++;
    }

    // Check for negative keywords
    final negativeWords = ['bad', 'poor', 'terrible', 'awful', 'unhelpful', 'dislike', 'hate', 'boring'];
    for (final word in negativeWords) {
      if (lowerText.contains(word)) negativeScore++;
    }

    // Calculate overall sentiment
    double sentimentScore = 0;
    if (positiveScore + negativeScore > 0) {
      sentimentScore = (positiveScore - negativeScore) / (positiveScore + negativeScore);
    }

    // Return sentiment analysis
    return {
      'sentiment_score': sentimentScore,
      'positive_score': positiveScore,
      'negative_score': negativeScore,
      'classification': sentimentScore > 0.2
          ? 'Positive'
          : sentimentScore < -0.2
          ? 'Negative'
          : 'Neutral',
      'keywords': _extractKeywords(text),
    };
  }

  // Predict GPA based on current courses and past performance
  Future<Map<String, dynamic>> predictGPA(
      double currentGPA,
      int creditsCompleted,
      List<Course> currentCourses,
      Map<String, String> studyHabits,
      ) async {
    // In a real app, this would use a regression model
    // For demo purposes, we'll simulate processing and return mock data
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock prediction
    final random = Random();
    final baseGPA = currentGPA;

    // Slightly adjust GPA based on random factors (simulating prediction)
    final predictedGPA = baseGPA + (random.nextDouble() * 0.4 - 0.2);

    // Ensure GPA is within valid range
    final clampedGPA = predictedGPA.clamp(0.0, 4.0);

    // Generate course-specific predictions
    final coursePredictions = <String, Map<String, dynamic>>{};
    for (final course in currentCourses) {
      // Random grade prediction between currentGPA-0.5 and currentGPA+0.5
      final gradePrediction = baseGPA + (random.nextDouble() - 0.5);
      final clampedGradePrediction = gradePrediction.clamp(0.0, 4.0);

      coursePredictions[course.code] = {
        'predicted_grade': clampedGradePrediction,
        'confidence': 0.7 + (random.nextDouble() * 0.2),
        'difficulty_level': _getCourseDifficulty(course.code),
        'recommended_study_hours': _getRecommendedStudyHours(course.credits),
      };
    }

    return {
      'current_gpa': currentGPA,
      'predicted_gpa': clampedGPA,
      'confidence': 0.75 + (random.nextDouble() * 0.15),
      'course_predictions': coursePredictions,
      'improvement_suggestions': _generateImprovementSuggestions(studyHabits),
    };
  }

  // Predict career paths based on courses and interests
  Future<List<Map<String, dynamic>>> predictCareerPaths(
      List<Course> completedCourses,
      List<String> interests,
      Map<String, double> skillScores,
      ) async {
    // In a real app, this would use a classification model
    // For demo purposes, we'll simulate processing and return mock data
    await Future.delayed(const Duration(seconds: 1));

    // Generate mock career paths
    return [
      {
        'title': 'Software Engineer',
        'match_score': 92,
        'description': 'Design, develop, and maintain software systems and applications.',
        'key_skills': ['Programming', 'Problem Solving', 'Software Design'],
        'recommended_courses': ['CS401: Database Systems', 'CS450: Artificial Intelligence'],
        'job_outlook': 'Excellent',
        'salary_range': '70,000 DZD - 120,000 DZD',
      },
      {
        'title': 'Data Scientist',
        'match_score': 85,
        'description': 'Analyze and interpret complex data to help organizations make better decisions.',
        'key_skills': ['Statistics', 'Machine Learning', 'Data Analysis'],
        'recommended_courses': ['CS350: Machine Learning', 'MATH301: Linear Algebra'],
        'job_outlook': 'Excellent',
        'salary_range': '80,000 DZD - 130,000 DZD',
      },
      {
        'title': 'UX/UI Designer',
        'match_score': 78,
        'description': 'Design user interfaces and experiences for websites and applications.',
        'key_skills': ['Design', 'User Research', 'Prototyping'],
        'recommended_courses': ['ART250: Digital Design', 'PSY320: Human-Computer Interaction'],
        'job_outlook': 'Good',
        'salary_range': '65,000 DZD - 110,000 DZD',
      },
      {
        'title': 'Product Manager',
        'match_score': 73,
        'description': 'Oversee the development and marketing of products or features.',
        'key_skills': ['Leadership', 'Communication', 'Strategic Thinking'],
        'recommended_courses': ['BUS340: Product Management', 'COM220: Business Communication'],
        'job_outlook': 'Good',
        'salary_range': '75,000 DZD - 125,000 DZD',
      },
      {
        'title': 'Cybersecurity Analyst',
        'match_score': 68,
        'description': 'Protect computer systems and networks from security breaches.',
        'key_skills': ['Network Security', 'Risk Assessment', 'Ethical Hacking'],
        'recommended_courses': ['CS460: Network Security', 'CS465: Ethical Hacking'],
        'job_outlook': 'Excellent',
        'salary_range': '75,000 DZD - 120,000 DZD',
      },
    ];
  }

  // Helper method to extract keywords from text
  List<String> _extractKeywords(String text) {
    final keywords = <String>[];
    final lowerText = text.toLowerCase();

    // List of potential academic keywords
    final academicKeywords = [
      'lecture', 'professor', 'exam', 'quiz', 'assignment', 'homework',
      'project', 'study', 'learn', 'understand', 'difficult', 'easy',
      'interesting', 'boring', 'helpful', 'confusing', 'clear', 'unclear',
      'organized', 'disorganized', 'engaging', 'interactive', 'practical',
      'theoretical', 'relevant', 'irrelevant', 'grading', 'feedback',
      'office hours', 'textbook', 'readings', 'materials', 'slides',
      'notes', 'discussion', 'participation', 'group work', 'deadline',
      'late', 'extension', 'syllabus', 'curriculum', 'content',
    ];

    // Check for keywords in text
    for (final keyword in academicKeywords) {
      if (lowerText.contains(keyword)) {
        keywords.add(keyword);
      }
    }

    return keywords;
  }

  // Helper method to get course difficulty
  String _getCourseDifficulty(String courseCode) {
    // In a real app, this would be based on historical data
    // For demo purposes, we'll use a simple mapping
    final difficultyMap = {
      'CS101': 'Moderate',
      'CS301': 'High',
      'CS350': 'High',
      'CS401': 'High',
      'CS450': 'Very High',
      'MATH201': 'High',
      'MATH301': 'High',
      'ENG150': 'Low',
      'PHYS220': 'High',
    };

    return difficultyMap[courseCode] ?? 'Moderate';
  }

  // Helper method to get recommended study hours
  int _getRecommendedStudyHours(int credits) {
    // General guideline: 2-3 hours of study per credit hour per week
    return credits * 3;
  }

  // Helper method to generate improvement suggestions
  List<String> _generateImprovementSuggestions(Map<String, String> studyHabits) {
    final suggestions = <String>[];

    // Check study habits and provide suggestions
    if (studyHabits.containsKey('study_time') &&
        (studyHabits['study_time'] == 'low' || studyHabits['study_time'] == 'moderate')) {
      suggestions.add('Increase weekly study time by 3-5 hours');
    }

    if (studyHabits.containsKey('note_taking') && studyHabits['note_taking'] == 'minimal') {
      suggestions.add('Improve note-taking techniques during lectures');
    }

    if (studyHabits.containsKey('group_study') && studyHabits['group_study'] == 'never') {
      suggestions.add('Join or form study groups for difficult courses');
    }

    if (studyHabits.containsKey('office_hours') && studyHabits['office_hours'] == 'never') {
      suggestions.add('Attend professor office hours for personalized help');
    }

    // Add general suggestions if list is empty
    if (suggestions.isEmpty) {
      suggestions.addAll([
        'Create a consistent study schedule',
        'Use active learning techniques like practice problems',
        'Review material regularly instead of cramming',
        'Take breaks during study sessions to maintain focus',
        'Utilize campus resources like tutoring centers',
      ]);
    }

    return suggestions;
  }
}
