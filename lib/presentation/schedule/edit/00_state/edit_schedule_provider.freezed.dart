// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_schedule_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditScheduleState {
  bool get isSubmitting => throw _privateConstructorUsedError;
  ScheduleEntity? get updated => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditScheduleStateCopyWith<EditScheduleState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditScheduleStateCopyWith<$Res> {
  factory $EditScheduleStateCopyWith(
          EditScheduleState value, $Res Function(EditScheduleState) then) =
      _$EditScheduleStateCopyWithImpl<$Res, EditScheduleState>;
  @useResult
  $Res call({bool isSubmitting, ScheduleEntity? updated, String? errorMessage});
}

/// @nodoc
class _$EditScheduleStateCopyWithImpl<$Res, $Val extends EditScheduleState>
    implements $EditScheduleStateCopyWith<$Res> {
  _$EditScheduleStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? updated = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as ScheduleEntity?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditScheduleStateImplCopyWith<$Res>
    implements $EditScheduleStateCopyWith<$Res> {
  factory _$$EditScheduleStateImplCopyWith(_$EditScheduleStateImpl value,
          $Res Function(_$EditScheduleStateImpl) then) =
      __$$EditScheduleStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isSubmitting, ScheduleEntity? updated, String? errorMessage});
}

/// @nodoc
class __$$EditScheduleStateImplCopyWithImpl<$Res>
    extends _$EditScheduleStateCopyWithImpl<$Res, _$EditScheduleStateImpl>
    implements _$$EditScheduleStateImplCopyWith<$Res> {
  __$$EditScheduleStateImplCopyWithImpl(_$EditScheduleStateImpl _value,
      $Res Function(_$EditScheduleStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isSubmitting = null,
    Object? updated = freezed,
    Object? errorMessage = freezed,
  }) {
    return _then(_$EditScheduleStateImpl(
      isSubmitting: null == isSubmitting
          ? _value.isSubmitting
          : isSubmitting // ignore: cast_nullable_to_non_nullable
              as bool,
      updated: freezed == updated
          ? _value.updated
          : updated // ignore: cast_nullable_to_non_nullable
              as ScheduleEntity?,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$EditScheduleStateImpl implements _EditScheduleState {
  const _$EditScheduleStateImpl(
      {this.isSubmitting = false, this.updated, this.errorMessage});

  @override
  @JsonKey()
  final bool isSubmitting;
  @override
  final ScheduleEntity? updated;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'EditScheduleState(isSubmitting: $isSubmitting, updated: $updated, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditScheduleStateImpl &&
            (identical(other.isSubmitting, isSubmitting) ||
                other.isSubmitting == isSubmitting) &&
            (identical(other.updated, updated) || other.updated == updated) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, isSubmitting, updated, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditScheduleStateImplCopyWith<_$EditScheduleStateImpl> get copyWith =>
      __$$EditScheduleStateImplCopyWithImpl<_$EditScheduleStateImpl>(
          this, _$identity);
}

abstract class _EditScheduleState implements EditScheduleState {
  const factory _EditScheduleState(
      {final bool isSubmitting,
      final ScheduleEntity? updated,
      final String? errorMessage}) = _$EditScheduleStateImpl;

  @override
  bool get isSubmitting;
  @override
  ScheduleEntity? get updated;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$EditScheduleStateImplCopyWith<_$EditScheduleStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
