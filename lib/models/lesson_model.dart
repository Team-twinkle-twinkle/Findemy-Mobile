import 'package:findemy_mobile/models/grade_enum.dart';
import 'package:findemy_mobile/models/number_enum.dart';
import 'package:findemy_mobile/models/subject_enum.dart';

class LessonModel {
  SubjectEnum? subject;
  GradeEnum? grade;
  NumberEnum? number;
  int? amount; // 가격

  LessonModel({
    this.subject,
    this.grade,
    this.number,
    this.amount,
  });

  LessonModel.fromJson(Map<String, dynamic> json) {
    subject = json['subject'] != null
        ? SubjectEnumExtension.fromString(json['subject'])
        : null;
    grade = json['grade'] != null
        ? GradeEnum.fromString(json['grade'])
        : null;
    number = json['number'] != null
        ? NumberEnum.fromString(json['number'])
        : null;
    amount = json['amount'];
  }

  Map<String, dynamic> toJson() {
    return {
      'subject': subject?.toString().split('.').last,
      'grade': grade?.toString().split('.').last,
      'number': number?.toString().split('.').last,
      'amount': amount,
    };
  }
}