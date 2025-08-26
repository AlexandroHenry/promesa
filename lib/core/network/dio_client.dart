import 'package:dio/dio.dart';
import '../config/app_config.dart';
import '../utils/logger.dart';

class DioClient {
  late final Dio _dio;

  DioClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: Duration(milliseconds: AppConfig.connectTimeout),
        receiveTimeout: Duration(milliseconds: AppConfig.receiveTimeout),
        sendTimeout: Duration(milliseconds: AppConfig.connectTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // 로깅 인터셉터 (환경별 설정)
    if (AppConfig.enableLogging) {
      _dio.interceptors.add(
        LogInterceptor(
          requestBody: true,
          responseBody: true,
          requestHeader: true,
          responseHeader: false,
          error: true,
          logPrint: (obj) => Logger.d(obj.toString(), 'DioClient'),
        ),
      );
    }

    // 커스텀 인터셉터
    _dio.interceptors.add(_CustomInterceptor());

    // Auth Interceptor 추가 가능
    // _dio.interceptors.add(AuthInterceptor());
  }

  Dio get dio => _dio;

  // Token 설정
  void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
    Logger.d('Auth token set', 'DioClient');
  }

  // Token 제거
  void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
    Logger.d('Auth token cleared', 'DioClient');
  }
}

// 커스텀 인터셉터
class _CustomInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 환경 정보를 헤더에 추가
    options.headers['X-Environment'] = AppConfig.environment.name;
    
    // Mock 환경인 경우 실제 요청을 막음
    if (AppConfig.useMockData) {
      Logger.w('Mock mode: Blocking real API request to ${options.uri}', 'DioClient');
      // Mock 환경에서는 실제 API 호출 차단
      // 실제로는 MockDataSource를 사용해야 함
      handler.reject(
        DioException(
          requestOptions: options,
          message: 'Mock mode: Real API calls are disabled',
          type: DioExceptionType.cancel,
        ),
      );
      return;
    }

    Logger.d('🚀 ${options.method} ${options.uri}', 'DioClient');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    Logger.d('✅ ${response.statusCode} ${response.requestOptions.uri}', 'DioClient');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    Logger.e(
      '❌ ${err.response?.statusCode ?? 'NO_STATUS'} ${err.requestOptions.uri}', 
      'DioClient',
      err,
    );
    handler.next(err);
  }
}
