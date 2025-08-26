// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'example_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ExampleEntity {
  int get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ExampleEntityCopyWith<ExampleEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ExampleEntityCopyWith<$Res> {
  factory $ExampleEntityCopyWith(
          ExampleEntity value, $Res Function(ExampleEntity) then) =
      _$ExampleEntityCopyWithImpl<$Res, ExampleEntity>;
  @useResult
  $Res call({int id, String name, String? description});
}

/// @nodoc
class _$ExampleEntityCopyWithImpl<$Res, $Val extends ExampleEntity>
    implements $ExampleEntityCopyWith<$Res> {
  _$ExampleEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ExampleEntityImplCopyWith<$Res>
    implements $ExampleEntityCopyWith<$Res> {
  factory _$$ExampleEntityImplCopyWith(
          _$ExampleEntityImpl value, $Res Function(_$ExampleEntityImpl) then) =
      __$$ExampleEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String name, String? description});
}

/// @nodoc
class __$$ExampleEntityImplCopyWithImpl<$Res>
    extends _$ExampleEntityCopyWithImpl<$Res, _$ExampleEntityImpl>
    implements _$$ExampleEntityImplCopyWith<$Res> {
  __$$ExampleEntityImplCopyWithImpl(
      _$ExampleEntityImpl _value, $Res Function(_$ExampleEntityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
  }) {
    return _then(_$ExampleEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ExampleEntityImpl implements _ExampleEntity {
  const _$ExampleEntityImpl(
      {required this.id, required this.name, this.description});

  @override
  final int id;
  @override
  final String name;
  @override
  final String? description;

  @override
  String toString() {
    return 'ExampleEntity(id: $id, name: $name, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ExampleEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, description);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ExampleEntityImplCopyWith<_$ExampleEntityImpl> get copyWith =>
      __$$ExampleEntityImplCopyWithImpl<_$ExampleEntityImpl>(this, _$identity);
}

abstract class _ExampleEntity implements ExampleEntity {
  const factory _ExampleEntity(
      {required final int id,
      required final String name,
      final String? description}) = _$ExampleEntityImpl;

  @override
  int get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  @JsonKey(ignore: true)
  _$$ExampleEntityImplCopyWith<_$ExampleEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
