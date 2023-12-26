import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/constants/size_break_points.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:rive/rive.dart';

class RecipeTopColumn extends StatefulWidget {
  const RecipeTopColumn({
    super.key,
    required this.recipe,
  });

  final Recipe recipe;

  @override
  State<RecipeTopColumn> createState() => _RecipeTopColumnState();
}

class _RecipeTopColumnState extends State<RecipeTopColumn> {

  bool isActive = false;

  late final SMIInput<bool>? _isFavouriteTransition;
  late final SMIInput<bool>? _isFavouriteInit;


  void animate() {
    setState(() {
      final value = _isFavouriteTransition!.value;
      _isFavouriteTransition?.value = !value;
    });
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final recipeInfoCubit = BlocProvider.of<BaseRecipeInfoCubit>(context);
    final authCubit = BlocProvider.of<BaseAuthCubit>(context);
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
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
             if (authCubit.isLoggedIn)
            GestureDetector(
                onTap: () async {
                  await recipeInfoCubit.changeFavouriteStatus();
                  setState(() {
                    animate();
                  });
                },
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: RiveAnimation.asset(
                    'assets/animations/heart_6.riv',
                    fit: BoxFit.fill,
                    onInit: (artboard) {
                      final controller = StateMachineController.fromArtboard(artboard, 'state');
                      artboard.addController(controller!);
                      _isFavouriteInit = controller.findInput<bool>('isInitFavourite');
                      _isFavouriteInit?.value = recipeInfoCubit.isFavourite;
                      _isFavouriteTransition = controller.findInput<bool>('isFavourite');
                      _isFavouriteTransition?.value = recipeInfoCubit.isFavourite;
                    },
                  ),
                ))
          ],
        ),
        const SizedBox(height: Insets.vertical1),
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          const Icon(Icons.access_time, size: 16),
          Text(
            '  ${widget.recipe.duration}',
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.accent,
                fontWeight: FontWeight.w400),
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
              child: Image.memory(widget.recipe.photoBytes, fit: BoxFit.cover));
        })
      ],
    );
  }
}
