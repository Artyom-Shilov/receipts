import 'package:bloc/bloc.dart';

import 'base_recipe_step_cubit.dart';
import 'recipe_step_state.dart';

class RecipeStepCubit extends Cubit<RecipeStepState> implements BaseStepCubit {
  RecipeStepCubit() : super(const RecipeStepState(isDone: false));

  @override
  void changeStepStatus() {
    emit(state.copyWith(isDone: !state.isDone));
  }
}
