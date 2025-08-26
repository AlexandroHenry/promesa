import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/config/app_config.dart';
import 'core/config/environment.dart';
import 'core/di/injection.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/logger.dart';
import 'core/localization/localization.dart';

void main() async {
  await _initializeApp();
}

void _runAppWithLocalization() async {
  // Initialize locale before running app
  final initialLocale = await LocalizationService.initializeLocale();
  
  runApp(
    EasyLocalization(
      supportedLocales: AppLocales.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: AppLocales.fallbackLocale,
      startLocale: initialLocale,
      child: ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}

Future<void> _initializeApp() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 환경 설정 (dart-define 또는 기본값 사용)
  final environment = _getEnvironmentFromDefine();
  AppConfig.setEnvironment(environment);
  
  // 환경 정보 로깅
  Logger.i('🚀 Starting app in ${environment.name} mode');
  Logger.i('📊 Environment info: ${AppConfig.environmentInfo}');

  // 의존성 주입 설정
  await setupDependencies();

  // EasyLocalization 초기화 후 앱 실행
  await EasyLocalization.ensureInitialized();
  
  _runAppWithLocalization();
}

// dart-define에서 환경 읽기
Environment _getEnvironmentFromDefine() {
  const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'debug');
  
  switch (envString.toLowerCase()) {
    case 'production':
    case 'prod':
      return Environment.production;
    case 'staging':
    case 'stg':
      return Environment.staging;
    case 'debug':
    case 'dev':
      return Environment.debug;
    case 'mock':
      return Environment.mock;
    default:
      Logger.w('Unknown environment: $envString, using debug as default');
      return Environment.debug;
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter App ${AppConfig.environment.displayName}',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
      debugShowCheckedModeBanner: !AppConfig.environment.isProduction,
      // Localization support
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      // 환경 배너 표시
      builder: (context, child) {
        if (AppConfig.showEnvironmentBanner && child != null) {
          return Banner(
            message: AppConfig.environment.displayName,
            location: BannerLocation.topEnd,
            color: _getBannerColor(),
            child: child,
          );
        }
        return child ?? const SizedBox.shrink();
      },
    );
  }

  Color _getBannerColor() {
    switch (AppConfig.environment) {
      case Environment.production:
        return Colors.green;
      case Environment.staging:
        return Colors.orange;
      case Environment.debug:
        return Colors.blue;
      case Environment.mock:
        return Colors.purple;
    }
  }
}
