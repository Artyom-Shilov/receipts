import 'package:receipts/common/models/comment.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user.dart';

abstract interface class BaseRecipeInfoService {

  Future<Recipe> getRecipeById({required String id,  required List<Recipe> recipes});
}