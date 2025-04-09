import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models.dart';
import 'services/web_scraper.dart';
import 'services/sync_service.dart';
import 'services/ai_service.dart';
import 'screens/search_screen.dart';
import 'widgets/enrollment_chart.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Hive for offline storage
    await Hive.initFlutter();
    Hive.registerAdapter(UpdateItemAdapter());
    Hive.registerAdapter(CourseItemAdapter());
    Hive.registerAdapter(EventItemAdapter());
    await Hive.openBox<UpdateItem>('updates');
    await Hive.openBox<CourseItem>('courses');
    await Hive.openBox<EventItem>('events');
  } catch (e) {
    print('Error initializing Hive: $e');
  }

  // Rest of your main() function
  // Initialize sync service
  final syncService = SyncService();
  syncService.startPeriodicSync();

  runApp(SmartCampusApp(syncService: syncService));
}

class SmartCampusApp extends StatelessWidget {
  final SyncService syncService;

  const SmartCampusApp({super.key, required this.syncService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Campus Insights',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.grey[100],
          foregroundColor: Colors.black,
        ),
      ),
      home: HomeScreen(syncService: syncService),
      debugShowCheckedModeBanner: false,
      routes: {
        '/settings': (context) => SettingsScreen(syncService: syncService),
        '/search': (context) => const SearchScreen(),
      },
    );
  }
}

// Dummy data for demonstration
final List<StatItem> dummyStats = [
  StatItem(title: "Upcoming Events", value: "5", unit: "", icon: Icons.event),
  StatItem(title: "Available Courses", value: "12", unit: "", icon: Icons.school),
  StatItem(title: "New Announcements", value: "3", unit: "", icon: Icons.announcement),
];

final List<AIPrediction> dummyPredictions = [
  AIPrediction(title: "CS101 Enrollment", prediction: "Course will be 80% full next term", confidence: 0.85),
  AIPrediction(title: "Event Attendance", prediction: "High expected attendance for career workshop", confidence: 0.72),
];

class HomeScreen extends StatefulWidget {
  final SyncService syncService;

  const HomeScreen({super.key, required this.syncService});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Smart Campus Insights'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showNotificationPreview(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      drawer: _buildAppDrawer(context),
      body: _buildCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,  // Add this for 4+ items
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Courses'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
      floatingActionButton: _currentIndex == 0 ? FloatingActionButton(
        onPressed: () async {
          final success = await widget.syncService.syncAllData();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(success ? 'Data synced successfully!' : 'Sync failed. Please check your connection.'),
              duration: const Duration(seconds: 2),
            ),
          );
        },
        child: const Icon(Icons.sync),
      ) : null,
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0: return const DashboardScreen();
      case 1: return const CoursesScreen();
      case 2: return const EventsScreen();
      case 3: return const SearchScreen();
      default: return const DashboardScreen();
    }
  }

  Widget _buildAppDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Smart Campus\nInsights',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Academic Calendar'),
            onTap: () => _navigateToPlaceholder(context, 'Academic Calendar'),
          ),
          ListTile(
            leading: const Icon(Icons.library_books),
            title: const Text('Research Portal'),
            onTap: () => _navigateToPlaceholder(context, 'Research Portal'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Multi-University Mode'),
            onTap: () => _showMultiUniversityDialog(context),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            onTap: () => _showAboutDialog(context),
          ),
        ],
      ),
    );
  }

  void _navigateToPlaceholder(BuildContext context, String title) {
    Navigator.pop(context); // Close drawer
    Navigator.push(context, MaterialPageRoute(
        builder: (context) => PlaceholderScreen(title: title)));
  }

  void _showNotificationPreview(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('New campus alert: Library hours extended tonight!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showMultiUniversityDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Multi-University Mode'),
        content: const Text('This feature will allow accessing data from multiple institutions. Team will implement this after data aggregation is complete.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About Smart Campus'),
        content: const Text('Developed for Starthon\'25 by Team NeuroNauts\n\nUniversity of El Oued\nApril 2025'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadDummyData();
  }

  // Load some initial dummy data if box is empty
  Future<void> _loadDummyData() async {
    final box = Hive.box<UpdateItem>('updates');
    if (box.isEmpty) {
      await box.add(UpdateItem(
        title: 'New Library Resources',
        description: 'The library has added 50 new digital resources for CS students.',
        category: 'Academic',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ));
      await box.add(UpdateItem(
        title: 'Campus Wi-Fi Maintenance',
        description: 'Wi-Fi will be down for maintenance on Friday, 7-9 PM.',
        category: 'Facilities',
        date: DateTime.now(),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        // Simulated refresh - in a real app, this would fetch new data
        await Future.delayed(const Duration(seconds: 1));
        setState(() {});
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Stats Section
            _buildSectionTitle('Quick Stats'),
            _buildStatsRow(),

            // AI Insights Section
            _buildSectionTitle('AI Insights'),
            _buildAIPredictions(),

            // Latest Updates Section (from Hive)
            _buildSectionTitle('Latest Updates'),
            _buildUpdatesList(),

            // Data Visualization Placeholder
            _buildSectionTitle('Course Trends'),
            _buildChartPlaceholder(),

            // Sentiment Analysis Section
            _buildSectionTitle('Student Feedback'),
            _buildSentimentAnalysis(),

            // Add some padding at the bottom for better scrolling experience
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
      child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildStatsRow() {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dummyStats.length,
        itemBuilder: (context, index) => StatCard(item: dummyStats[index]),
      ),
    );
  }

  Widget _buildAIPredictions() {
    return Column(children: dummyPredictions.map((p) => AIPredictionCard(prediction: p)).toList());
  }

  Widget _buildUpdatesList() {
    return ValueListenableBuilder<Box<UpdateItem>>(
      valueListenable: Hive.box<UpdateItem>('updates').listenable(),
      builder: (context, box, _) {
        final updates = box.values.toList();
        if (updates.isEmpty) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text('No updates available. Pull down to refresh.'),
              ),
            ),
          );
        }
        return Column(children: updates.map((u) => UpdateCard(update: u)).toList());
      },
    );
  }

  // Update the _buildChartPlaceholder() method in DashboardScreen
  Widget _buildChartPlaceholder() {
    // Sample data for the chart
    final courseData = {
      'CS101': [65.0, 70.0, 80.0, 85.0],
      'MATH202': [70.0, 65.0, 60.0, 65.0],
      'PHY301': [45.0, 40.0, 42.0, 40.0],
    };

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Course Enrollment Trends', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          EnrollmentChart(courseData: courseData),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Refresh Data'),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Refreshing chart data...'))
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSentimentAnalysis() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.sentiment_satisfied_alt, color: Colors.green),
                SizedBox(width: 8),
                Text('Overall Student Sentiment', style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: 0.82,
              backgroundColor: Colors.grey[200],
              color: Colors.green,
              minHeight: 10,
              semanticsLabel: 'Positive sentiment',
            ),
            const SizedBox(height: 8),
            const Text('82% positive feedback from recent surveys'),
            const SizedBox(height: 16),
            const Text('Top positive topics:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            _buildSentimentTopic('Course content quality', 0.88),
            _buildSentimentTopic('Campus facilities', 0.79),
            _buildSentimentTopic('Faculty responsiveness', 0.76),
          ],
        ),
      ),
    );
  }

  Widget _buildSentimentTopic(String topic, double sentiment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: Text('• $topic')),
          Text('${(sentiment * 100).toInt()}%',
            style: TextStyle(
                color: sentiment > 0.8 ? Colors.green : Colors.amber,
                fontWeight: FontWeight.w500
            ),
          ),
        ],
      ),
    );
  }
}

// Core Widget Components
class StatCard extends StatelessWidget {
  final StatItem item;
  const StatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 5),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(item.icon, color: Colors.blue, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
              Text('${item.value}${item.unit}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class UpdateCard extends StatelessWidget {
  final UpdateItem update;
  const UpdateCard({super.key, required this.update});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(update.category, style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold)),
                Text(update.formattedDate, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Text(update.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(update.description),
          ],
        ),
      ),
    );
  }
}

class AIPredictionCard extends StatelessWidget {
  final AIPrediction prediction;
  const AIPredictionCard({super.key, required this.prediction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.blue[50],
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
                children: [
                  const Icon(Icons.insights, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text('AI Insight', style: TextStyle(color: Colors.blue[800], fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      prediction.formattedConfidence,
                      style: TextStyle(fontSize: 12, color: Colors.blue[800]),
                    ),
                  )
                ]
            ),
            const SizedBox(height: 8),
            Text(prediction.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(prediction.prediction),
          ],
        ),
      ),
    );
  }
}

// Screen Placeholders
class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Available Courses', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildCourseCard(
            'CS101',
            'Introduction to Computer Science',
            'Dr. Ahmed Hassan',
            '80% full'
        ),
        _buildCourseCard(
            'MATH202',
            'Linear Algebra',
            'Dr. Sarah Johnson',
            '65% full'
        ),
        _buildCourseCard(
            'PHY301',
            'Advanced Physics',
            'Prof. Mohamed Rashid',
            '40% full'
        ),
        const SizedBox(height: 32),
        const Center(
          child: Text('More courses will be added by the team'),
        ),
      ],
    );
  }

  Widget _buildCourseCard(String code, String title, String instructor, String enrollment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(code, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                Text(enrollment, style: const TextStyle(fontSize: 14)),
              ],
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text('Instructor: $instructor'),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('Details'),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 16),
                  label: const Text('Schedule'),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('Upcoming Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildEventCard(
            'Career Workshop',
            'April 15, 2025 • 2:00 PM',
            'Main Auditorium',
            'Learn how to prepare for job interviews and build your resume.',
            Colors.orange
        ),
        _buildEventCard(
            'Tech Symposium',
            'April 20, 2025 • 10:00 AM',
            'CS Building, Room 305',
            'Local tech companies will present their latest innovations.',
            Colors.blue
        ),
        _buildEventCard(
            'Student Art Exhibition',
            'April 25, 2025 • 5:30 PM',
            'University Gallery',
            'Showcase of student artwork from various departments.',
            Colors.purple
        ),
        const SizedBox(height: 32),
        const Center(
          child: Text('More events will be added by the team'),
        ),
      ],
    );
  }

  Widget _buildEventCard(String title, String date, String location, String description, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(date, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(location, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 16),
                Text(description),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: const Text('Add to Calendar'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: color,
                      ),
                      child: const Text('Register'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              title.contains('Calendar') ? Icons.calendar_today : Icons.library_books,
              size: 64,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const Text('This feature will be implemented by the team'),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen
// Update SettingsScreen to include sync interval management
class SettingsScreen extends StatefulWidget {
  final SyncService syncService;

  const SettingsScreen({super.key, required this.syncService});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _multiUniversity = false;
  bool _notifications = true;
  bool _darkMode = false;
  String _dataRefreshInterval = '6 hours';
  bool _autoSync = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('App Settings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          SwitchListTile(
            title: const Text('Dark Mode'),
            subtitle: const Text('Enable dark theme for the app'),
            secondary: const Icon(Icons.dark_mode),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          SwitchListTile(
            title: const Text('Enable Notifications'),
            subtitle: const Text('Receive updates and alerts'),
            secondary: const Icon(Icons.notifications),
            value: _notifications,
            onChanged: (value) => setState(() => _notifications = value),
          ),
          SwitchListTile(
            title: const Text('Multi-University Support'),
            subtitle: const Text('Connect with other universities'),
            secondary: const Icon(Icons.business),
            value: _multiUniversity,
            onChanged: (value) => setState(() => _multiUniversity = value),
          ),
          const Divider(),
          const Text('Data Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Auto Sync'),
            subtitle: const Text('Automatically fetch new data'),
            secondary: const Icon(Icons.sync),
            value: _autoSync,
            onChanged: (value) {
              setState(() {
                _autoSync = value;
              });
              if (value) {
                widget.syncService.startPeriodicSync(
                  intervalHours: int.parse(_dataRefreshInterval.split(' ')[0]),
                );
              } else {
                widget.syncService.stopSync();
              }
            },
          ),
          ListTile(
            title: const Text('Data Refresh Interval'),
            subtitle: Text(_dataRefreshInterval),
            leading: const Icon(Icons.timer),
            onTap: () => _showIntervalDialog(context),
            enabled: _autoSync,
          ),
          ListTile(
            title: const Text('Clear Cache'),
            subtitle: const Text('Remove all locally stored data'),
            leading: const Icon(Icons.delete),
            onTap: () => _clearCache(context),
          ),
          const Divider(),
          ListTile(
            title: const Text('About Smart Campus'),
            subtitle: const Text('Version 1.0'),
            leading: const Icon(Icons.info),
            onTap: () => _showAboutDialog(context),
          ),
          ListTile(
            title: const Text('Help & Support'),
            subtitle: const Text('Contact the development team'),
            leading: const Icon(Icons.help),
            onTap: () => _showHelpDialog(context),
          ),
          const SizedBox(height: 32),
          Center(
            child: TextButton(
              onPressed: () {
                // In a real app, this would log the user out
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Logout functionality will be implemented by the team')),
                );
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }

  void _clearCache(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache?'),
        content: const Text('This will remove all locally stored data.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Hive.box<UpdateItem>('updates').clear();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')));
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _showIntervalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Select Refresh Interval'),
        children: [
          _buildIntervalOption(context, '1 hour'),
          _buildIntervalOption(context, '3 hours'),
          _buildIntervalOption(context, '6 hours'),
          _buildIntervalOption(context, '12 hours'),
          _buildIntervalOption(context, '24 hours'),
        ],
      ),
    );
  }

  Widget _buildIntervalOption(BuildContext context, String interval) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => _dataRefreshInterval = interval);
        // Update sync service with new interval
        if (_autoSync) {
          widget.syncService.updateSyncInterval(int.parse(interval.split(' ')[0]));
        }
        Navigator.pop(context);
      },
      child: Text(interval,
          style: TextStyle(
            fontWeight: _dataRefreshInterval == interval ? FontWeight.bold : FontWeight.normal,
            color: _dataRefreshInterval == interval ? Colors.blue : null,
          )
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('About'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Smart Campus Insights v1.0'),
            SizedBox(height: 16),
            Text('Developed for Starthon\'25'),
            Text('University of El Oued'),
            SizedBox(height: 16),
            Text('A comprehensive campus management solution with AI-powered insights and analytics.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Help dialog method that was cut off
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Help & Support'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For assistance, contact:'),
            SizedBox(height: 8),
            Text('Email: support@smartcampus.edu'),
            Text('Phone: +213 00 000 0000'),
            SizedBox(height: 16),
            Text('Documentation and FAQs available at:'),
            Text('www.smartcampus.edu/help'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Redirecting to support portal...')),
              );
            },
            child: const Text('Visit Help Center'),
          ),
        ],
      ),
    );
  }
}
