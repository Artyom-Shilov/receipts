import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'user_recipe_photo.freezed.dart';
part 'user_recipe_photo.g.dart';

@freezed
class UserRecipePhoto with _$UserRecipePhoto {
  @HiveType(typeId: 4, adapterName: 'UserRecipePhotoAdapter')
  const factory UserRecipePhoto({@HiveField(0) required Uint8List photoBites}) =
      _UserRecipePhoto;
}
