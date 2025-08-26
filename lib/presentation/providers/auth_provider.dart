import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/config/app_config.dart';
import '../../core/services/token_service.dart';
import '../../core/utils/logger.dart';
import '../../data/datasources/auth/auth_datasource.dart';
import '../../data/datasources/auth/mock_auth_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/login_usecase.dart';
import '../../domain/usecases/auth/auth_usecases.dart';

part 'auth_provider.freezed.dart';
part 'auth_provider.g.dart';

/// 인증 상태
@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    @Default(AuthStatus.initial) AuthStatus status,
    UserEntity? user,
    String? accessToken,
    String? refreshToken,
    String? errorMessage,
  }) = _AuthState;
}

/// 인증 상태 타입
enum AuthStatus {
  initial,       // 초기 상태
  loading,       // 로딩 중
  authenticated, // 인증됨
  unauthenticated, // 인증되지 않음
  error,         // 에러
}

/// Auth DataSource Provider
@riverpod
AuthDataSource authDataSource(AuthDataSourceRef ref) {
  // Mock 환경에서는 MockAuthDataSource 사용
  if (AppConfig.environment.isMock) {
    return MockAuthDataSource();
  }
  
  // 실제 환경에서는 RemoteAuthDataSource 사용 (추후 구현)
  throw UnimplementedError('RemoteAuthDataSource not implemented yet');
}

/// Auth Repository Provider
@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dataSource = ref.read(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
}

/// Login UseCase Provider
@riverpod
LoginUseCase loginUseCase(LoginUseCaseRef ref) {
  final repository = ref.read(authRepositoryProvider);
  return LoginUseCase(repository);
}

/// Get User Info UseCase Provider
@riverpod
GetUserInfoUseCase getUserInfoUseCase(GetUserInfoUseCaseRef ref) {
  final repository = ref.read(authRepositoryProvider);
  return GetUserInfoUseCase(repository);
}

/// Refresh Token UseCase Provider
@riverpod
RefreshTokenUseCase refreshTokenUseCase(RefreshTokenUseCaseRef ref) {
  final repository = ref.read(authRepositoryProvider);
  return RefreshTokenUseCase(repository);
}

/// Logout UseCase Provider
@riverpod
LogoutUseCase logoutUseCase(LogoutUseCaseRef ref) {
  final repository = ref.read(authRepositoryProvider);
  return LogoutUseCase(repository);
}

/// Auth Provider (상태 관리)
@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthState build() {
    return const AuthState();
  }

  /// 로그인
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);

    try {
      final loginUseCase = ref.read(loginUseCaseProvider);
      final result = await loginUseCase(identifier: identifier, password: password);

      if (result.failure != null) {
        state = state.copyWith(
          status: AuthStatus.error,
          errorMessage: result.failure!.message,
        );
        return false;
      }

      // 토큰 저장
      if (result.accessToken != null && result.refreshToken != null) {
        await TokenService.instance.saveTokens(
          accessToken: result.accessToken!,
          refreshToken: result.refreshToken!,
        );
      }

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        accessToken: result.accessToken,
        refreshToken: result.refreshToken,
        errorMessage: null,
      );

      Logger.i('✅ Login successful for user: ${result.user?.name}');
      return true;
    } catch (e) {
      Logger.e('❌ Login error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: '로그인 중 오류가 발생했습니다.',
      );
      return false;
    }
  }

  /// 저장된 토큰으로 자동 로그인 시도
  Future<bool> tryAutoLogin() async {
    state = state.copyWith(status: AuthStatus.loading);

    try {
      final accessToken = TokenService.instance.getAccessToken();
      
      if (accessToken == null) {
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return false;
      }

      // 토큰으로 유저 정보 가져오기
      final getUserInfoUseCase = ref.read(getUserInfoUseCaseProvider);
      final result = await getUserInfoUseCase(accessToken);

      if (result.failure != null) {
        // 토큰이 만료되었을 수 있으므로 refresh 시도
        final refreshToken = TokenService.instance.getRefreshToken();
        if (refreshToken != null) {
          final refreshSuccess = await _refreshToken(refreshToken);
          if (refreshSuccess) {
            return await tryAutoLogin(); // 재귀 호출로 다시 시도
          }
        }

        await TokenService.instance.clearTokens();
        state = state.copyWith(status: AuthStatus.unauthenticated);
        return false;
      }

      state = state.copyWith(
        status: AuthStatus.authenticated,
        user: result.user,
        accessToken: accessToken,
        refreshToken: TokenService.instance.getRefreshToken(),
      );

      Logger.i('✅ Auto login successful for user: ${result.user?.name}');
      return true;
    } catch (e) {
      Logger.e('❌ Auto login error: $e');
      await TokenService.instance.clearTokens();
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return false;
    }
  }

  /// 토큰 새로고침
  Future<bool> _refreshToken(String refreshToken) async {
    try {
      final refreshTokenUseCase = ref.read(refreshTokenUseCaseProvider);
      final result = await refreshTokenUseCase(refreshToken);

      if (result.failure != null) {
        return false;
      }

      if (result.accessToken != null) {
        await TokenService.instance.saveAccessToken(result.accessToken!);
        if (result.refreshToken != null) {
          await TokenService.instance.saveRefreshToken(result.refreshToken!);
        }
        
        state = state.copyWith(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken ?? refreshToken,
        );

        Logger.i('✅ Token refreshed successfully');
        return true;
      }

      return false;
    } catch (e) {
      Logger.e('❌ Token refresh error: $e');
      return false;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    try {
      final accessToken = state.accessToken;
      if (accessToken != null) {
        final logoutUseCase = ref.read(logoutUseCaseProvider);
        await logoutUseCase(accessToken);
      }
    } catch (e) {
      Logger.e('❌ Logout error: $e');
    } finally {
      // 에러가 발생해도 로컬 토큰은 삭제
      await TokenService.instance.clearTokens();
      state = const AuthState(status: AuthStatus.unauthenticated);
      Logger.i('✅ Logout completed');
    }
  }

  /// 에러 클리어
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
