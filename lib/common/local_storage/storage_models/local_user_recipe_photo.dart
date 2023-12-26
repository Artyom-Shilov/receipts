import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:receipts/common/local_storage/storage_models/local_detection.dart';

part 'local_user_recipe_photo.freezed.dart';
part 'local_user_recipe_photo.g.dart';

@freezed
class LocalUserRecipePhoto with _$LocalUserRecipePhoto {
  @HiveType(typeId: 6, adapterName: 'LocalUserRecipePhotoAdapter')
  const factory LocalUserRecipePhoto(
      {
        @HiveField(0) required Uint8List photoBites,
        @HiveField(1, defaultValue: []) @Default([]) List<LocalDetection> detections
      }
      ) =_LocalUserRecipePhoto;
}
