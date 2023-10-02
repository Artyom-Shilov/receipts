import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/services/base_comments_service.dart';

class CommentsService implements BaseCommentsService{

  @override
  Future<List<Comment>> getComments(Recipe recipe) async {
    return recipe.comments ?? [];
  }

  @override
  Future<void> addComment(Recipe recipe, Comment comment) async {
    if (recipe.comments != null) {
      recipe.comments!.add(comment);
    } else {
      recipe.comments = [];
      recipe.comments!.add(comment);
    }
  }
}