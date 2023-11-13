import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourite_state.freezed.dart';

@freezed
class FavouriteState with _$FavouriteState{
  const factory FavouriteState({required bool isFavourite}) = _FavouriteState;
}
