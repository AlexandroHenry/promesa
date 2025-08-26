import 'package:get_it/get_it.dart';
import '../network/dio_client.dart';
import '../config/app_config.dart';
import '../services/token_service.dart';
import '../../data/datasources/remote/user_api.dart';
import '../../data/repositories/api_user_repository.dart';
import '../../data/repositories/mock_user_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/get_users_usecase.dart';
import '../../domain/usecases/get_user_usecase.dart';
import '../../domain/usecases/create_user_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core Services
  await TokenService.instance.init();
  
  // Network
  getIt.registerLazySingleton<DioClient>(() => DioClient());

  // API Services (실제 API 사용시에만)
  if (!AppConfig.useMockData) {
    getIt.registerLazySingleton<UserApi>(
      () => UserApi(getIt<DioClient>().dio),
    );
  }

  // Repositories - 환경별 분기
  _setupRepositories();

  // Use Cases
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );
}

void _setupRepositories() {
  if (AppConfig.useMockData) {
    // Mock 환경
    getIt.registerLazySingleton<UserRepository>(
      () => MockUserRepository(),
    );
  } else {
    // 실제 API 환경 (prod, stg, debug)
    getIt.registerLazySingleton<UserRepository>(
      () => ApiUserRepository(getIt<UserApi>()),
    );
  }
}

// 테스트를 위한 의존성 재설정
void resetDependencies() {
  getIt.reset();
}

// 개발 중 Repository 변경을 위한 함수
void switchToMockRepository() {
  // 기존 의존성들 제거
  _unregisterUserDependencies();
  
  // Mock Repository 등록
  getIt.registerLazySingleton<UserRepository>(
    () => MockUserRepository(),
  );
  
  // UseCase들 재등록
  _registerUseCases();
}

void switchToApiRepository() {
  // 기존 의존성들 제거
  _unregisterUserDependencies();
  
  // API 관련 의존성 등록
  if (!getIt.isRegistered<UserApi>()) {
    getIt.registerLazySingleton<UserApi>(
      () => UserApi(getIt<DioClient>().dio),
    );
  }
  
  // API Repository 등록
  getIt.registerLazySingleton<UserRepository>(
    () => ApiUserRepository(getIt<UserApi>()),
  );
  
  // UseCase들 재등록
  _registerUseCases();
}

void _unregisterUserDependencies() {
  if (getIt.isRegistered<GetUsersUseCase>()) {
    getIt.unregister<GetUsersUseCase>();
  }
  if (getIt.isRegistered<GetUserUseCase>()) {
    getIt.unregister<GetUserUseCase>();
  }
  if (getIt.isRegistered<CreateUserUseCase>()) {
    getIt.unregister<CreateUserUseCase>();
  }
  if (getIt.isRegistered<UserRepository>()) {
    getIt.unregister<UserRepository>();
  }
}

void _registerUseCases() {
  getIt.registerLazySingleton<GetUsersUseCase>(
    () => GetUsersUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(getIt<UserRepository>()),
  );
  
  getIt.registerLazySingleton<CreateUserUseCase>(
    () => CreateUserUseCase(getIt<UserRepository>()),
  );
}
