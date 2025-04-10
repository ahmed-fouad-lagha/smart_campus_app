class Course {
  final String id;
  final String code;
  final String name;
  final String instructor;
  final String schedule;
  final String location;
  final int credits;
  final String? description;
  final List<String>? prerequisites;
  final String? syllabus;
  final int? matchScore;
  final String? matchReason;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.instructor,
    required this.schedule,
    required this.location,
    required this.credits,
    this.description,
    this.prerequisites,
    this.syllabus,
    this.matchScore,
    this.matchReason,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      instructor: json['instructor'],
      schedule: json['schedule'],
      location: json['location'],
      credits: json['credits'],
      description: json['description'],
      prerequisites: json['prerequisites'] != null
          ? List<String>.from(json['prerequisites'])
          : null,
      syllabus: json['syllabus'],
      matchScore: json['match_score'],
      matchReason: json['match_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'instructor': instructor,
      'schedule': schedule,
      'location': location,
      'credits': credits,
      'description': description,
      'prerequisites': prerequisites,
      'syllabus': syllabus,
      'match_score': matchScore,
      'match_reason': matchReason,
    };
  }
}
