import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_entity.freezed.dart';

/// 유저 엔티티 (도메인 레이어)
@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required String email,
    String? phoneNumber,
    String? profileImageUrl,
    @Default(false) bool isEmailVerified,
    @Default(false) bool isPhoneVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserEntity;
}
