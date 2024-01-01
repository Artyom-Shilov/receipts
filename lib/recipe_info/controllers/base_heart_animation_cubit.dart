import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/heart_animation_state.dart';
import 'package:rive/rive.dart';

abstract interface class BaseHeartAnimationCubit extends Cubit<HeartAnimationState> {
  BaseHeartAnimationCubit(super.initialState);

  void startTransition();
  void initTransitionDirection(SMIInput<bool>? transitionDirection);
}
