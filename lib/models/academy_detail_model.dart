import 'package:findemy_mobile/models/lesson_model.dart';

import 'subject_enum.dart';

class AcademyDetailModel {
  int? academyId;
  String? academyName;
  String? academyImgUrl;
  String? siDo;
  String? siGunGu;
  String? introduction;
  String? address;
  String? telNumber;
  List<SubjectEnum>? subjects;
  List<LessonModel>? lessons;

  AcademyDetailModel({
    this.academyId,
    this.academyName,
    this.academyImgUrl,
    this.siDo,
    this.siGunGu,
    this.introduction,
    this.address,
    this.telNumber,
    this.subjects,
    this.lessons,
  });

  AcademyDetailModel.fromJson(Map<String, dynamic> json) {
    academyId = json['academy_id'];
    academyName = json['academy_name'];
    academyImgUrl = json['academy_img_url'];
    siDo = json['si_do'];
    siGunGu = json['si_gun_gu'];
    introduction = json['introduction'];
    address = json['address'];
    telNumber = json['tel_number'];

    subjects = (json['subjects'] as List)
        .map((subject) => SubjectEnumExtension.fromString(subject))
        .toList();
    lessons = (json['lessons'] as List)
        .map((lessonJson) => LessonModel.fromJson(lessonJson))
        .toList();
  }
}