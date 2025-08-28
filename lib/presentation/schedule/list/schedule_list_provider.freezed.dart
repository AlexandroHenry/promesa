// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'schedule_list_provider.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ScheduleListState {
  bool get isLoading => throw _privateConstructorUsedError;
  List<ScheduleEntity> get items => throw _privateConstructorUsedError;
  ScheduleFilter get filter => throw _privateConstructorUsedError;
  ScheduleView get view => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ScheduleListStateCopyWith<ScheduleListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ScheduleListStateCopyWith<$Res> {
  factory $ScheduleListStateCopyWith(
          ScheduleListState value, $Res Function(ScheduleListState) then) =
      _$ScheduleListStateCopyWithImpl<$Res, ScheduleListState>;
  @useResult
  $Res call(
      {bool isLoading,
      List<ScheduleEntity> items,
      ScheduleFilter filter,
      ScheduleView view,
      String? errorMessage});
}

/// @nodoc
class _$ScheduleListStateCopyWithImpl<$Res, $Val extends ScheduleListState>
    implements $ScheduleListStateCopyWith<$Res> {
  _$ScheduleListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = null,
    Object? filter = null,
    Object? view = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_value.copyWith(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value.items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ScheduleEntity>,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ScheduleFilter,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as ScheduleView,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ScheduleListStateImplCopyWith<$Res>
    implements $ScheduleListStateCopyWith<$Res> {
  factory _$$ScheduleListStateImplCopyWith(_$ScheduleListStateImpl value,
          $Res Function(_$ScheduleListStateImpl) then) =
      __$$ScheduleListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool isLoading,
      List<ScheduleEntity> items,
      ScheduleFilter filter,
      ScheduleView view,
      String? errorMessage});
}

/// @nodoc
class __$$ScheduleListStateImplCopyWithImpl<$Res>
    extends _$ScheduleListStateCopyWithImpl<$Res, _$ScheduleListStateImpl>
    implements _$$ScheduleListStateImplCopyWith<$Res> {
  __$$ScheduleListStateImplCopyWithImpl(_$ScheduleListStateImpl _value,
      $Res Function(_$ScheduleListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? items = null,
    Object? filter = null,
    Object? view = null,
    Object? errorMessage = freezed,
  }) {
    return _then(_$ScheduleListStateImpl(
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      items: null == items
          ? _value._items
          : items // ignore: cast_nullable_to_non_nullable
              as List<ScheduleEntity>,
      filter: null == filter
          ? _value.filter
          : filter // ignore: cast_nullable_to_non_nullable
              as ScheduleFilter,
      view: null == view
          ? _value.view
          : view // ignore: cast_nullable_to_non_nullable
              as ScheduleView,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ScheduleListStateImpl implements _ScheduleListState {
  const _$ScheduleListStateImpl(
      {this.isLoading = false,
      final List<ScheduleEntity> items = const [],
      this.filter = ScheduleFilter.all,
      this.view = ScheduleView.day,
      this.errorMessage})
      : _items = items;

  @override
  @JsonKey()
  final bool isLoading;
  final List<ScheduleEntity> _items;
  @override
  @JsonKey()
  List<ScheduleEntity> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  final ScheduleFilter filter;
  @override
  @JsonKey()
  final ScheduleView view;
  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'ScheduleListState(isLoading: $isLoading, items: $items, filter: $filter, view: $view, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ScheduleListStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.filter, filter) || other.filter == filter) &&
            (identical(other.view, view) || other.view == view) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isLoading,
      const DeepCollectionEquality().hash(_items), filter, view, errorMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ScheduleListStateImplCopyWith<_$ScheduleListStateImpl> get copyWith =>
      __$$ScheduleListStateImplCopyWithImpl<_$ScheduleListStateImpl>(
          this, _$identity);
}

abstract class _ScheduleListState implements ScheduleListState {
  const factory _ScheduleListState(
      {final bool isLoading,
      final List<ScheduleEntity> items,
      final ScheduleFilter filter,
      final ScheduleView view,
      final String? errorMessage}) = _$ScheduleListStateImpl;

  @override
  bool get isLoading;
  @override
  List<ScheduleEntity> get items;
  @override
  ScheduleFilter get filter;
  @override
  ScheduleView get view;
  @override
  String? get errorMessage;
  @override
  @JsonKey(ignore: true)
  _$$ScheduleListStateImplCopyWith<_$ScheduleListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
