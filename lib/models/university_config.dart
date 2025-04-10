class UniversityConfig {
  final String name;
  final String courseUrl;
  final String eventsUrl;
  final String courseSelector;
  final String courseCodeSelector;
  final String courseNameSelector;
  final String instructorSelector;
  final String scheduleSelector;
  final String locationSelector;
  final String eventSelector;
  final String eventTitleSelector;
  final String eventDateSelector;
  final String eventLocationSelector;
  final String eventDescriptionSelector;
  final String eventOrganizerSelector;

  UniversityConfig({
    required this.name,
    required this.courseUrl,
    required this.eventsUrl,
    required this.courseSelector,
    required this.courseCodeSelector,
    required this.courseNameSelector,
    required this.instructorSelector,
    required this.scheduleSelector,
    required this.locationSelector,
    required this.eventSelector,
    required this.eventTitleSelector,
    required this.eventDateSelector,
    required this.eventLocationSelector,
    required this.eventDescriptionSelector,
    required this.eventOrganizerSelector,
  });

  // For serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'courseUrl': courseUrl,
      'eventsUrl': eventsUrl,
      'courseSelector': courseSelector,
      'courseCodeSelector': courseCodeSelector,
      'courseNameSelector': courseNameSelector,
      'instructorSelector': instructorSelector,
      'scheduleSelector': scheduleSelector,
      'locationSelector': locationSelector,
      'eventSelector': eventSelector,
      'eventTitleSelector': eventTitleSelector,
      'eventDateSelector': eventDateSelector,
      'eventLocationSelector': eventLocationSelector,
      'eventDescriptionSelector': eventDescriptionSelector,
      'eventOrganizerSelector': eventOrganizerSelector,
    };
  }

  // For deserialization
  factory UniversityConfig.fromJson(Map<String, dynamic> json) {
    return UniversityConfig(
      name: json['name'] ?? '',
      courseUrl: json['courseUrl'] ?? '',
      eventsUrl: json['eventsUrl'] ?? '',
      courseSelector: json['courseSelector'] ?? '',
      courseCodeSelector: json['courseCodeSelector'] ?? '',
      courseNameSelector: json['courseNameSelector'] ?? '',
      instructorSelector: json['instructorSelector'] ?? '',
      scheduleSelector: json['scheduleSelector'] ?? '',
      locationSelector: json['locationSelector'] ?? '',
      eventSelector: json['eventSelector'] ?? '',
      eventTitleSelector: json['eventTitleSelector'] ?? '',
      eventDateSelector: json['eventDateSelector'] ?? '',
      eventLocationSelector: json['eventLocationSelector'] ?? '',
      eventDescriptionSelector: json['eventDescriptionSelector'] ?? '',
      eventOrganizerSelector: json['eventOrganizerSelector'] ?? '',
    );
  }
}
