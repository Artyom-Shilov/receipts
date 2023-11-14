import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/widgets/comment_row.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseCommentsCubit, CommentsState>(
      builder: (context, state) =>  SliverList.builder(
          itemCount: state.comments.length,
          itemBuilder: (context, index) {
            return CommentRow(
              comment: state.comments[index],
            );
          }),
    );
  }
}
