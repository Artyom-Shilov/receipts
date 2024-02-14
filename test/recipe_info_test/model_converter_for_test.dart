import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/network_models/network_models.dart';
import 'package:receipts/common/network/network_models/network_recipe.dart';
import 'package:receipts/common/repositories/model_converter.dart';

class ModelConverterForTests extends ModelsConverter {
  ModelConverterForTests(super.storageRecipeClient, super.networkRecipeClient);

  @override
  Future<CookingStep> netCookingStepToAppCookingStep(
      RecipeStepLink stepLink) async {
    final loadedStep = await networkClient.getRecipeStepById(stepLink.step.id);
    return CookingStep(
        id: loadedStep.id,
        number: stepLink.number.toString(),
        description: loadedStep.name,
        duration: loadedStep.duration.toString());
  }

  @override
  Future<List<Recipe>> netRecipesToAppRecipes(List<NetworkRecipe> networkRecipes) async {
    List<Recipe> recipes = [];
    final netIngredientsLinks = await networkClient.getRecipeIngredientsLinks();
    final netStepLinks = await networkClient.getRecipeStepLinks();
    final netFavourites = await networkClient.getFavourites();
    for (final networkRecipe in networkRecipes) {
      final steps = <CookingStep>[];
      final ingredients = <Ingredient>[];
      final likesNumber = netFavourites.where((element) => element.recipe.id == networkRecipe.id).length;
      final filteredNetIngredientsLinks = netIngredientsLinks
          .where((element) => element.recipe.id == networkRecipe.id);
      final filteredNetStepLinks =
      netStepLinks.where((element) => element.recipe.id == networkRecipe.id);
      for (final netStepLink in filteredNetStepLinks) {
        steps.add(await netCookingStepToAppCookingStep(netStepLink));
      }
      for (final netIngredientLink in filteredNetIngredientsLinks) {
        ingredients.add(await netIngredientToAppIngredient(netIngredientLink));
      }
      final photoBytes = await networkClient.getImage(networkRecipe.photo);
      final List<UserRecipePhoto> userPhotos = [];
      final List<bool> localDoneStatuses = [];
      if (localDoneStatuses.length == steps.length && steps.isNotEmpty) {
        for (int i = 0; i < localDoneStatuses.length; i++) {
          steps[i] = steps[i].copyWith(isDone: localDoneStatuses[i]);
        }
      }
      recipes.add(Recipe(
        id: networkRecipe.id,
        name: networkRecipe.name,
        duration: '${networkRecipe.duration}',
        steps: steps,
        ingredients: ingredients,
        photoBytes: photoBytes,
        comments: [],
        userPhotos: userPhotos,
        likesNumber: likesNumber,
      ));
    }
    return recipes;
  }
}