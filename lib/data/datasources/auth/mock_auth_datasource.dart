import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import '../../../core/utils/logger.dart';
import '../../models/auth_models.dart';
import '../../models/user_model.dart';
import 'auth_datasource.dart';

/// Mock 인증 데이터소스
class MockAuthDataSource implements AuthDataSource {
  Map<String, dynamic>? _mockData;

  /// Mock 데이터 로드
  Future<void> _loadMockData() async {
    if (_mockData == null) {
      try {
        final jsonString = await rootBundle.loadString('assets/mock_data/auth.json');
        _mockData = json.decode(jsonString);
        Logger.i('📦 Mock auth data loaded successfully');
      } catch (e) {
        Logger.e('❌ Failed to load mock auth data: $e');
        _mockData = _getDefaultMockData();
      }
    }
  }

  /// 기본 Mock 데이터 (파일 로드 실패 시)
  Map<String, dynamic> _getDefaultMockData() {
    return {
      "users": [
        {
          "id": "user_001",
          "name": "김철수",
          "email": "test@example.com",
          "phone_number": "+82-10-1234-5678",
          "profile_image_url": "https://picsum.photos/200/200?random=1",
          "is_email_verified": true,
          "is_phone_verified": true,
          "created_at": "2024-01-15T09:00:00Z",
          "updated_at": "2024-08-20T14:30:00Z"
        }
      ],
      "test_accounts": [
        {
          "identifier": "test@example.com",
          "password": "123456",
          "user_id": "user_001"
        }
      ]
    };
  }

  /// 네트워크 지연 시뮬레이션
  Future<void> _simulateNetworkDelay() async {
    final delayMs = 500 + Random().nextInt(1000); // 500-1500ms
    await Future.delayed(Duration(milliseconds: delayMs));
  }

  /// 네트워크 에러 시뮬레이션 (10% 확률)
  void _simulateNetworkError() {
    if (Random().nextInt(10) == 0) {
      throw Exception('Mock network error: Connection timeout');
    }
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    await _loadMockData();
    await _simulateNetworkDelay();
    _simulateNetworkError();

    Logger.i('🔐 Mock login attempt: ${request.identifier}');

    final testAccounts = (_mockData!['test_accounts'] as List).cast<Map<String, dynamic>>();
    final users = (_mockData!['users'] as List).cast<Map<String, dynamic>>();

    // 테스트 계정 찾기
    final account = testAccounts.firstWhere(
      (acc) => acc['identifier'] == request.identifier && 
               acc['password'] == request.password,
      orElse: () => throw Exception('Invalid credentials'),
    );

    // 해당 유저 정보 찾기
    final userData = users.firstWhere(
      (user) => user['id'] == account['user_id'],
      orElse: () => throw Exception('User not found'),
    );

    final user = UserModel.fromJson(userData);

    // Mock 토큰 생성
    final accessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    final refreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

    Logger.i('✅ Mock login successful for user: ${user.name}');

    return LoginResponse(
      accessToken: accessToken,
      refreshToken: refreshToken,
      tokenType: 'Bearer',
      expiresIn: 3600, // 1시간
      user: user,
    );
  }

  @override
  Future<UserModel> getUserInfo(String accessToken) async {
    await _loadMockData();
    await _simulateNetworkDelay();
    _simulateNetworkError();

    Logger.i('👤 Mock getUserInfo with token: ${accessToken.substring(0, 20)}...');

    if (!accessToken.startsWith('mock_access_token_')) {
      throw Exception('Invalid access token');
    }

    final users = (_mockData!['users'] as List).cast<Map<String, dynamic>>();
    
    // 첫 번째 사용자 반환 (실제로는 토큰에서 사용자 식별)
    final userData = users.first;
    final user = UserModel.fromJson(userData);

    Logger.i('✅ Mock user info retrieved: ${user.name}');

    return user;
  }

  @override
  Future<RefreshTokenResponse> refreshToken(RefreshTokenRequest request) async {
    await _simulateNetworkDelay();
    _simulateNetworkError();

    Logger.i('🔄 Mock token refresh');

    if (!request.refreshToken.startsWith('mock_refresh_token_')) {
      throw Exception('Invalid refresh token');
    }

    // 새로운 Mock 토큰 생성
    final newAccessToken = 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}';
    final newRefreshToken = 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}';

    Logger.i('✅ Mock token refreshed successfully');

    return RefreshTokenResponse(
      accessToken: newAccessToken,
      refreshToken: newRefreshToken,
      tokenType: 'Bearer',
      expiresIn: 3600,
    );
  }

  @override
  Future<void> logout(String accessToken) async {
    await _simulateNetworkDelay();

    Logger.i('👋 Mock logout');
    Logger.i('✅ Mock logout successful');
  }
}
