import 'environment.dart';

class AppConfig {
  static late Environment _environment;
  static Environment get environment => _environment;

  // API 설정
  static String get baseUrl {
    switch (_environment) {
      case Environment.production:
        return 'https://api.prod.example.com';
      case Environment.staging:
        return 'https://api.stg.example.com';
      case Environment.debug:
        return 'https://api.dev.example.com';
      case Environment.mock:
        return 'https://mock.api.example.com'; // 실제로는 사용되지 않음
    }
  }

  // 타임아웃 설정
  static int get connectTimeout {
    switch (_environment) {
      case Environment.production:
        return 30000;
      case Environment.staging:
        return 30000;
      case Environment.debug:
        return 60000; // 디버그시 더 긴 타임아웃
      case Environment.mock:
        return 5000; // Mock은 빠른 응답
    }
  }

  static int get receiveTimeout {
    switch (_environment) {
      case Environment.production:
        return 30000;
      case Environment.staging:
        return 30000;
      case Environment.debug:
        return 60000;
      case Environment.mock:
        return 5000;
    }
  }

  // 로그 설정
  static bool get enableLogging {
    switch (_environment) {
      case Environment.production:
        return false;
      case Environment.staging:
        return true;
      case Environment.debug:
        return true;
      case Environment.mock:
        return true;
    }
  }

  // 에러 리포팅
  static bool get enableCrashlytics {
    switch (_environment) {
      case Environment.production:
        return true;
      case Environment.staging:
        return true;
      case Environment.debug:
        return false;
      case Environment.mock:
        return false;
    }
  }

  // Analytics
  static bool get enableAnalytics {
    switch (_environment) {
      case Environment.production:
        return true;
      case Environment.staging:
        return false;
      case Environment.debug:
        return false;
      case Environment.mock:
        return false;
    }
  }

  // 개발자 도구
  static bool get showEnvironmentBanner {
    switch (_environment) {
      case Environment.production:
        return false;
      case Environment.staging:
        return true;
      case Environment.debug:
        return true;
      case Environment.mock:
        return true;
    }
  }

  // Mock 데이터 사용 여부
  static bool get useMockData => _environment == Environment.mock;

  // 환경 설정 초기화
  static void setEnvironment(Environment env) {
    _environment = env;
  }

  // 환경 정보 출력
  static Map<String, dynamic> get environmentInfo => {
        'environment': _environment.name,
        'baseUrl': baseUrl,
        'enableLogging': enableLogging,
        'enableCrashlytics': enableCrashlytics,
        'enableAnalytics': enableAnalytics,
        'useMockData': useMockData,
      };
}
