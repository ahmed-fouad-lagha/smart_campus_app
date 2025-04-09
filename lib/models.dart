import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'models.g.dart';  // This will be generated

// Data Models
class StatItem {
  final String title;
  final String value;
  final String unit;
  final IconData icon;

  const StatItem({
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
  });
}

class AIPrediction {
  final String title;
  final String prediction;
  final double confidence;

  const AIPrediction({
    required this.title,
    required this.prediction,
    required this.confidence,
  });

  String get formattedConfidence => '${(confidence * 100).toInt()}% confidence';
}

@HiveType(typeId: 0)
class UpdateItem extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String description;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final DateTime date;

  UpdateItem({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

// Add to models.dart
@HiveType(typeId: 1)
class CourseItem extends HiveObject {
  @HiveField(0)
  final String code;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String instructor;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final int enrollmentPercentage;

  @HiveField(5)
  final List<String> schedule;

  @HiveField(6)
  final String location;

  CourseItem({
    required this.code,
    required this.title,
    required this.instructor,
    required this.description,
    required this.enrollmentPercentage,
    required this.schedule,
    required this.location,
  });
}

@HiveType(typeId: 2)
class EventItem extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String location;

  @HiveField(3)
  final String description;

  @HiveField(4)
  final String category;

  @HiveField(5)
  final int expectedAttendance;

  EventItem({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.category,
    this.expectedAttendance = 0,
  });

  String get formattedDate {
    return '${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')} ${date.hour < 12 ? 'AM' : 'PM'}';
  }
}

// Also add these model adapters to the Hive registration in main.dart