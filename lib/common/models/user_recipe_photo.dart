import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/common/models/detection.dart';

part 'user_recipe_photo.freezed.dart';

@freezed
class UserRecipePhoto with _$UserRecipePhoto {
  const factory UserRecipePhoto(
      {required Uint8List photoBites,
        @Default([]) List<Detection> detections
      }
      ) =_UserRecipePhoto;
}
