import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'local_detection.freezed.dart';
part 'local_detection.g.dart';

@freezed
class LocalDetection with _$LocalDetection {
  @HiveType(typeId: 5, adapterName: 'LocalDetectionAdapter')
  const factory LocalDetection({
    @HiveField(0) required double x,
    @HiveField(1) required double y,
    @HiveField(2) required double width,
    @HiveField(3) required double height,
    @HiveField(4) required String detectedClass,
    @HiveField(5) required String confidence,
  }) = _LocalDetection;
}
