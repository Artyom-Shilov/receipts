// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_info_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecipeInfoState {
  RecipeSearchStatus get searchStatus => throw _privateConstructorUsedError;
  Recipe? get recipe => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeInfoStateCopyWith<RecipeInfoState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeInfoStateCopyWith<$Res> {
  factory $RecipeInfoStateCopyWith(
          RecipeInfoState value, $Res Function(RecipeInfoState) then) =
      _$RecipeInfoStateCopyWithImpl<$Res, RecipeInfoState>;
  @useResult
  $Res call({RecipeSearchStatus searchStatus, Recipe? recipe});
}

/// @nodoc
class _$RecipeInfoStateCopyWithImpl<$Res, $Val extends RecipeInfoState>
    implements $RecipeInfoStateCopyWith<$Res> {
  _$RecipeInfoStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchStatus = null,
    Object? recipe = freezed,
  }) {
    return _then(_value.copyWith(
      searchStatus: null == searchStatus
          ? _value.searchStatus
          : searchStatus // ignore: cast_nullable_to_non_nullable
              as RecipeSearchStatus,
      recipe: freezed == recipe
          ? _value.recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as Recipe?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeInfoStateImplCopyWith<$Res>
    implements $RecipeInfoStateCopyWith<$Res> {
  factory _$$RecipeInfoStateImplCopyWith(_$RecipeInfoStateImpl value,
          $Res Function(_$RecipeInfoStateImpl) then) =
      __$$RecipeInfoStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({RecipeSearchStatus searchStatus, Recipe? recipe});
}

/// @nodoc
class __$$RecipeInfoStateImplCopyWithImpl<$Res>
    extends _$RecipeInfoStateCopyWithImpl<$Res, _$RecipeInfoStateImpl>
    implements _$$RecipeInfoStateImplCopyWith<$Res> {
  __$$RecipeInfoStateImplCopyWithImpl(
      _$RecipeInfoStateImpl _value, $Res Function(_$RecipeInfoStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? searchStatus = null,
    Object? recipe = freezed,
  }) {
    return _then(_$RecipeInfoStateImpl(
      searchStatus: null == searchStatus
          ? _value.searchStatus
          : searchStatus // ignore: cast_nullable_to_non_nullable
              as RecipeSearchStatus,
      recipe: freezed == recipe
          ? _value.recipe
          : recipe // ignore: cast_nullable_to_non_nullable
              as Recipe?,
    ));
  }
}

/// @nodoc

class _$RecipeInfoStateImpl implements _RecipeInfoState {
  const _$RecipeInfoStateImpl({required this.searchStatus, this.recipe});

  @override
  final RecipeSearchStatus searchStatus;
  @override
  final Recipe? recipe;

  @override
  String toString() {
    return 'RecipeInfoState(searchStatus: $searchStatus, recipe: $recipe)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeInfoStateImpl &&
            (identical(other.searchStatus, searchStatus) ||
                other.searchStatus == searchStatus) &&
            (identical(other.recipe, recipe) || other.recipe == recipe));
  }

  @override
  int get hashCode => Object.hash(runtimeType, searchStatus, recipe);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeInfoStateImplCopyWith<_$RecipeInfoStateImpl> get copyWith =>
      __$$RecipeInfoStateImplCopyWithImpl<_$RecipeInfoStateImpl>(
          this, _$identity);
}

abstract class _RecipeInfoState implements RecipeInfoState {
  const factory _RecipeInfoState(
      {required final RecipeSearchStatus searchStatus,
      final Recipe? recipe}) = _$RecipeInfoStateImpl;

  @override
  RecipeSearchStatus get searchStatus;
  @override
  Recipe? get recipe;
  @override
  @JsonKey(ignore: true)
  _$$RecipeInfoStateImplCopyWith<_$RecipeInfoStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
