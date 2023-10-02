import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:receipts/recipe_info/controllers/base_comments_controller.dart';
import 'package:receipts/recipe_info/widgets/comment_row.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
        itemCount: context.read<BaseCommentsController>().comments.length,
        itemBuilder: (context, index) {
          return CommentRow(
            comment: context.read<BaseCommentsController>().comments[index],
          );
        });
  }
}
