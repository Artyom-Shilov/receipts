import 'package:receipts/common/models/cooking_step.dart';
import 'package:receipts/common/models/ingredient.dart';

import 'comment.dart';

class Recipe {
  Recipe(
      {required this.id,
      required this.image,
      required this.title,
      required this.cookingTime,
      required this.ingredients,
      required this.steps,
      this.comments,
      });

  String id;
  String image;
  String cookingTime;
  String title;
  List<Ingredient> ingredients;
  List<CookingStep> steps;
  List<Comment>? comments;

  factory Recipe.fromJson(Map<String, dynamic> json) {
    List<dynamic> ingredientsJsonList = json['ingredients'] ?? [];
    final ingredients =
        ingredientsJsonList.map((e) => Ingredient.fromJson(e)).toList();
    List<dynamic> stepsJsonList = json['steps'] ?? [];
    final steps = stepsJsonList.map((e) => CookingStep.fromJson(e)).toList();
    return Recipe(
        id: json['id'] ?? '',
        image: json['image'] ?? '',
        title: json['title'] ?? '',
        cookingTime: json['cookingTime'] ?? '',
        ingredients: ingredients,
        steps: steps);
  }

  @override
  String toString() {
    return 'Recipe{id: $id, image: $image, cookingTime: $cookingTime, title: $title, ingredients: $ingredients, steps: $steps}';
  }
}
