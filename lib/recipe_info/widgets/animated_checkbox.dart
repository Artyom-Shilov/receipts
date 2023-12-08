import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';

class AnimatedCheckbox extends StatefulWidget {
  const AnimatedCheckbox({Key? key, required this.stepIndex}) : super(key: key);

  final int stepIndex;

  @override
  State<AnimatedCheckbox> createState() => _AnimatedCheckboxState();
}

class _AnimatedCheckboxState extends State<AnimatedCheckbox> with TickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 500), lowerBound: 1, upperBound: 1.5);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
      builder: (context, state) => Transform.scale(
        scale: 1,
        child: Checkbox(
            activeColor: AppColors.main,
            side: const BorderSide(
                width: 2, color: AppColors.greyFont),
            value: state.recipe.steps[widget.stepIndex - 1].isDone,
            onChanged: (value) {
              //_controller.forward();
              BlocProvider.of<BaseRecipeInfoCubit>(context)
                  .changeCookingStepStatus(widget.stepIndex - 1);

            /*  _controller.reverse()*/;
            }),
      ),
    );
  }
}
