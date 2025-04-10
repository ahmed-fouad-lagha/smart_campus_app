class University {
  final String name;
  final String baseUrl;
  final String courseUrl;
  final String eventsUrl;
  final String newsUrl;

  // Selectors for courses
  final String courseSelector;
  final String courseCodeSelector;
  final String courseNameSelector;
  final String instructorSelector;
  final String scheduleSelector;

  // Selectors for events
  final String eventSelector;
  final String eventTitleSelector;
  final String eventDateSelector;
  final String eventLocationSelector;
  final String eventDescriptionSelector;

  // Selectors for news
  final String newsSelector;
  final String newsTitleSelector;
  final String newsDateSelector;
  final String newsSummarySelector;
  final String newsImageSelector;

  University({
    required this.name,
    required this.baseUrl,
    required this.courseUrl,
    required this.eventsUrl,
    required this.newsUrl,
    required this.courseSelector,
    required this.courseCodeSelector,
    required this.courseNameSelector,
    required this.instructorSelector,
    required this.scheduleSelector,
    required this.eventSelector,
    required this.eventTitleSelector,
    required this.eventDateSelector,
    required this.eventLocationSelector,
    required this.eventDescriptionSelector,
    required this.newsSelector,
    required this.newsTitleSelector,
    required this.newsDateSelector,
    required this.newsSummarySelector,
    required this.newsImageSelector,
  });
}

class CourseData {
  final String code;
  final String name;
  final String instructor;
  final String schedule;
  final String university;

  CourseData({
    required this.code,
    required this.name,
    required this.instructor,
    required this.schedule,
    required this.university,
  });

  Map<String, dynamic> toJson() => {
    'code': code,
    'name': name,
    'instructor': instructor,
    'schedule': schedule,
    'university': university,
  };

  factory CourseData.fromJson(Map<String, dynamic> json) => CourseData(
    code: json['code'] ?? '',
    name: json['name'] ?? '',
    instructor: json['instructor'] ?? '',
    schedule: json['schedule'] ?? '',
    university: json['university'] ?? '',
  );
}

class EventData {
  final String title;
  final String date;
  final String location;
  final String description;
  final String university;

  EventData({
    required this.title,
    required this.date,
    required this.location,
    required this.description,
    required this.university,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'location': location,
    'description': description,
    'university': university,
  };

  factory EventData.fromJson(Map<String, dynamic> json) => EventData(
    title: json['title'] ?? '',
    date: json['date'] ?? '',
    location: json['location'] ?? '',
    description: json['description'] ?? '',
    university: json['university'] ?? '',
  );
}

class NewsData {
  final String title;
  final String date;
  final String summary;
  final String imageUrl;
  final String university;

  NewsData({
    required this.title,
    required this.date,
    required this.summary,
    required this.imageUrl,
    required this.university,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'date': date,
    'summary': summary,
    'imageUrl': imageUrl,
    'university': university,
  };

  factory NewsData.fromJson(Map<String, dynamic> json) => NewsData(
    title: json['title'] ?? '',
    date: json['date'] ?? '',
    summary: json['summary'] ?? '',
    imageUrl: json['imageUrl'] ?? '',
    university: json['university'] ?? '',
  );
}
