import 'subject_enum.dart';

class AcademyModel {
  int? academyId;
  String? academyName;
  String? academyImgUrl;
  String? address;
  List<SubjectEnum>? subjects;

  AcademyModel({
    this.academyId,
    this.academyName,
    this.academyImgUrl,
    this.address,
    this.subjects,
  });

  factory AcademyModel.fromJson(Map<String, dynamic> json) {
    return AcademyModel(
      academyId: json['academy_id'] as int?,
      academyName: json['academy_name'] as String?,
      academyImgUrl: json['academy_img_url'] as String?,
      address: json['address'] as String?,
      subjects: (json['subjects'] as List<dynamic>?)
          ?.map((subject) => SubjectEnumExtension.fromString(subject as String))
          .toList(),
    );
  }
}