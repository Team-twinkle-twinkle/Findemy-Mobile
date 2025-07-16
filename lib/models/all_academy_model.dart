import 'package:findemy_mobile/models/academy_model.dart';

class AllAcademyModel {
  List<AcademyModel>? academies;

  AllAcademyModel({this.academies});
  factory AllAcademyModel.fromJson(Map<String, dynamic> json) {
    var academiesList = json['academies'] as List?;
    List<AcademyModel>? parsedAcademies;

    if (academiesList != null) {
      parsedAcademies = academiesList
          .map((i) => AcademyModel.fromJson(i as Map<String, dynamic>))
          .toList();
    }

    return AllAcademyModel(
      academies: parsedAcademies,
    );
  }
}