import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/recipe_info/controllers/base_heart_animation_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/heart_animation_state.dart';
import 'package:receipts/common/widgets/bookmark.dart';

class AnimatedBookmark extends HookWidget {
  const AnimatedBookmark(
      {Key? key,
      required this.height,
      required this.width,
      required this.color,
      required this.number})
      : super(key: key);

  final double height;
  final double width;
  final Color color;
  final int number;

  @override
  Widget build(BuildContext context) {
    final recipeInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    final controller = recipeInfoCubit.recipe.favouriteStatus.isFavourite
        ? useAnimationController(
            duration: const Duration(seconds: 2),
            reverseDuration: const Duration(seconds: 1),
            initialValue: 1,
          )
        : useAnimationController(
            duration: const Duration(seconds: 2),
            reverseDuration: const Duration(seconds: 1),
          );
    return BlocListener<BaseHeartAnimationCubit, HeartAnimationState>(
      listener: (context, state) {
        if (state.transitionDirection?.value == true &&
            state.isCompleted == false) {
          controller.forward();
          return;
        }
        if (state.transitionDirection?.value == false &&
            state.isCompleted == false) {
          controller.reverse();
          return;
        }
      },
      child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            return Opacity(
              opacity: controller.value,
              child: Bookmark(
                color: color,
                width: width,
                height: height,
                number: number,
              ),
            );
          }),
    );
  }
}
