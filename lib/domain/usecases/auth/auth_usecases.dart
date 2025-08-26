import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// 유저 정보 가져오기 UseCase
class GetUserInfoUseCase {
  final AuthRepository _authRepository;

  GetUserInfoUseCase(this._authRepository);

  /// 토큰으로 유저 정보 가져오기
  Future<({Failure? failure, UserEntity? user})> call(String accessToken) async {
    if (accessToken.trim().isEmpty) {
      return (failure: const ValidationFailure(message: '액세스 토큰이 필요합니다.'), user: null);
    }

    return await _authRepository.getUserInfo(accessToken.trim());
  }
}

/// 토큰 새로고침 UseCase
class RefreshTokenUseCase {
  final AuthRepository _authRepository;

  RefreshTokenUseCase(this._authRepository);

  /// 토큰 새로고침
  Future<({Failure? failure, String? accessToken, String? refreshToken})> call(
    String refreshToken,
  ) async {
    if (refreshToken.trim().isEmpty) {
      return (
        failure: const ValidationFailure(message: '리프레시 토큰이 필요합니다.'),
        accessToken: null,
        refreshToken: null,
      );
    }

    return await _authRepository.refreshToken(refreshToken.trim());
  }
}

/// 로그아웃 UseCase
class LogoutUseCase {
  final AuthRepository _authRepository;

  LogoutUseCase(this._authRepository);

  /// 로그아웃
  Future<({Failure? failure})> call(String accessToken) async {
    if (accessToken.trim().isEmpty) {
      return (failure: const ValidationFailure(message: '액세스 토큰이 필요합니다.'));
    }

    return await _authRepository.logout(accessToken.trim());
  }
}
