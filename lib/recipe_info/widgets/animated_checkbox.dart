import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

class AnimatedCheckbox extends HookWidget {
  const AnimatedCheckbox({Key? key, required this.stepIndex}) : super(key: key);

  final int stepIndex;

  @override
  Widget build(BuildContext context) {
    final controller =
        useAnimationController(duration: const Duration(seconds: 1));
    controller.addStatusListener((status) {
      status == AnimationStatus.completed ? controller.reset() : null;
    });
    final sequence = TweenSequence([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.5), weight: 50),
      TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1.0), weight: 50),
    ]);
    final recipeCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) => Transform.scale(
        scale: sequence.animate(controller).value,
        child: Checkbox(
            activeColor: AppColors.main,
            side: const BorderSide(width: 2, color: AppColors.greyFont),
            value: recipeCubit.recipe.steps[stepIndex - 1].isDone,
            onChanged: (value) {
              BlocProvider.of<BaseRecipeInfoCubit>(context)
                  .changeCookingStepStatus(stepIndex - 1);
              controller.forward();
            }),
      ),
    );
  }
}
