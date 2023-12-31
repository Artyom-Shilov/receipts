import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';

class CookingStepRow extends StatelessWidget {
  const CookingStepRow({Key? key, required this.step, required this.index})
      : super(key: key);

  final CookingStep step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Insets.vertical1),
      decoration: BoxDecoration(
        color: AppColors.greyBackground,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flexible(
            flex: 3,
            child: Center(
                child: Text(
              index.toString(),
              style: const TextStyle(
                  color: Color.fromRGBO(194, 194, 194, 1),
                  fontSize: 40,
                  fontWeight: FontWeight.w900),
            )),
          ),
          Expanded(
              flex: 10,
              child: Text(
                step.description,
                style: const TextStyle(
                    color: AppColors.greyFont,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              )),
          Flexible(
            flex: 3,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
                    builder: (context, state) => Checkbox(
                        activeColor: AppColors.main,
                        side: const BorderSide(
                            width: 2, color: AppColors.greyFont),
                        value: state.recipe.steps[index - 1].isDone,
                        onChanged: (value) {
                          BlocProvider.of<BaseRecipeInfoCubit>(context)
                              .changeCookingStepStatus(index - 1);
                        }),
                  ),
                  Text(
                    step.duration,
                    style: const TextStyle(
                        color: AppColors.greyFont,
                        fontSize: 13,
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
