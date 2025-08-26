import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

/// 로그인 요청 모델
@freezed
class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String identifier, // 이메일, 전화번호, 또는 ID
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// 로그인 응답 모델
@freezed
class LoginResponse with _$LoginResponse {
  const factory LoginResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') int? expiresIn,
    required UserModel user,
  }) = _LoginResponse;

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

/// 토큰 새로고침 요청 모델
@freezed
class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    @JsonKey(name: 'refresh_token') required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}

/// 토큰 새로고침 응답 모델
@freezed
class RefreshTokenResponse with _$RefreshTokenResponse {
  const factory RefreshTokenResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') String? refreshToken,
    @JsonKey(name: 'token_type') @Default('Bearer') String tokenType,
    @JsonKey(name: 'expires_in') int? expiresIn,
  }) = _RefreshTokenResponse;

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}
