import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:findemy_mobile/models/academy_detail_model.dart';
import 'package:findemy_mobile/models/academy_sesarch_model.dart';
import 'package:findemy_mobile/models/all_academy_model.dart';
import 'package:findemy_mobile/models/bookmark_model.dart';
import 'package:findemy_mobile/models/login_model.dart';
import 'package:findemy_mobile/models/mypage_model.dart';
import 'package:findemy_mobile/models/user_model.dart';
import 'package:findemy_mobile/network/dio_client.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 사용을 위한 import

class ApiServices {
  // 싱글턴 Dio 인스턴스 사용
  static Dio get dio => DioClient().dio;

  static void setAuthorizationToken(String? token) {
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Authorization'] = 'Bearer $token';
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
        data: user.toJson(),
      );
      final loginModel = LoginModel.fromJson(response.data);

      // ✨ 로그인 성공 시 API 호출에 사용된 UserModel의 accountId를 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUserId', user.accountId); // UserModel에서 accountId 사용
      print('사용자 ID 저장됨: ${user.accountId}');

      return loginModel;
    } catch (err) {
      throw Exception('로그인 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<int> signupUser(UserModel user) async {
    try {
      final response = await dio.post(
        '/user/signup',
        data: user.toJson(),
      );
      // ✨ 회원가입 성공 시 API 호출에 사용된 UserModel의 accountId를 SharedPreferences에 저장
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUserId', user.accountId); // UserModel에서 accountId 사용
      print('회원가입 후 사용자 ID 저장됨: ${user.accountId}');
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

  static Future<List<AcademySearchModel>> searchAcademies(String academyName) async {
    try {
      final response = await dio.get(
        '/academy/search',
        queryParameters: {
          'academyName': academyName,
        },
      );

      print('[학원 검색 응답 코드]: ${response.statusCode}');
      print('[학원 검색 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;

        if (data is List) {
          return data
              .map((item) => AcademySearchModel.fromJson(item))
              .toList();
        } else {
          throw Exception('예상하지 못한 응답 형식입니다: ${data.runtimeType}');
        }
      } else {
        throw Exception('검색 실패: ${response.statusCode} / ${response.statusMessage}');
      }
    } catch (err) {
      print('[학원 검색 오류]: $err');
      if (err is DioException) {
        print('[DioException 응답 코드]: ${err.response?.statusCode}');
        print('[DioException 응답 데이터]: ${err.response?.data}');
      }
      throw Exception('학원 검색 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<void> postBookmarks(BookMarkModel bookmarkData, int academyId) async {
    try {
      // ✨ 찜하기 요청 직전 로그 시작
      print('--- [POST /favorite 요청 로그 시작] ---');
      print('[북마크 등록 요청 데이터]: ${bookmarkData.toJson()}'); // bookmarkData의 toJson() 사용
      print('[북마크 등록 요청 헤더]: ${dio.options.headers}');
      // Request body is explicitly logged here
      print('[북마크 등록 요청 Body]: ${bookmarkData.toJson()}'); // Already present and logs the body
      print('--- [POST /favorite 요청 로그 종료] ---');
      // ✨ 찜하기 요청 직전 로그 종료

      final response = await dio.post(
          '/favorite',
          data: jsonEncode([1]), // List<int>를 직접 data로 보냄
          queryParameters: {'academyId' : academyId},
          options: Options(
              headers: {'Authorization' : 'Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJxd2VyYXNkZnp4IiwidHlwZSI6ImFjY2VzcyIsInVzZXIiOiJ2Ym5tdmZnaGpramhnIiwiaWF0IjoxNzUyNzEzMDIxLCJleHAiOjE3NTI5ODQwMjF9.KFUvFei9eA_ZoCTthLGHj7hTgxQkyMmgAwqDFRmzgyk'}
          )
      );
      // ... (기존 응답 처리 및 오류 처리 로직)
    }catch (err) {
      print('[북마크 등록 오류]: $err');
      if (err is DioException) {
        print('[DioException 상태 코드]: ${err.response?.statusCode}');
        print('[DioException 응답 데이터]: ${err.response?.data}');
      }
      throw Exception('북마크 등록 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<MyPageModel> mypageData() async {
    try {
      // ✨ 마이페이지 조회 요청 직전 로그 시작
      print('--- [GET /favorite 요청 로그 시작] ---');
      print('[마이페이지 조회 요청 헤더]: ${dio.options.headers}');
      print('--- [GET /favorite 요청 로그 종료] ---');
      // ✨ 마이페이지 조회 요청 직전 로그 종료

      final response = await dio.get('/favorite');

      print('[마이페이지 조회 응답 상태 코드]: ${response.statusCode}');
      print('[마이페이지 조회 응답 데이터]: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data is Map<String, dynamic>) {
          final myPageModel = MyPageModel.fromJson(response.data);
          print('[마이페이지 파싱 성공] 찜 목록 개수: ${myPageModel.favorites.length}');
          return myPageModel;
        } else {
          throw Exception('예상하지 못한 마이페이지 응답 데이터 타입: ${response.data.runtimeType}');
        }
      } else {
        throw Exception('마이페이지 조회 실패: ${response.statusCode} / ${response.statusMessage} / ${response.data}');
      }
    } catch (err) {
      print('[마이페이지 조회 오류]: $err');
      if (err is DioException) {
        print('[DioException 상태 코드]: ${err.response?.statusCode}');
        print('[DioException 응답 데이터]: ${err.response?.data}');
      }
      throw Exception('마이페이지 정보 불러오기 중 오류 발생: ${err.toString()}');
    }
  }

  static Future<void> deleteFavorite(int academyId) async {
    try {
      final response = await dio.delete(
        '/favorite',
        queryParameters: {'academyId' : academyId},
      );
      if (response.statusCode != 200 && response.statusCode != 204) { // 200 OK or 204 No Content for successful delete
        throw Exception('찜 취소 실패: ${response.statusCode}');
      }
      print('찜 취소 성공: 학원 ID $academyId');
    } catch (err) {
      print('[찜 취소 오류]: $err');
      if (err is DioException) {
        print('[DioException 상태 코드]: ${err.response?.statusCode}');
        print('[DioException 응답 데이터]: ${err.response?.data}');
      }
      throw Exception('찜 취소 중 오류 발생: ${err.toString()}');
    }
  }
}