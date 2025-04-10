import 'package:html/dom.dart';

class ScrapingUtils {
  /// Extracts text from an element using a selector
  static String extractText(Element parent, String selector) {
    try {
      final element = parent.querySelector(selector);
      return element?.text.trim() ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Extracts an attribute from an element using a selector
  static String extractAttribute(Element parent, String selector, String attribute) {
    try {
      final element = parent.querySelector(selector);
      return element?.attributes[attribute]?.trim() ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Extracts all text from elements matching a selector
  static List<String> extractAllText(Element parent, String selector) {
    try {
      final elements = parent.querySelectorAll(selector);
      return elements.map((e) => e.text.trim()).toList();
    } catch (e) {
      return [];
    }
  }

  /// Validates if the scraped data matches expected format
  static bool validateData(String data, RegExp pattern) {
    return pattern.hasMatch(data);
  }

  /// Cleans HTML from text
  static String cleanHtml(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>'), '');
  }
}
