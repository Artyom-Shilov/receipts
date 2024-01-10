import 'package:freezed_annotation/freezed_annotation.dart';

part 'favourite_status.freezed.dart';

@freezed
class FavouriteStatus with _$FavouriteStatus {
  const factory FavouriteStatus({required bool isFavourite, int? favouriteId}) =
      _FavouriteStatus;
}
