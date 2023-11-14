// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favourite_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$FavouriteState {
  bool get isFavourite => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $FavouriteStateCopyWith<FavouriteState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavouriteStateCopyWith<$Res> {
  factory $FavouriteStateCopyWith(
          FavouriteState value, $Res Function(FavouriteState) then) =
      _$FavouriteStateCopyWithImpl<$Res, FavouriteState>;
  @useResult
  $Res call({bool isFavourite});
}

/// @nodoc
class _$FavouriteStateCopyWithImpl<$Res, $Val extends FavouriteState>
    implements $FavouriteStateCopyWith<$Res> {
  _$FavouriteStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFavourite = null,
  }) {
    return _then(_value.copyWith(
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FavouriteStateImplCopyWith<$Res>
    implements $FavouriteStateCopyWith<$Res> {
  factory _$$FavouriteStateImplCopyWith(_$FavouriteStateImpl value,
          $Res Function(_$FavouriteStateImpl) then) =
      __$$FavouriteStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isFavourite});
}

/// @nodoc
class __$$FavouriteStateImplCopyWithImpl<$Res>
    extends _$FavouriteStateCopyWithImpl<$Res, _$FavouriteStateImpl>
    implements _$$FavouriteStateImplCopyWith<$Res> {
  __$$FavouriteStateImplCopyWithImpl(
      _$FavouriteStateImpl _value, $Res Function(_$FavouriteStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFavourite = null,
  }) {
    return _then(_$FavouriteStateImpl(
      isFavourite: null == isFavourite
          ? _value.isFavourite
          : isFavourite // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$FavouriteStateImpl implements _FavouriteState {
  const _$FavouriteStateImpl({required this.isFavourite});

  @override
  final bool isFavourite;

  @override
  String toString() {
    return 'FavouriteState(isFavourite: $isFavourite)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavouriteStateImpl &&
            (identical(other.isFavourite, isFavourite) ||
                other.isFavourite == isFavourite));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isFavourite);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$FavouriteStateImplCopyWith<_$FavouriteStateImpl> get copyWith =>
      __$$FavouriteStateImplCopyWithImpl<_$FavouriteStateImpl>(
          this, _$identity);
}

abstract class _FavouriteState implements FavouriteState {
  const factory _FavouriteState({required final bool isFavourite}) =
      _$FavouriteStateImpl;

  @override
  bool get isFavourite;
  @override
  @JsonKey(ignore: true)
  _$$FavouriteStateImplCopyWith<_$FavouriteStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
