import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/base_heart_animation_cubit.dart';
import 'package:receipts/recipe_info/controllers/heart_animation_state.dart';
import 'package:rive/rive.dart';

class HeartAnimationCubit extends Cubit<HeartAnimationState> implements BaseHeartAnimationCubit {
  HeartAnimationCubit() : super(const HeartAnimationState(transitionDirection: null));

  @override
  void startTransition() {
    try {
      final direction = state.transitionDirection;
      final newValue = !direction!.value;
      direction.value = newValue;
      emit(state.copyWith(transitionDirection: direction));
    } catch (e) {
      log('heart transition error: $state');
    }
  }

  @override
  void initTransitionDirection(SMIInput<bool>? transitionDirection) {
    emit(state.copyWith(transitionDirection: transitionDirection));
  }
}