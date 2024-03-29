import 'package:freezed_annotation/freezed_annotation.dart';

part 'detection.freezed.dart';
part 'detection.g.dart';


@freezed
class Detection with _$Detection {
  const factory Detection({
    required double x,
    required double y,
    required double width,
    required double height,
    required String detectedClass,
    required String confidence,
  }) = _Detection;

  factory Detection.fromJson(Map<String, dynamic> json) =>
      _$DetectionFromJson(json);
}
