import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_heart_animation_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:rive/rive.dart';

class AnimatedHeart extends HookWidget {
  const AnimatedHeart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    late StateMachineController controller;
    useEffect(() {
      return () => controller.dispose();
    });
    final recipeInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    final heartAnimationCubit =
        BlocProvider.of<BaseHeartAnimationCubit>(context);
    final authCubit = BlocProvider.of<BaseAuthCubit>(context);
    return GestureDetector(
        onTap: () async {
          await recipeInfoCubit.changeFavouriteStatus(
              recipe: recipeInfoCubit.recipe, user: authCubit.currentUser!);
          heartAnimationCubit.startTransition();
        },
        child: RepaintBoundary(
          child: SizedBox(
            height: 24,
            width: 24,
            child: Builder(builder: (context) {
              return RiveAnimation.asset(
                'assets/animations/heart_9.riv',
                fit: BoxFit.fill,
                onInit: (artBoard) {
                  controller =
                      StateMachineController.fromArtboard(artBoard, 'state')!;
                  artBoard.addController(controller);
                  final initAnimationState =
                      controller.findInput<bool>('isInitFavourite');
                  initAnimationState?.value = recipeInfoCubit.isFavourite;
                  final direction = controller.findInput<bool>('isFavourite');
                  direction?.value = recipeInfoCubit.isFavourite;
                  heartAnimationCubit.initTransitionDirection(direction);
                  controller.addEventListener((event) {
                    event.name == 'endMark'
                        ? heartAnimationCubit
                            .setIsCompleted(event.properties['isEnded'])
                        : null;
                  });
                },
              );
            }),
          ),
        ));
  }
}
