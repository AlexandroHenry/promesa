import '../../../core/errors/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// 로그인 UseCase
class LoginUseCase {
  final AuthRepository _authRepository;

  LoginUseCase(this._authRepository);

  /// 로그인 실행
  /// 
  /// [identifier]: 이메일, 전화번호, 또는 사용자 ID
  /// [password]: 비밀번호
  Future<({Failure? failure, String? accessToken, String? refreshToken, UserEntity? user})> call({
    required String identifier,
    required String password,
  }) async {
    // 입력값 검증
    if (identifier.trim().isEmpty) {
      return (
        failure: const ValidationFailure(message: '아이디를 입력해주세요.'),
        accessToken: null,
        refreshToken: null,
        user: null,
      );
    }

    if (password.trim().isEmpty) {
      return (
        failure: const ValidationFailure(message: '비밀번호를 입력해주세요.'),
        accessToken: null,
        refreshToken: null,
        user: null,
      );
    }

    if (password.length < 6) {
      return (
        failure: const ValidationFailure(message: '비밀번호는 6자 이상이어야 합니다.'),
        accessToken: null,
        refreshToken: null,
        user: null,
      );
    }

    // Repository 호출
    return await _authRepository.login(
      identifier: identifier.trim(),
      password: password,
    );
  }
}
