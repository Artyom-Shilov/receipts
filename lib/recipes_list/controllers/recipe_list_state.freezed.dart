// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

/// @nodoc
mixin _$RecipeListState {
  RecipeListLoadingStatus get loadingStatus =>
      throw _privateConstructorUsedError;
  List<Recipe> get recipes => throw _privateConstructorUsedError;
  String get message => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeListStateCopyWith<RecipeListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeListStateCopyWith<$Res> {
  factory $RecipeListStateCopyWith(
          RecipeListState value, $Res Function(RecipeListState) then) =
      _$RecipeListStateCopyWithImpl<$Res, RecipeListState>;
  @useResult
  $Res call(
      {RecipeListLoadingStatus loadingStatus,
      List<Recipe> recipes,
      String message});
}

/// @nodoc
class _$RecipeListStateCopyWithImpl<$Res, $Val extends RecipeListState>
    implements $RecipeListStateCopyWith<$Res> {
  _$RecipeListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? recipes = null,
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as RecipeListLoadingStatus,
      recipes: null == recipes
          ? _value.recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeListStateImplCopyWith<$Res>
    implements $RecipeListStateCopyWith<$Res> {
  factory _$$RecipeListStateImplCopyWith(_$RecipeListStateImpl value,
          $Res Function(_$RecipeListStateImpl) then) =
      __$$RecipeListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {RecipeListLoadingStatus loadingStatus,
      List<Recipe> recipes,
      String message});
}

/// @nodoc
class __$$RecipeListStateImplCopyWithImpl<$Res>
    extends _$RecipeListStateCopyWithImpl<$Res, _$RecipeListStateImpl>
    implements _$$RecipeListStateImplCopyWith<$Res> {
  __$$RecipeListStateImplCopyWithImpl(
      _$RecipeListStateImpl _value, $Res Function(_$RecipeListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? loadingStatus = null,
    Object? recipes = null,
    Object? message = null,
  }) {
    return _then(_$RecipeListStateImpl(
      loadingStatus: null == loadingStatus
          ? _value.loadingStatus
          : loadingStatus // ignore: cast_nullable_to_non_nullable
              as RecipeListLoadingStatus,
      recipes: null == recipes
          ? _value._recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<Recipe>,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$RecipeListStateImpl implements _RecipeListState {
  const _$RecipeListStateImpl(
      {required this.loadingStatus,
      required final List<Recipe> recipes,
      this.message = ''})
      : _recipes = recipes;

  @override
  final RecipeListLoadingStatus loadingStatus;
  final List<Recipe> _recipes;
  @override
  List<Recipe> get recipes {
    if (_recipes is EqualUnmodifiableListView) return _recipes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recipes);
  }

  @override
  @JsonKey()
  final String message;

  @override
  String toString() {
    return 'RecipeListState(loadingStatus: $loadingStatus, recipes: $recipes, message: $message)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeListStateImpl &&
            (identical(other.loadingStatus, loadingStatus) ||
                other.loadingStatus == loadingStatus) &&
            const DeepCollectionEquality().equals(other._recipes, _recipes) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, loadingStatus,
      const DeepCollectionEquality().hash(_recipes), message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeListStateImplCopyWith<_$RecipeListStateImpl> get copyWith =>
      __$$RecipeListStateImplCopyWithImpl<_$RecipeListStateImpl>(
          this, _$identity);
}

abstract class _RecipeListState implements RecipeListState {
  const factory _RecipeListState(
      {required final RecipeListLoadingStatus loadingStatus,
      required final List<Recipe> recipes,
      final String message}) = _$RecipeListStateImpl;

  @override
  RecipeListLoadingStatus get loadingStatus;
  @override
  List<Recipe> get recipes;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$RecipeListStateImplCopyWith<_$RecipeListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
