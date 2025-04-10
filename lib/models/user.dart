class User {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String role; // student, faculty, staff
  final String department;
  final List<String> enrolledCourses;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    required this.role,
    required this.department,
    required this.enrolledCourses,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profileImageUrl'],
      role: json['role'],
      department: json['department'],
      enrolledCourses: List<String>.from(json['enrolledCourses']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'role': role,
      'department': department,
      'enrolledCourses': enrolledCourses,
    };
  }
}