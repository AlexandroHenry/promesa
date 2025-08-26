// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_list_response_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserListResponseModel _$UserListResponseModelFromJson(
    Map<String, dynamic> json) {
  return _UserListResponseModel.fromJson(json);
}

/// @nodoc
mixin _$UserListResponseModel {
  List<UserModel> get data => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  int get page => throw _privateConstructorUsedError;
  int get limit => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserListResponseModelCopyWith<UserListResponseModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserListResponseModelCopyWith<$Res> {
  factory $UserListResponseModelCopyWith(UserListResponseModel value,
          $Res Function(UserListResponseModel) then) =
      _$UserListResponseModelCopyWithImpl<$Res, UserListResponseModel>;
  @useResult
  $Res call(
      {List<UserModel> data, int total, int page, int limit, bool hasMore});
}

/// @nodoc
class _$UserListResponseModelCopyWithImpl<$Res,
        $Val extends UserListResponseModel>
    implements $UserListResponseModelCopyWith<$Res> {
  _$UserListResponseModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_value.copyWith(
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserListResponseModelImplCopyWith<$Res>
    implements $UserListResponseModelCopyWith<$Res> {
  factory _$$UserListResponseModelImplCopyWith(
          _$UserListResponseModelImpl value,
          $Res Function(_$UserListResponseModelImpl) then) =
      __$$UserListResponseModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<UserModel> data, int total, int page, int limit, bool hasMore});
}

/// @nodoc
class __$$UserListResponseModelImplCopyWithImpl<$Res>
    extends _$UserListResponseModelCopyWithImpl<$Res,
        _$UserListResponseModelImpl>
    implements _$$UserListResponseModelImplCopyWith<$Res> {
  __$$UserListResponseModelImplCopyWithImpl(_$UserListResponseModelImpl _value,
      $Res Function(_$UserListResponseModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? data = null,
    Object? total = null,
    Object? page = null,
    Object? limit = null,
    Object? hasMore = null,
  }) {
    return _then(_$UserListResponseModelImpl(
      data: null == data
          ? _value._data
          : data // ignore: cast_nullable_to_non_nullable
              as List<UserModel>,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      page: null == page
          ? _value.page
          : page // ignore: cast_nullable_to_non_nullable
              as int,
      limit: null == limit
          ? _value.limit
          : limit // ignore: cast_nullable_to_non_nullable
              as int,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserListResponseModelImpl implements _UserListResponseModel {
  const _$UserListResponseModelImpl(
      {required final List<UserModel> data,
      required this.total,
      required this.page,
      required this.limit,
      this.hasMore = false})
      : _data = data;

  factory _$UserListResponseModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserListResponseModelImplFromJson(json);

  final List<UserModel> _data;
  @override
  List<UserModel> get data {
    if (_data is EqualUnmodifiableListView) return _data;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_data);
  }

  @override
  final int total;
  @override
  final int page;
  @override
  final int limit;
  @override
  @JsonKey()
  final bool hasMore;

  @override
  String toString() {
    return 'UserListResponseModel(data: $data, total: $total, page: $page, limit: $limit, hasMore: $hasMore)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserListResponseModelImpl &&
            const DeepCollectionEquality().equals(other._data, _data) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.page, page) || other.page == page) &&
            (identical(other.limit, limit) || other.limit == limit) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType,
      const DeepCollectionEquality().hash(_data), total, page, limit, hasMore);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserListResponseModelImplCopyWith<_$UserListResponseModelImpl>
      get copyWith => __$$UserListResponseModelImplCopyWithImpl<
          _$UserListResponseModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserListResponseModelImplToJson(
      this,
    );
  }
}

abstract class _UserListResponseModel implements UserListResponseModel {
  const factory _UserListResponseModel(
      {required final List<UserModel> data,
      required final int total,
      required final int page,
      required final int limit,
      final bool hasMore}) = _$UserListResponseModelImpl;

  factory _UserListResponseModel.fromJson(Map<String, dynamic> json) =
      _$UserListResponseModelImpl.fromJson;

  @override
  List<UserModel> get data;
  @override
  int get total;
  @override
  int get page;
  @override
  int get limit;
  @override
  bool get hasMore;
  @override
  @JsonKey(ignore: true)
  _$$UserListResponseModelImplCopyWith<_$UserListResponseModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
