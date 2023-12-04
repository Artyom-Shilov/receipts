import 'package:freezed_annotation/freezed_annotation.dart';

part 'network_measure_unit.freezed.dart';

part 'network_measure_unit.g.dart';

@freezed
class NetworkMeasureUnit with _$NetworkMeasureUnit {
  const factory NetworkMeasureUnit({
    required int id,
    required String one,
    required String few,
    required String many,
  }) = _NetworkMeasureUnit;

  factory NetworkMeasureUnit.fromJson(Map<String, dynamic> json) =>
      _$NetworkMeasureUnitFromJson(json);
}
