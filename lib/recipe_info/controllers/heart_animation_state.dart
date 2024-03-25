import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:rive/rive.dart';

part 'heart_animation_state.freezed.dart';

@freezed
class HeartAnimationState with _$HeartAnimationState {
  const factory HeartAnimationState(
      {
        required SMIInput<bool>? transitionDirection,
        required bool isCompleted
      }) = _HeartAnimationState;
}
