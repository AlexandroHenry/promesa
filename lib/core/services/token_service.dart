import 'package:shared_preferences/shared_preferences.dart';

/// 토큰 관리 서비스
class TokenService {
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _isFirstLaunchKey = 'is_first_launch';

  static TokenService? _instance;
  static TokenService get instance => _instance ??= TokenService._();
  TokenService._();

  SharedPreferences? _prefs;

  /// 초기화
  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Access Token 저장
  Future<void> saveAccessToken(String token) async {
    await _prefs?.setString(_accessTokenKey, token);
  }

  /// Refresh Token 저장
  Future<void> saveRefreshToken(String token) async {
    await _prefs?.setString(_refreshTokenKey, token);
  }

  /// 토큰들 한번에 저장
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Access Token 가져오기
  String? getAccessToken() {
    return _prefs?.getString(_accessTokenKey);
  }

  /// Refresh Token 가져오기
  String? getRefreshToken() {
    return _prefs?.getString(_refreshTokenKey);
  }

  /// 토큰이 있는지 확인
  bool hasValidTokens() {
    final accessToken = getAccessToken();
    final refreshToken = getRefreshToken();
    return accessToken != null && 
           refreshToken != null && 
           accessToken.isNotEmpty && 
           refreshToken.isNotEmpty;
  }

  /// 토큰 삭제 (로그아웃)
  Future<void> clearTokens() async {
    await Future.wait([
      _prefs?.remove(_accessTokenKey) ?? Future.value(),
      _prefs?.remove(_refreshTokenKey) ?? Future.value(),
    ]);
  }

  /// 첫 실행 여부 확인
  bool isFirstLaunch() {
    return _prefs?.getBool(_isFirstLaunchKey) ?? true;
  }

  /// 첫 실행 완료 표시
  Future<void> setFirstLaunchCompleted() async {
    await _prefs?.setBool(_isFirstLaunchKey, false);
  }

  /// 모든 데이터 초기화 (앱 재설치 시뮬레이션)
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
