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

    // Optional: 요청/응답 로그 출력 기능 (디버깅 시 유용)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // 외부에서 접근할 때 factory 생성자로 항상 같은 인스턴스 반환
  factory DioClient() => _instance;
}
