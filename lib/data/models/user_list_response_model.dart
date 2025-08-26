import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'user_list_response_model.freezed.dart';
part 'user_list_response_model.g.dart';

@freezed
class UserListResponseModel with _$UserListResponseModel {
  const factory UserListResponseModel({
    required List<UserModel> data,
    required int total,
    required int page,
    required int limit,
    @Default(false) bool hasMore,
  }) = _UserListResponseModel;

  factory UserListResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserListResponseModelFromJson(json);
}
