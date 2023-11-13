import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/base_step_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_step_state.dart';

class StepCubit extends Cubit<RecipeStepState> implements BaseStepCubit {
  StepCubit() : super(const RecipeStepState(isDone: false));

  @override
  void changeStepStatus() {
    emit(state.copyWith(isDone: !state.isDone));
  }
}
