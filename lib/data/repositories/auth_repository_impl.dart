import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth/auth_datasource.dart';
import '../models/auth_models.dart';

/// 인증 레포지토리 구현체 (데이터 레이어)
class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<({Failure? failure, String? accessToken, String? refreshToken, UserEntity? user})> login({
    required String identifier,
    required String password,
  }) async {
    try {
      Logger.i('🔐 Attempting login for: $identifier');
      
      final request = LoginRequest(
        identifier: identifier,
        password: password,
      );

      final response = await _authDataSource.login(request);
      
      Logger.i('✅ Login successful');
      
      return (
        failure: null,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user.toEntity(),
      );
    } catch (e) {
      Logger.e('❌ Login failed: $e');
      
      return (
        failure: ServerFailure(message: e.toString()),
        accessToken: null,
        refreshToken: null,
        user: null,
      );
    }
  }

  @override
  Future<({Failure? failure, UserEntity? user})> getUserInfo(String accessToken) async {
    try {
      Logger.i('👤 Fetching user info');
      
      final userModel = await _authDataSource.getUserInfo(accessToken);
      
      Logger.i('✅ User info fetched successfully');
      
      return (
        failure: null,
        user: userModel.toEntity(),
      );
    } catch (e) {
      Logger.e('❌ Failed to fetch user info: $e');
      
      return (
        failure: ServerFailure(message: e.toString()),
        user: null,
      );
    }
  }

  @override
  Future<({Failure? failure, String? accessToken, String? refreshToken})> refreshToken(String refreshToken) async {
    try {
      Logger.i('🔄 Refreshing token');
      
      final request = RefreshTokenRequest(refreshToken: refreshToken);
      final response = await _authDataSource.refreshToken(request);
      
      Logger.i('✅ Token refreshed successfully');
      
      return (
        failure: null,
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );
    } catch (e) {
      Logger.e('❌ Token refresh failed: $e');
      
      return (
        failure: ServerFailure(message: e.toString()),
        accessToken: null,
        refreshToken: null,
      );
    }
  }

  @override
  Future<({Failure? failure})> logout(String accessToken) async {
    try {
      Logger.i('👋 Logging out');
      
      await _authDataSource.logout(accessToken);
      
      Logger.i('✅ Logout successful');
      
      return (failure: null);
    } catch (e) {
      Logger.e('❌ Logout failed: $e');
      
      return (failure: ServerFailure(message: e.toString()));
    }
  }
}
