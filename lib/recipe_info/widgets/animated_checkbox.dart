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

class _AnimatedCheckboxState extends State<AnimatedCheckbox> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late TweenSequence<double> _sequence;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _controller.addStatusListener((status) {
      status == AnimationStatus.completed ? _controller.reset() : null;
    });
    _sequence = TweenSequence(
      [
        TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.5), weight: 50),
        TweenSequenceItem(tween: Tween<double>(begin: 1.5, end: 1.0), weight: 50),
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Transform.scale(
          scale: _sequence.animate(_controller).value,
          child: BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
          builder: (context, state) =>
            Checkbox(
                activeColor: AppColors.main,
                side: const BorderSide(
                    width: 2, color: AppColors.greyFont),
                value: state.recipe.steps[widget.stepIndex - 1].isDone,
                onChanged: (value) {
                  BlocProvider.of<BaseRecipeInfoCubit>(context)
                      .changeCookingStepStatus(widget.stepIndex - 1);
                    _controller.forward();
                }),
          ),
      ),
    );
  }
}
