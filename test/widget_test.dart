// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/local_storage/hive_recipe_client.dart';
import 'package:receipts/common/network/dio_recipe_client.dart';
import 'package:receipts/recipe_info/pages/pages.dart';
import 'package:receipts/recipe_info/widgets/widgets.dart';
import 'recipe_info_test/model_converter_for_test.dart';
import 'recipe_info_test/tested_recipe_info_screen.dart';

void main() async {
  final networkClient = DioRecipeClient();
  final modelConverter =
      ModelConverterForTests(HiveRecipeClient(), networkClient);
  final networkRecipes = await networkClient.getRecipes();
  final appRecipes =
      await modelConverter.netRecipesToAppRecipes(networkRecipes);
  final testedRecipe = appRecipes[0];

  testWidgets('widget display test', (WidgetTester tester) async {
    expect(appRecipes.length, greaterThan(0));
    await tester.pumpWidget(TestedRecipeInfoScreen(recipe: testedRecipe));
    await tester.pumpAndSettle();
    expect(find.text(testedRecipe.name, skipOffstage: false), findsOneWidget);
    expect(find.byType(AnimatedHeart, skipOffstage: false), findsOneWidget);
    expect(
        find.text(testedRecipe.duration, skipOffstage: false), findsOneWidget);
    expect(
        find.image(Image.memory(testedRecipe.photoBytes).image,
            skipOffstage: false),
        findsOneWidget);
    expect(find.byType(IngredientsCard, skipOffstage: false), findsOneWidget);
    expect(find.byType(CommentInputField, skipOffstage: false), findsOneWidget);
    expect(find.text(RecipeInfoTexts.startCookingButton, skipOffstage: false),
        findsOneWidget);
    for (final ingredient in testedRecipe.ingredients) {
      final ingredientNameFinder = find.descendant(
          of: find.byType(IngredientsCard, skipOffstage: false),
          matching: find.textContaining(ingredient.name, skipOffstage: false));
      expect(ingredientNameFinder, findsOneWidget);
      final ingredientMeasureFinder = find.descendant(
          of: find.byType(IngredientsCard, skipOffstage: false),
          matching: find.textContaining(
              ingredient.count == '0'
                  ? ingredient.measureUnit
                  : '${ingredient.count} ${ingredient.measureUnit}',
              skipOffstage: false));
      expect(ingredientMeasureFinder, findsAtLeastNWidgets(1));
    }
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpAndSettle();
    expect(find.byType(CookingStepRow, skipOffstage: false).evaluate().length,
        testedRecipe.steps.length);
    for (final step in testedRecipe.steps) {
      expect(find.text(step.description, skipOffstage: false), findsOneWidget);
      expect(find.text(step.duration, skipOffstage: false),
          findsAtLeastNWidgets(1));
    }
  });

  testWidgets('favourite switch button test', (WidgetTester tester) async {
    await tester.pumpWidget(TestedRecipeInfoScreen(recipe: testedRecipe));
    await tester.pumpAndSettle();
    final opacityOnStart = (find
            .descendant(
                of: find.byType(AnimatedBookmark, skipOffstage: false),
                matching: find.byType(Opacity, skipOffstage: false))
            .evaluate()
            .first
            .widget as Opacity)
        .opacity;
    expect(opacityOnStart, 0.0);
    expect(
        (find.byType(RecipePage).evaluate().first.widget as RecipePage)
            .recipe
            .favouriteStatus
            .isFavourite,
        false);
    await tester.tap(find.byType(AnimatedHeart, skipOffstage: false));
    await tester.pumpAndSettle();
    final opacityOnFinish = (find
            .descendant(
                of: find.byType(AnimatedBookmark, skipOffstage: false),
                matching: find.byType(Opacity, skipOffstage: false))
            .evaluate()
            .first
            .widget as Opacity)
        .opacity;
    expect(opacityOnFinish, 1.0);
    expect(
        (find.byType(RecipePage).evaluate().first.widget as RecipePage)
            .recipe
            .favouriteStatus
            .isFavourite,
        true);
  });

  testWidgets('step switch test', (WidgetTester tester) async {
    const key = ValueKey('stepCheckBox_1');
    await tester.pumpWidget(TestedRecipeInfoScreen(recipe: testedRecipe));
    tester.binding.window.physicalSizeTestValue = const Size(1000, 4000);
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    await tester.pumpAndSettle();
    expect((find.byKey(key, skipOffstage: false).evaluate().first.widget as Checkbox).value,
        false);
    expect((find.byType(RecipePage).evaluate().first.widget as RecipePage)
        .recipe.steps[0].isDone,
        false);
    await tester.tap(find.byKey(key, skipOffstage: false));
    await tester.pumpAndSettle();
    expect((find.byType(RecipePage).evaluate().first.widget as RecipePage)
        .recipe.steps[0].isDone,
        true);
    expect((find.byKey(key, skipOffstage: false).evaluate().first.widget as Checkbox).value,
        true);
  });
}
