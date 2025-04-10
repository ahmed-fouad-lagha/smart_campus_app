import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../services/api_service.dart';
import '../models/event.dart';
import '../utils/date_formatter.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({Key? key}) : super(key: key);

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  List<Event> _events = [];
  String? _errorMessage;

  // Mock popularity data
  final Map<String, int> _eventPopularity = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final events = await _apiService.fetchEvents();

      // Generate mock popularity data
      final popularity = <String, int>{};
      for (final event in events) {
        // Random popularity between 10 and 100
        popularity[event.id] = 10 + (90 * (event.hashCode % 100) / 100).round();
      }

      setState(() {
        _events = events;
        _eventPopularity.addAll(popularity);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load events. Please try again.';
        _isLoading = false;
      });
      print('Error loading events: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Events'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadEvents,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _errorMessage != null
            ? Center(child: Text(_errorMessage!))
            : _events.isEmpty
            ? const Center(child: Text('No events available'))
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final event = _events[index];
            final popularity = _eventPopularity[event.id] ?? 0;
            return _buildEventCard(event, popularity);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add event screen
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildEventCard(Event event, int popularity) {
    final isUpcoming = event.date.isAfter(DateTime.now());

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event image or placeholder
          Container(
            height: 150,
            width: double.infinity,
            color: Colors.blue.shade100,
            child: Center(
              child: Icon(
                Icons.event,
                size: 50,
                color: Colors.blue.shade800,
              ),
            ),
          ),

          // Event details
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (isUpcoming)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Upcoming',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormatter.formatLongDate(event.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.location,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.people,
                      size: 16,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      event.organizer,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  event.description,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),

                // Popularity indicator
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Popularity:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$popularity%',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: _getPopularityColor(popularity),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearPercentIndicator(
                      lineHeight: 8,
                      percent: popularity / 100,
                      backgroundColor: Colors.grey[200],
                      progressColor: _getPopularityColor(popularity),
                      barRadius: const Radius.circular(4),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Actions
          ButtonBar(
            alignment: MainAxisAlignment.end,
            children: [
              if (isUpcoming)
                TextButton.icon(
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('RSVP'),
                  onPressed: () {
                    // RSVP to event
                  },
                ),
              TextButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Share'),
                onPressed: () {
                  // Share event
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPopularityColor(int popularity) {
    if (popularity >= 80) {
      return Colors.purple;
    } else if (popularity >= 60) {
      return Colors.blue;
    } else if (popularity >= 40) {
      return Colors.green;
    } else if (popularity >= 20) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
