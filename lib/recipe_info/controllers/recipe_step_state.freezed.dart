// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_step_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecipeStepState {
  bool get isDone => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeStepStateCopyWith<RecipeStepState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeStepStateCopyWith<$Res> {
  factory $RecipeStepStateCopyWith(
          RecipeStepState value, $Res Function(RecipeStepState) then) =
      _$RecipeStepStateCopyWithImpl<$Res, RecipeStepState>;
  @useResult
  $Res call({bool isDone});
}

/// @nodoc
class _$RecipeStepStateCopyWithImpl<$Res, $Val extends RecipeStepState>
    implements $RecipeStepStateCopyWith<$Res> {
  _$RecipeStepStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDone = null,
  }) {
    return _then(_value.copyWith(
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeStepStateImplCopyWith<$Res>
    implements $RecipeStepStateCopyWith<$Res> {
  factory _$$RecipeStepStateImplCopyWith(_$RecipeStepStateImpl value,
          $Res Function(_$RecipeStepStateImpl) then) =
      __$$RecipeStepStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool isDone});
}

/// @nodoc
class __$$RecipeStepStateImplCopyWithImpl<$Res>
    extends _$RecipeStepStateCopyWithImpl<$Res, _$RecipeStepStateImpl>
    implements _$$RecipeStepStateImplCopyWith<$Res> {
  __$$RecipeStepStateImplCopyWithImpl(
      _$RecipeStepStateImpl _value, $Res Function(_$RecipeStepStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isDone = null,
  }) {
    return _then(_$RecipeStepStateImpl(
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$RecipeStepStateImpl implements _RecipeStepState {
  const _$RecipeStepStateImpl({required this.isDone});

  @override
  final bool isDone;

  @override
  String toString() {
    return 'RecipeStepState(isDone: $isDone)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeStepStateImpl &&
            (identical(other.isDone, isDone) || other.isDone == isDone));
  }

  @override
  int get hashCode => Object.hash(runtimeType, isDone);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeStepStateImplCopyWith<_$RecipeStepStateImpl> get copyWith =>
      __$$RecipeStepStateImplCopyWithImpl<_$RecipeStepStateImpl>(
          this, _$identity);
}

abstract class _RecipeStepState implements RecipeStepState {
  const factory _RecipeStepState({required final bool isDone}) =
      _$RecipeStepStateImpl;

  @override
  bool get isDone;
  @override
  @JsonKey(ignore: true)
  _$$RecipeStepStateImplCopyWith<_$RecipeStepStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
