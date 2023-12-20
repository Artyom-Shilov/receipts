import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

class CommentInputField extends StatefulWidget {
  final Recipe recipe;

  const CommentInputField({Key? key, required this.recipe}) : super(key: key);

  @override
  State<CommentInputField> createState() => _CommentInputFieldState();
}

class _CommentInputFieldState extends State<CommentInputField> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textController,
      maxLines: 2,
      textInputAction: kIsWeb ? TextInputAction.search : TextInputAction.done,
      decoration: const InputDecoration(
        hintText: RecipeInfoTexts.commentInputHint,
        hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
        enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: AppColors.main)),
        focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: AppColors.main)),
        suffixIcon: Padding(
            padding: EdgeInsets.only(bottom: 15),
            child: Icon(Icons.photo, color: AppColors.main,)),
      ),
      onSubmitted: (text) {
        final user = BlocProvider.of<BaseAuthCubit>(context).state.user!;
        BlocProvider.of<BaseRecipeInfoCubit>(context).saveComment(
          Comment(
              text: text,
              user: user,
              photo: 'assets/sample_data/comment_sample_photo.png',
              datetime:
                  DateFormat('dd.MM.yyyy').format(DateTime.now()).toString()),
        );
        _textController.clear();
      },
    );
  }
}
