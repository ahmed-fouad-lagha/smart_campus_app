// Create a new file: lib/services/sync_service.dart
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'web_scraper.dart';
import '../models.dart';

class SyncService {
  final WebScraperService _webScraper = WebScraperService();
  Timer? _syncTimer;
  bool _isSyncing = false;

  // Initialize with default interval of 6 Hours
  void startPeriodicSync({int intervalHours = 6}) {
    _syncTimer?.cancel();

    // First sync immediately
    syncAllData();

    // Then set up periodic sync
    _syncTimer = Timer.periodic(
      Duration(hours: intervalHours),
          (_) => syncAllData(),
    );
  }

  void updateSyncInterval(int hours) {
    startPeriodicSync(intervalHours: hours);
  }

  void stopSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
  }

  Future<bool> syncAllData() async {
    if (_isSyncing) return false;

    _isSyncing = true;
    bool success = false;

    try {
      // Check connectivity first
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        _isSyncing = false;
        return false;
      }

      // Example university URLs (replace with actual URLs)
      const String announcementsUrl = 'https://example.university.edu/announcements';
      const String coursesUrl = 'https://example.university.edu/courses';
      const String eventsUrl = 'https://example.university.edu/events';

      // Sync updates
      await _syncUpdates(announcementsUrl);

      // Sync other data types (implement as needed)
      // await _syncCourses(coursesUrl);
      // await _syncEvents(eventsUrl);

      success = true;
    } catch (e) {
      print('Error during sync: $e');
      success = false;
    } finally {
      _isSyncing = false;
    }

    return success;
  }

  Future<void> _syncUpdates(String url) async {
    try {
      final newUpdates = await _webScraper.scrapeUniversityUpdates(url);
      if (newUpdates.isNotEmpty) {
        final box = Hive.box<UpdateItem>('updates');

        // Simple sync logic - could be improved to avoid duplicates
        for (var update in newUpdates) {
          await box.add(update);
        }
      }
    } catch (e) {
      print('Error syncing updates: $e');
    }
  }
}