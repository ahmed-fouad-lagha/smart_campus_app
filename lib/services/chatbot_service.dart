import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/message_model.dart';

class ChatBotService {
  static const String _baseUrl = 'https://your-chatbot-api.com';

  Future<Message> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMessage}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Message(
          text: data['response'],
          isUser: false,
          timestamp: DateTime.now(),
        );
      } else {
        throw Exception('Failed to get response from chatbot');
      }
    } catch (e) {
      return Message(
        text: 'Sorry, I encountered an error. Please try again.',
        isUser: false,
        timestamp: DateTime.now(),
      );
    }
  }
}