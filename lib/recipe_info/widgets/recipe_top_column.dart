import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:rive/rive.dart';

class RecipeTopColumn extends StatefulWidget {
  RecipeTopColumn({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  State<RecipeTopColumn> createState() => _RecipeTopColumnState();
}

class _RecipeTopColumnState extends State<RecipeTopColumn> {


  late final RiveAnimationController _controller;

  bool isActive = false;

  void animate() {
    setState(() {
      _controller.isActive = true;
    });
  }

  int number = 2;
  bool isPlay = true;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation('heart');
    _controller.isActive = true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                widget.recipe.name,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
           // if (BlocProvider.of<BaseAuthCubit>(context).isLoggedIn)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.isActive = true;
                  });
                },
                child: SizedBox(
                    height: 24,
                    width: 24,
                    child: RiveAnimation.asset('assets/animations/heart_1.riv', controllers: [_controller], fit: BoxFit.fill,),)
              )
          ],
        ),
        const SizedBox(height: Insets.vertical1),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.access_time, size: 16),
              Text(
                '  ${widget.recipe.duration}',
                style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.accent,
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
          GestureDetector(
            child: const Icon(
              Icons.add_a_photo,
              size: 20,
            ),
            onTap: () {
              GoRouter.of(context).go(
                  '/${AppTabs.recipes}/${RecipesRouteNames.recipe}/${widget.recipe.id}/${RecipesRouteNames.camera}',
                extra: widget.recipe,
              );
            },
          ),
        ]),
        const SizedBox(
          height: Insets.vertical1,
        ),
        LayoutBuilder(builder: (context, constraints) {
          return SizedBox(
              width: double.infinity,
              height: constraints.maxWidth < SizeBreakPoints.phoneLandscape
                  ? MediaQuery.of(context).size.longestSide * 0.25
                  : MediaQuery.of(context).size.longestSide * 0.50,
              child: Image.memory(widget.recipe.photoBytes!, fit: BoxFit.cover));
        })
      ],
    );
  }
}
