import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart';
import 'dart:async';
import '../models/course.dart';
import '../models/event.dart';
import '../models/university_config.dart';
import '../utils/logger.dart';

class WebScraperService {
  final http.Client _client = http.Client();
  final Logger _logger = Logger();

  /// Fetches HTML content from a given URL
  Future<Document?> _fetchHtml(String url) async {
    try {
      final response = await _client.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return parser.parse(response.body);
      } else {
        _logger.error('Failed to load URL: $url, Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      _logger.error('Error fetching URL: $url, Error: $e');
      return null;
    }
  }

  /// Scrapes course data from a university website
  Future<List<Course>> scrapeCourses(UniversityConfig config) async {
    final document = await _fetchHtml(config.courseUrl);
    if (document == null) return [];

    List<Course> courses = [];

    try {
      // Use the university-specific selectors to find course elements
      final courseElements = document.querySelectorAll(config.courseSelector);

      for (var element in courseElements) {
        final code = _extractText(element, config.courseCodeSelector);
        final name = _extractText(element, config.courseNameSelector);
        final instructor = _extractText(element, config.instructorSelector);
        final schedule = _extractText(element, config.scheduleSelector);
        final location = _extractText(element, config.locationSelector);

        // Create a Course object with only the parameters that are defined in your Course class
        // Adjust this constructor call to match your actual Course class definition
        courses.add(Course(
          id: 'scraped_${code.replaceAll(' ', '_')}',
          code: code,
          name: name,
          instructor: instructor,
          schedule: schedule,
          location: location,
          credits: 3, // Default value
          // Remove the department parameter if it's not in your Course class
          // If you need department, you'll need to add it to your Course class
        ));
      }
    } catch (e) {
      _logger.error('Error scraping courses from ${config.name}: $e');
    }

    return courses;
  }

  /// Scrapes event data from a university website
  Future<List<Event>> scrapeEvents(UniversityConfig config) async {
    final document = await _fetchHtml(config.eventsUrl);
    if (document == null) return [];

    List<Event> events = [];

    try {
      final eventElements = document.querySelectorAll(config.eventSelector);

      for (var element in eventElements) {
        final title = _extractText(element, config.eventTitleSelector);
        final dateStr = _extractText(element, config.eventDateSelector);
        final location = _extractText(element, config.eventLocationSelector);
        final description = _extractText(element, config.eventDescriptionSelector);
        final organizer = _extractText(element, config.eventOrganizerSelector);

        // Parse date from string - this is a simplified approach
        DateTime date;
        try {
          date = DateTime.parse(dateStr);
        } catch (e) {
          // Fallback to current date if parsing fails
          date = DateTime.now().add(const Duration(days: 7));
        }

        events.add(Event(
          id: 'scraped_${title.hashCode}',
          title: title,
          date: date,
          location: location,
          description: description,
          organizer: organizer.isEmpty ? 'University' : organizer,
        ));
      }
    } catch (e) {
      _logger.error('Error scraping events from ${config.name}: $e');
    }

    return events;
  }

  /// Extracts text from an element using a selector
  String _extractText(Element parent, String selector) {
    try {
      final element = parent.querySelector(selector);
      return element?.text.trim() ?? '';
    } catch (e) {
      return '';
    }
  }

  /// Dispose of the HTTP client when done
  void dispose() {
    _client.close();
  }
}
