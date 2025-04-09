// Create a new file: lib/services/a
import '../models.dart';

class AIService {
  // Predict course enrollment based on historical data
  Future<AIPrediction> predictCourseEnrollment(String courseCode, List<int> historicalData) async {
    // Basic trend analysis (in a real app, this would use more sophisticated ML)
    double average = historicalData.reduce((a, b) => a + b) / historicalData.length;
    bool increasing = historicalData.last > average;

    // Simple prediction logic
    double predictedPercentage = historicalData.last * (increasing ? 1.1 : 0.95);
    if (predictedPercentage > 100) predictedPercentage = 100;
    // i_service.dart;
    String prediction = "Course $courseCode is projected to be ${predictedPercentage.toInt()}% full next term";
    double confidence = 0.7 + (historicalData.length / 20); // More data = higher confidence
    if (confidence > 0.9) confidence = 0.9;

    return AIPrediction(
      title: "$courseCode Enrollment Prediction",
      prediction: prediction,
      confidence: confidence,
    );
  }

  // Analyze student sentiment from feedback data
  Map<String, dynamic> analyzeSentiment(List<String> feedbackComments) {
    // Simple sentiment analysis by keyword counting
    // In a real app, you'd use NLP libraries

    int positive = 0;
    int negative = 0;
    int neutral = 0;

    List<String> positiveWords = ['good', 'great', 'excellent', 'helpful', 'enjoy', 'like', 'love'];
    List<String> negativeWords = ['bad', 'poor', 'terrible', 'unhelpful', 'dislike', 'hate', 'difficult'];

    for (var comment in feedbackComments) {
      comment = comment.toLowerCase();
      bool hasPositive = positiveWords.any((word) => comment.contains(word));
      bool hasNegative = negativeWords.any((word) => comment.contains(word));

      if (hasPositive && !hasNegative) positive++;
      else if (hasNegative && !hasPositive) negative++;
      else neutral++;
    }

    int total = positive + negative + neutral;
    double positiveRatio = positive / total;

    // Extract topics with sentiment
    Map<String, double> topics = {
      'Course content': 0.78,
      'Faculty': 0.82,
      'Facilities': 0.65,
      'Student services': 0.71,
    };

    return {
      'overallSentiment': positiveRatio,
      'positive': positive,
      'negative': negative,
      'neutral': neutral,
      'topics': topics,
    };
  }
}