import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../models/announcement.dart';
import '../models/event.dart';
import '../models/course.dart';

class ApiService {
  // Base URL for API calls
  // In a real app, this would be your actual API endpoint
  final String _baseUrl = 'https://api.example.com';
  
  // Fetch announcements
  Future<List<Announcement>> fetchAnnouncements() async {
    // In a real app, this would make an actual API call
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock announcements
    return [
      Announcement(
        id: '1',
        title: 'Campus Closure',
        content: 'The campus will be closed on Monday, July 4th for Independence Day.',
        date: DateTime.now().subtract(const Duration(days: 1)),
        priority: 'High',
      ),
      Announcement(
        id: '2',
        title: 'New Library Hours',
        content: 'The library will now be open 24/7 during finals week.',
        date: DateTime.now().subtract(const Duration(days: 2)),
        priority: 'Medium',
      ),
      Announcement(
        id: '3',
        title: 'Scholarship Deadline',
        content: 'The deadline for scholarship applications is June 15th.',
        date: DateTime.now().subtract(const Duration(days: 3)),
        priority: 'High',
      ),
      Announcement(
        id: '4',
        title: 'Campus Wi-Fi Upgrade',
        content: 'The campus Wi-Fi will be upgraded this weekend. Expect intermittent connectivity.',
        date: DateTime.now().subtract(const Duration(days: 4)),
        priority: 'Medium',
      ),
    ];
  }
  
  // Fetch events
  Future<List<Event>> fetchEvents() async {
    // In a real app, this would make an actual API call
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock events
    return [
      Event(
        id: '1',
        title: 'Career Fair',
        description: 'Annual career fair with over 50 companies.',
        date: DateTime.now().add(const Duration(days: 7)),
        location: 'Student Center',
        organizer: 'Career Services',
      ),
      Event(
        id: '2',
        title: 'Hackathon',
        description: '24-hour coding competition with prizes.',
        date: DateTime.now().add(const Duration(days: 14)),
        location: 'Engineering Building',
        organizer: 'Computer Science Department',
      ),
      Event(
        id: '3',
        title: 'Guest Lecture: AI Ethics',
        description: 'A discussion on the ethical implications of artificial intelligence.',
        date: DateTime.now().add(const Duration(days: 3)),
        location: 'Auditorium A',
        organizer: 'Philosophy Department',
      ),
      Event(
        id: '4',
        title: 'Student Government Elections',
        description: 'Vote for your student representatives.',
        date: DateTime.now().add(const Duration(days: 10)),
        location: 'Campus-wide',
        organizer: 'Student Government',
      ),
    ];
  }
  
  // Fetch courses
  Future<List<Course>> fetchCourses() async {
    // In a real app, this would make an actual API call
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Generate mock courses
    return [
      Course(
        id: '1',
        code: 'CS101',
        name: 'Introduction to Computer Science',
        instructor: 'Dr. Smith',
        schedule: 'MWF 10:00 AM - 11:30 AM',
        location: 'Science Building 101',
        credits: 3,
      ),
      Course(
        id: '2',
        code: 'MATH201',
        name: 'Calculus II',
        instructor: 'Dr. Johnson',
        schedule: 'TR 1:00 PM - 2:30 PM',
        location: 'Math Building 305',
        credits: 4,
      ),
      Course(
        id: '3',
        code: 'ENG150',
        name: 'Academic Writing',
        instructor: 'Prof. Williams',
        schedule: 'MWF 2:00 PM - 3:00 PM',
        location: 'Humanities 210',
        credits: 3,
      ),
      Course(
        id: '4',
        code: 'PHYS220',
        name: 'Physics for Engineers',
        instructor: 'Dr. Brown',
        schedule: 'TR 9:00 AM - 10:30 AM',
        location: 'Science Building 305',
        credits: 4,
      ),
    ];
  }
  
  // Fetch course details
  Future<Course> fetchCourseDetails(String courseId) async {
    // In a real app, this would make an actual API call
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Return a mock course with more details
    return Course(
      id: courseId,
      code: 'CS101',
      name: 'Introduction to Computer Science',
      instructor: 'Dr. Smith',
      schedule: 'MWF 10:00 AM - 11:30 AM',
      location: 'Science Building 101',
      credits: 3,
      description: 'An introduction to the fundamental concepts of computer science. Topics include algorithms, data structures, programming languages, and software engineering.',
      prerequisites: ['None'],
      syllabus: 'https://example.com/syllabus/cs101',
    );
  }
  
  // Fetch user profile
  Future<Map<String, dynamic>> fetchUserProfile(String userId) async {
    // In a real app, this would make an actual API call
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 1));
    
    // Return mock user profile data
    return {
      'id': userId,
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'major': 'Computer Science',
      'year': 'Junior',
      'gpa': 3.8,
      'credits_completed': 75,
      'advisor': 'Dr. Smith',
    };
  }
  
  // Web scraping method (simulated)
  Future<String> scrapeWebContent(String url) async {
    // In a real app, this would use a web scraping library
    // For demo purposes, we'll simulate a network delay and return mock data
    await Future.delayed(const Duration(seconds: 2));
    
    // Return mock scraped content
    return 'This is simulated scraped content from $url. In a real implementation, this would contain actual HTML or parsed data from the target website.';
  }
}
