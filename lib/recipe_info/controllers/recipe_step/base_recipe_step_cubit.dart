import 'package:bloc/bloc.dart';

import 'recipe_step_state.dart';

abstract interface class BaseStepCubit extends Cubit<RecipeStepState> {
  BaseStepCubit(super.initialState);

  void changeStepStatus();
}
