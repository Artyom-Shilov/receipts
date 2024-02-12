import 'package:flutter_test/flutter_test.dart';
import 'package:receipts/common/local_storage/hive_recipe_client.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/network/dio_recipe_client.dart';
import 'model_converter_for_tests.dart';


void main() async {
  final networkClient = DioRecipeClient();
  final modelConverter = ModelConverterForTests(HiveRecipeClient(), networkClient);
  test('test recipe duration', () async {
    final networkRecipes = await networkClient.getRecipes();
    final appRecipes =
        await modelConverter.netRecipesToAppRecipes(networkRecipes);
    expect(appRecipes.length, greaterThan(0));
    for (final recipe in appRecipes) {
      expect(int.parse(recipe.duration), RecipeStepDurationMatcher(recipe));
    }
  });
}

class RecipeStepDurationMatcher extends Matcher {

  RecipeStepDurationMatcher(this.recipe);

  Recipe recipe;

  late final int stepsDurationSum;

  @override
  Description describe(Description description) {
    return description.add('Check if recipe duration equals sum of steps durations');
  }

  @override
  bool matches(item, Map matchState) {
    stepsDurationSum =
        recipe.steps.map((e) => int.parse(e.duration)).reduce((a, b) => a + b);
    return item == stepsDurationSum;
  }

  @override
  Description describeMismatch(dynamic item, Description mismatchDescription,
      Map matchState, bool verbose) {
    return mismatchDescription.add(''
        'Duration of recipe ${recipe.name} does not match sum duration of steps.'
        ' Expected: $item, actual: $stepsDurationSum');
  }
}