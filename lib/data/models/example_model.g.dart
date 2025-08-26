// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ExampleModelImpl _$$ExampleModelImplFromJson(Map<String, dynamic> json) =>
    _$ExampleModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ExampleModelImplToJson(_$ExampleModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
    };
