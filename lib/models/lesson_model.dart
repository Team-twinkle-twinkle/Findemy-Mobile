class Lesson {
  final String subject;
  final String grade;
  final String frequency;
  final String price;

  Lesson({
    required this.subject,
    required this.grade,
    required this.frequency,
    required this.price,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      subject: json['subject'],
      grade: json['grade'],
      frequency: json['frequency'],
      price: json['price'],
    );
  }
}