import 'package:dio/dio.dart';
import 'package:findemy_mobile/models/academy_detail_model.dart';
import 'package:findemy_mobile/models/all_academy_model.dart';
import 'package:findemy_mobile/models/login_model.dart';
import 'package:findemy_mobile/models/user_model.dart';
import 'package:findemy_mobile/network/dio_client.dart'; // DioClient import

class ApiServices {
  // 싱글턴 Dio 인스턴스 사용
  static Dio get dio => DioClient().dio;

  static void setAuthorizationToken(String? token) {
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token'; // Bearer 추가
      print('Authorization header set: Bearer $token');
    } else {
      dio.options.headers.remove('Authorization');
      print('Authorization header removed.');
    }
  }

  static Future<LoginModel> loginUser(UserModel user) async {
    try {
      final response = await dio.post(
        '/user/login',
        data: user.toJson(), // data 파라미터 명시적 지정
      );
      return LoginModel.fromJson(response.data);
    } catch (err) {
      throw Exception('로그인 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<int> signupUser(UserModel user) async {
    try {
      final response = await dio.post(
        '/user/signup', // 회원가입 엔드포인트 수정 (login -> signup)
        data: user.toJson(), // data 파라미터 명시적 지정
      );
      return response.statusCode!;
    } catch (err) {
      throw Exception('회원가입 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<AllAcademyModel> allAcademies() async {
    try {
      print('현재 헤더: ${dio.options.headers}');

      final response = await dio.get('/academy/all');

      print('[응답 상태 코드]: ${response.statusCode}');
      print('[응답 statusMessage]: ${response.statusMessage}');
      print('[응답 데이터]: ${response.data}');
      print('[응답 데이터 타입]: ${response.data.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 응답 데이터가 null인 경우 빈 리스트로 처리
        if (response.data == null) {
          print('[응답 데이터가 null입니다. 빈 리스트로 처리합니다.]');
          return AllAcademyModel(academies: []);
        }

        // 서버 응답 데이터 타입에 따라 처리
        if (response.data is List) {
          // List로 반환되는 경우: 직접 fromList 사용
          return AllAcademyModel.fromList(response.data);
        } else if (response.data is Map<String, dynamic>) {
          // Map으로 반환되는 경우: fromJson 사용
          return AllAcademyModel.fromJson(response.data);
        } else {
          print('[예상하지 못한 응답 데이터 타입]: ${response.data.runtimeType}');
          print('[응답 데이터 내용]: ${response.data}');
          throw Exception('예상하지 못한 응답 데이터 타입: ${response.data.runtimeType}');
        }
      } else {
        throw Exception('API 오류: ${response.statusCode} / ${response.statusMessage} / ${response.data}');
      }
    } catch (err) {
      print('[학원 전체 조회 오류]: $err');
      if (err is DioException) {
        print('[DioException 상태 코드]: ${err.response?.statusCode}');
        print('[DioException 응답 데이터]: ${err.response?.data}');
        print('[DioException 응답 데이터 타입]: ${err.response?.data.runtimeType}');
      }
      throw Exception('모든 학원 정보 불러오기 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<AcademyDetailModel> detailAcademies(int id) async {
    try {
      print('현재 헤더: ${dio.options.headers}');
      final response = await dio.get('/academy/$id');
      return AcademyDetailModel.fromJson(response.data);
    } catch (err) {
      print('학원 상세 조회 오류: $err');
      if (err is DioException) {
        print('DioException 상태 코드: ${err.response?.statusCode}');
        print('DioException 응답 데이터: ${err.response?.data}');
      }
      throw Exception('학원 상세 정보 불러오기 중 오류 발생: ${err.toString()}');
    }
  }
}