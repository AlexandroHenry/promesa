// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_list_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserListResponseModelImpl _$$UserListResponseModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserListResponseModelImpl(
      data: (json['data'] as List<dynamic>)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toInt(),
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      hasMore: json['hasMore'] as bool? ?? false,
    );

Map<String, dynamic> _$$UserListResponseModelImplToJson(
        _$UserListResponseModelImpl instance) =>
    <String, dynamic>{
      'data': instance.data,
      'total': instance.total,
      'page': instance.page,
      'limit': instance.limit,
      'hasMore': instance.hasMore,
    };
