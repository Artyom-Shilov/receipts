import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_state.dart';
import 'package:receipts/recipe_info/widgets/comment_row.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseRecipeInfoCubit, RecipeInfoState>(
      builder: (context, state) =>  SliverList.builder(
          itemCount: state.recipe.comments.length,
          itemBuilder: (context, index) {
            return CommentRow(
              comment: state.recipe.comments[index],
            );
          }),
    );
  }
}
