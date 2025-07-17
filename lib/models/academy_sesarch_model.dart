import 'package:findemy_mobile/models/academy_model.dart';

class AcademySearchModel {
  final Academy academy;

  AcademySearchModel({required this.academy});

  factory AcademySearchModel.fromJson(Map<String, dynamic> json) {
    return AcademySearchModel(
      academy: Academy.fromJson(json),
    );
  }
}
