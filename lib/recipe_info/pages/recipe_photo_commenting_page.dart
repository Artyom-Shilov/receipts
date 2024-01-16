import 'package:flutter/material.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/recipe_info/widgets/photo_commenting_body.dart';

class RecipePhotoCommentingPage extends StatelessWidget {
  const RecipePhotoCommentingPage({Key? key, required this.photo}) : super(key: key);

  final UserRecipePhoto photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PhotoCommentingBody(photo: photo),
    );
  }
}
