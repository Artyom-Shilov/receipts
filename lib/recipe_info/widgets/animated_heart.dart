import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/recipe_info/controllers/base_heart_animation_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/heart_animation_cubit.dart';
import 'package:rive/rive.dart';

class AnimatedHeart extends StatefulWidget {
  const AnimatedHeart({Key? key}) : super(key: key);

  @override
  State<AnimatedHeart> createState() => _AnimatedHeartState();
}

class _AnimatedHeartState extends State<AnimatedHeart> {


  @override
  Widget build(BuildContext context) {
    final recipeInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    return  BlocProvider<BaseHeartAnimationCubit>(
      create: (context) => HeartAnimationCubit(),
      child: Builder(
        builder: (context) {
          final heartAnimationCubit = BlocProvider.of<BaseHeartAnimationCubit>(context);
          return GestureDetector(
              onTap: () async {
                await recipeInfoCubit.changeFavouriteStatus();
                heartAnimationCubit.startTransition();
              },
              child: SizedBox(
                height: 24,
                width: 24,
                child: Builder(
                  builder: (context) {
                    return RiveAnimation.asset(
                      'assets/animations/heart_6.riv',
                      fit: BoxFit.fill,
                      onInit: (artBoard) {
                        final controller = StateMachineController.fromArtboard(artBoard, 'state');
                        artBoard.addController(controller!);
                        final initAnimationState = controller.findInput<bool>('isInitFavourite');
                        initAnimationState?.value = recipeInfoCubit.isFavourite;
                        final direction = controller.findInput<bool>('isFavourite');
                        direction?.value = recipeInfoCubit.isFavourite;
                        heartAnimationCubit.initTransitionDirection(direction);
                      },
                    );
                  }
                ),
              ));
        }
      ),
    );
  }
}
