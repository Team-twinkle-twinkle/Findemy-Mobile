import 'package:dio/dio.dart';
import 'package:findemy_mobile/models/academy_detail_model.dart';
import 'package:findemy_mobile/models/all_academy_model.dart';
import 'package:findemy_mobile/models/login_model.dart';
import 'package:findemy_mobile/models/user_model.dart';

class ApiServices {
  static Dio dio = Dio();
  static const String baseUrl = 'http://3.107.243.190:8888';

  static Future<LoginModel> loginUser(UserModel user) async {
    try {
      final response = await dio.post(
        '$baseUrl/user/login',
        data: user.toJson(),
      );

      return LoginModel.fromJson(response.data);
    } catch (err) {
      throw Exception(err);
    }
  }

  static Future<int> signupUser(UserModel user) async {
    try{
      final response = await dio.post(
        '$baseUrl/user/signup',
        data: user.toJson(),
      );

      return response.statusCode!;
    } catch (err){
      throw Exception(err);
    }
  }

  static Future<AllAcademyModel> allAcademies() async {
    try {
      final response = await dio.get('$baseUrl/academy');

      return AllAcademyModel.fromJson(response.data);
    } catch (err) {
      throw Exception(err);
    }
  }

  static Future<AcademyDetailModel> detailAcademies(int id) async {
    try {
      final response = await dio.get('$baseUrl/academy/$id');

      return AcademyDetailModel.fromJson(response.data);
    } catch (err) {
      throw Exception(err);
    }
  }
}
