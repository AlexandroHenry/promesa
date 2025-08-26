import '../entities/user_entity.dart';
import '../../core/errors/failures.dart';

/// 인증 레포지토리 인터페이스 (도메인 레이어)
abstract class AuthRepository {
  /// 로그인
  Future<({Failure? failure, String? accessToken, String? refreshToken, UserEntity? user})> login({
    required String identifier,
    required String password,
  });

  /// 토큰으로 유저 정보 가져오기
  Future<({Failure? failure, UserEntity? user})> getUserInfo(String accessToken);

  /// 토큰 새로고침
  Future<({Failure? failure, String? accessToken, String? refreshToken})> refreshToken(String refreshToken);

  /// 로그아웃
  Future<({Failure? failure})> logout(String accessToken);
}
