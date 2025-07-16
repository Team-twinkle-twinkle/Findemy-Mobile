import 'package:findemy_mobile/models/academy_model.dart';

class AllAcademyModel {
  List<Academy> academies;

  AllAcademyModel({required this.academies});

  // List<dynamic>에서 직접 생성하는 팩토리 생성자
  factory AllAcademyModel.fromList(List<dynamic> list) {
    return AllAcademyModel(
      academies: list.map((item) => Academy.fromJson(item as Map<String, dynamic>)).toList(),
    );
  }

  // 기존 Map에서 생성하는 팩토리 생성자 (호환성을 위해 유지)
  factory AllAcademyModel.fromJson(Map<String, dynamic> json) {
    return AllAcademyModel(
      academies: json['academies'] != null
          ? (json['academies'] as List).map((item) => Academy.fromJson(item as Map<String, dynamic>)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'academies': academies.map((e) => e.toJson()).toList(),
    };
  }
}