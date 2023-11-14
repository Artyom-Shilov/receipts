import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';

abstract interface class BaseCommentsService {

  Future<List<Comment>> getComments(Recipe recipe);
  Future<void> saveComment({required Comment comment, required Recipe recipe});
}