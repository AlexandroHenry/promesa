import '../../models/auth_models.dart';
import '../../models/user_model.dart';

/// 인증 데이터소스 인터페이스
abstract class AuthDataSource {
  /// 로그인
  Future<LoginResponse> login(LoginRequest request);
  
  /// 토큰으로 유저 정보 가져오기
  Future<UserModel> getUserInfo(String accessToken);
  
  /// 토큰 새로고침
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request);
  
  /// 로그아웃
  Future<void> logout(String accessToken);
}
