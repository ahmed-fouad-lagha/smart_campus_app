import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/course.dart';
import '../models/event.dart';
import '../models/university_config.dart'; // Import the shared model
import '../services/api_service.dart';
import '../services/web_scraper_service.dart';
import '../utils/logger.dart';

class DataRepository {
  final ApiService _apiService;
  final WebScraperService _scraperService = WebScraperService();
  final Logger _logger = Logger();

  DataRepository(this._apiService);

  // Cache keys
  static const String _scrapedCoursesKey = 'scraped_courses';
  static const String _scrapedEventsKey = 'scraped_events';
  static const String _universityConfigsKey = 'university_configs';
  static const String _lastScrapeTimeKey = 'last_scrape_time';

  // University configurations
  List<UniversityConfig> _universityConfigs = [];

  /// Initialize the repository
  Future<void> init() async {
    await _loadUniversityConfigs();
  }

  /// Load university configurations from storage
  Future<void> _loadUniversityConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = prefs.getString(_universityConfigsKey);

      if (configsJson != null) {
        final List<dynamic> configsList = jsonDecode(configsJson);
        _universityConfigs = configsList.map((json) => UniversityConfig.fromJson(json)).toList();
      } else {
        // Add a default configuration if none exists
        _universityConfigs = [_getDefaultConfig()];
        await _saveUniversityConfigs();
      }
    } catch (e) {
      _logger.error('Error loading university configs: $e');
      _universityConfigs = [_getDefaultConfig()];
    }
  }

  /// Save university configurations to storage
  Future<void> _saveUniversityConfigs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final configsJson = jsonEncode(_universityConfigs.map((config) => config.toJson()).toList());
      await prefs.setString(_universityConfigsKey, configsJson);
    } catch (e) {
      _logger.error('Error saving university configs: $e');
    }
  }

  /// Get a default university configuration
  UniversityConfig _getDefaultConfig() {
    return UniversityConfig(
      name: 'Example University',
      courseUrl: 'https://example.edu/courses',
      eventsUrl: 'https://example.edu/events',
      courseSelector: '.course-item',
      courseCodeSelector: '.course-code',
      courseNameSelector: '.course-name',
      instructorSelector: '.instructor',
      scheduleSelector: '.schedule',
      locationSelector: '.location',
      eventSelector: '.event-item',
      eventTitleSelector: '.event-title',
      eventDateSelector: '.event-date',
      eventLocationSelector: '.event-location',
      eventDescriptionSelector: '.event-description',
      eventOrganizerSelector: '.event-organizer',
    );
  }

  /// Get all university configurations
  List<UniversityConfig> getUniversityConfigs() {
    return _universityConfigs;
  }

  /// Add a new university configuration
  Future<void> addUniversityConfig(UniversityConfig config) async {
    _universityConfigs.add(config);
    await _saveUniversityConfigs();
  }

  /// Update an existing university configuration
  Future<void> updateUniversityConfig(int index, UniversityConfig config) async {
    if (index >= 0 && index < _universityConfigs.length) {
      _universityConfigs[index] = config;
      await _saveUniversityConfigs();
    }
  }

  /// Delete a university configuration
  Future<void> deleteUniversityConfig(int index) async {
    if (index >= 0 && index < _universityConfigs.length) {
      _universityConfigs.removeAt(index);
      await _saveUniversityConfigs();
    }
  }

  /// Fetch courses from API and web scraping
  Future<List<Course>> fetchCourses({bool forceRefresh = false}) async {
    List<Course> courses = [];

    try {
      // First try to get courses from API
      courses = await _apiService.fetchCourses();
    } catch (e) {
      _logger.warning('API fetch failed, falling back to scraped data: $e');

      // If API fails, try to get cached scraped courses
      if (!forceRefresh) {
        final cachedCourses = await _getCachedScrapedCourses();
        if (cachedCourses.isNotEmpty) {
          return cachedCourses;
        }
      }
    }

    // If we need to refresh or have no courses yet, scrape from websites
    if (forceRefresh || courses.isEmpty) {
      final scrapedCourses = await _scrapeAllCourses();

      // If we have API courses, add scraped courses that don't overlap
      if (courses.isNotEmpty) {
        final existingIds = courses.map((c) => c.id).toSet();
        courses.addAll(scrapedCourses.where((c) => !existingIds.contains(c.id)));
      } else {
        courses = scrapedCourses;
      }

      // Cache the scraped courses
      await _cacheScrapedCourses(scrapedCourses);
    }

    return courses;
  }

  /// Fetch events from API and web scraping
  Future<List<Event>> fetchEvents({bool forceRefresh = false}) async {
    List<Event> events = [];

    try {
      // First try to get events from API
      events = await _apiService.fetchEvents();
    } catch (e) {
      _logger.warning('API fetch failed, falling back to scraped data: $e');

      // If API fails, try to get cached scraped events
      if (!forceRefresh) {
        final cachedEvents = await _getCachedScrapedEvents();
        if (cachedEvents.isNotEmpty) {
          return cachedEvents;
        }
      }
    }

    // If we need to refresh or have no events yet, scrape from websites
    if (forceRefresh || events.isEmpty) {
      final scrapedEvents = await _scrapeAllEvents();

      // If we have API events, add scraped events that don't overlap
      if (events.isNotEmpty) {
        final existingIds = events.map((e) => e.id).toSet();
        events.addAll(scrapedEvents.where((e) => !existingIds.contains(e.id)));
      } else {
        events = scrapedEvents;
      }

      // Cache the scraped events
      await _cacheScrapedEvents(scrapedEvents);
    }

    return events;
  }

  /// Scrape courses from all configured university websites
  Future<List<Course>> _scrapeAllCourses() async {
    List<Course> allCourses = [];

    for (var config in _universityConfigs) {
      try {
        final courses = await _scraperService.scrapeCourses(config);
        allCourses.addAll(courses);
      } catch (e) {
        _logger.error('Error scraping courses from ${config.name}: $e');
      }
    }

    return allCourses;
  }

  /// Scrape events from all configured university websites
  Future<List<Event>> _scrapeAllEvents() async {
    List<Event> allEvents = [];

    for (var config in _universityConfigs) {
      try {
        final events = await _scraperService.scrapeEvents(config);
        allEvents.addAll(events);
      } catch (e) {
        _logger.error('Error scraping events from ${config.name}: $e');
      }
    }

    // Update last scrape time
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastScrapeTimeKey, DateTime.now().toIso8601String());

    return allEvents;
  }

  /// Cache scraped courses
  Future<void> _cacheScrapedCourses(List<Course> courses) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coursesJson = jsonEncode(courses.map((course) => course.toJson()).toList());
      await prefs.setString(_scrapedCoursesKey, coursesJson);
    } catch (e) {
      _logger.error('Error caching scraped courses: $e');
    }
  }

  /// Cache scraped events
  Future<void> _cacheScrapedEvents(List<Event> events) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = jsonEncode(events.map((event) => event.toJson()).toList());
      await prefs.setString(_scrapedEventsKey, eventsJson);
    } catch (e) {
      _logger.error('Error caching scraped events: $e');
    }
  }

  /// Get cached scraped courses
  Future<List<Course>> _getCachedScrapedCourses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final coursesJson = prefs.getString(_scrapedCoursesKey);

      if (coursesJson == null) return [];

      final List<dynamic> coursesList = jsonDecode(coursesJson);
      return coursesList.map((json) => Course.fromJson(json)).toList();
    } catch (e) {
      _logger.error('Error retrieving cached scraped courses: $e');
      return [];
    }
  }

  /// Get cached scraped events
  Future<List<Event>> _getCachedScrapedEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final eventsJson = prefs.getString(_scrapedEventsKey);

      if (eventsJson == null) return [];

      final List<dynamic> eventsList = jsonDecode(eventsJson);
      return eventsList.map((json) => Event.fromJson(json)).toList();
    } catch (e) {
      _logger.error('Error retrieving cached scraped events: $e');
      return [];
    }
  }

  /// Get the timestamp of the last scrape
  Future<DateTime?> getLastScrapeTime() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastScrapeTime = prefs.getString(_lastScrapeTimeKey);

      if (lastScrapeTime == null) return null;

      return DateTime.parse(lastScrapeTime);
    } catch (e) {
      _logger.error('Error getting last scrape time: $e');
      return null;
    }
  }

  /// Disposes of resources
  void dispose() {
    _scraperService.dispose();
  }
}
