// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'add_schedule_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AddScheduleState {
  bool get isSubmitting => throw _privateConstructorUsedError;
  ScheduleEntity? get created => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $AddScheduleStateCopyWith<AddScheduleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AddScheduleStateCopyWith<$Res> {
  factory $AddScheduleStateCopyWith(
          AddScheduleState value, $Res Function(AddScheduleState) then) =
      _$AddScheduleStateCopyWithImpl<$Res, AddScheduleState>;
  @useResult
  $Res call({bool isSubmitting, ScheduleEntity? created, String? errorMessage});
}

/// @nodoc
class _$AddScheduleStateCopyWithImpl<$Res, $Val extends AddScheduleState>
    implements $AddScheduleStateCopyWith<$Res> {
  _$AddScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? created = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as ScheduleEntity?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AddScheduleStateImplCopyWith<$Res>
    implements $AddScheduleStateCopyWith<$Res> {
  factory _$$AddScheduleStateImplCopyWith(_$AddScheduleStateImpl value,
          $Res Function(_$AddScheduleStateImpl) then) =
      __$$AddScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSubmitting, ScheduleEntity? created, String? errorMessage});
}

/// @nodoc
class __$$AddScheduleStateImplCopyWithImpl<$Res>
    extends _$AddScheduleStateCopyWithImpl<$Res, _$AddScheduleStateImpl>
    implements _$$AddScheduleStateImplCopyWith<$Res> {
  __$$AddScheduleStateImplCopyWithImpl(_$AddScheduleStateImpl _value,
      $Res Function(_$AddScheduleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? created = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$AddScheduleStateImpl(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      created: freezed == created
          ? _value.created
          : created // ignore: cast_nullable_to_non_nullable
              as ScheduleEntity?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$AddScheduleStateImpl implements _AddScheduleState {
  const _$AddScheduleStateImpl(
      {this.isSubmitting = false, this.created, this.errorMessage});

  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final ScheduleEntity? created;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'AddScheduleState(isSubmitting: $isSubmitting, created: $created, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddScheduleStateImpl &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.created, created) || other.created == created) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isSubmitting, created, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AddScheduleStateImplCopyWith<_$AddScheduleStateImpl> get copyWith =>
      __$$AddScheduleStateImplCopyWithImpl<_$AddScheduleStateImpl>(
          this, _$identity);
}

abstract class _AddScheduleState implements AddScheduleState {
  const factory _AddScheduleState(
      {final bool isSubmitting,
      final ScheduleEntity? created,
      final String? errorMessage}) = _$AddScheduleStateImpl;

  @override
  bool get isSubmitting;
  @override
  ScheduleEntity? get created;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$AddScheduleStateImplCopyWith<_$AddScheduleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
