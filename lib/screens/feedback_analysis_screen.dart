import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../services/ml_service.dart';

class FeedbackAnalysisScreen extends StatefulWidget {
  const FeedbackAnalysisScreen({Key? key}) : super(key: key);

  @override
  State<FeedbackAnalysisScreen> createState() => _FeedbackAnalysisScreenState();
}

class _FeedbackAnalysisScreenState extends State<FeedbackAnalysisScreen> {
  final MLService _mlService = MLService();
  final TextEditingController _feedbackController = TextEditingController();

  bool _isAnalyzing = false;
  Map<String, dynamic>? _analysis;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _analyzeFeedback() async {
    final feedback = _feedbackController.text.trim();
    if (feedback.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter some feedback to analyze'),
        ),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
    });

    try {
      final analysis = await _mlService.analyzeSentiment(feedback);
      setState(() {
        _analysis = analysis;
        _isAnalyzing = false;
      });
    } catch (e) {
      setState(() {
        _isAnalyzing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error analyzing feedback: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback Analysis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Sentiment Analysis',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Enter your feedback about a course or instructor',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 24),

            // Feedback input
            TextField(
              controller: _feedbackController,
              decoration: const InputDecoration(
                labelText: 'Your Feedback',
                hintText: 'Enter your feedback here...',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16),

            // Analyze button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeFeedback,
                child: _isAnalyzing
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('Analyze Feedback'),
              ),
            ),
            const SizedBox(height: 24),

            // Analysis results
            if (_analysis != null) ...[
              const Text(
                'Analysis Results',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildSentimentCard(),
              const SizedBox(height: 16),
              _buildKeywordsCard(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentCard() {
    final sentimentScore = _analysis!['sentiment_score'] as double;
    final positiveScore = _analysis!['positive_score'] as int;
    final negativeScore = _analysis!['negative_score'] as int;
    final classification = _analysis!['classification'] as String;

    // Normalize sentiment score to 0-1 range
    final normalizedScore = (sentimentScore + 1) / 2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Sentiment: $classification',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getSentimentColor(classification),
              ),
            ),
            const SizedBox(height: 16),
            CircularPercentIndicator(
              radius: 60,
              lineWidth: 12,
              percent: normalizedScore,
              center: Text(
                '${(normalizedScore * 100).toStringAsFixed(0)}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              progressColor: _getSentimentColor(classification),
              backgroundColor: Colors.grey[200]!,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreIndicator(
                  label: 'Positive',
                  score: positiveScore,
                  color: Colors.green,
                ),
                _buildScoreIndicator(
                  label: 'Negative',
                  score: negativeScore,
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreIndicator({
    required String label,
    required int score,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              score.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeywordsCard() {
    final keywords = _analysis!['keywords'] as List<String>;

    if (keywords.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No significant keywords detected'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Detected Keywords',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keywords.map((keyword) => Chip(
                label: Text(keyword),
                backgroundColor: Colors.grey[200],
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment) {
      case 'Positive':
        return Colors.green;
      case 'Negative':
        return Colors.red;
      case 'Neutral':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
