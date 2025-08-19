
class Student {
  final String id;
  final String name;
  final String gender;
  String programme;
  final int year;

  Student({
    required this.id,
    required this.name,
    required this.gender,
    required this.programme,
    required this.year,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      name: json['name'],
      gender: json['gender'],
      programme: json['programme'],
      year: json['yearofStudy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'programme': programme,
      'yearofStudy': year,
    };
  }
}