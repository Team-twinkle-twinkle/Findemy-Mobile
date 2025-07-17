import 'package:dio/dio.dart';

class DioClient {
  // 싱글턴 인스턴스 생성
  static final DioClient _instance = DioClient._internal();

  // 직접 사용할 Dio 인스턴스
  late final Dio dio;

  // 비공개 생성자
  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://3.107.243.190:8888',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    // ✨ LogInterceptor의 모든 로깅 옵션을 true로 설정 (최대 로깅) ✨
    dio.interceptors.add(LogInterceptor(
      request: true,        // 요청 정보 로깅 (메서드, URI 등)
      requestHeader: true,  // 요청 헤더 로깅 (Authorization 등)
      requestBody: true,    // 요청 본문 로깅
      responseHeader: true, // 응답 헤더 로깅
      responseBody: true,   // 응답 본문 로깅
      error: true,          // 에러 정보 로깅
    ));
  }

  // 외부에서 접근할 때 factory 생성자로 항상 같은 인스턴스 반환
  factory DioClient() => _instance;
}