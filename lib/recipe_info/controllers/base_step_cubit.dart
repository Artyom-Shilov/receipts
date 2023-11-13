import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/recipe_step_state.dart';

abstract interface class BaseStepCubit extends Cubit<RecipeStepState> {
  BaseStepCubit(super.initialState);

  void changeStepStatus();
}
