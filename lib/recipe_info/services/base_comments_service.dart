import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseCommentsService {

  Future<List<Comment>> getComments(Recipe recipe);
  Future<void> addComment(Recipe recipe, Comment comment);
}