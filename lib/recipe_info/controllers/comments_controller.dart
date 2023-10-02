import 'package:flutter/cupertino.dart';
import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/recipe_info/controllers/base_comments_controller.dart';
import 'package:receipts/recipe_info/services/base_comments_service.dart';

class CommentsController with ChangeNotifier implements BaseCommentsController {

  List<Comment> _comments = [];
  final BaseCommentsService _commentsService;

  CommentsController(this._commentsService);

  @override
  Future<void> saveComment({required Recipe recipe, required Comment comment}) async {
    _commentsService.addComment(recipe, comment);
    notifyListeners();
  }

  @override
  Future<void> updateCommentsOfRecipe(Recipe recipe) async{
    _comments = await _commentsService.getComments(recipe);
    notifyListeners();
}

  @override
  List<Comment> get comments => _comments;
}