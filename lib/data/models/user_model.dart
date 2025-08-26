import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

/// 유저 모델 (데이터 레이어)
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'phone_number') String? phoneNumber,
    @JsonKey(name: 'profile_image_url') String? profileImageUrl,
    @JsonKey(name: 'is_email_verified') @Default(false) bool isEmailVerified,
    @JsonKey(name: 'is_phone_verified') @Default(false) bool isPhoneVerified,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  const UserModel._();

  /// Entity로 변환
  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
      isEmailVerified: isEmailVerified,
      isPhoneVerified: isPhoneVerified,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Entity에서 생성
  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      profileImageUrl: entity.profileImageUrl,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
