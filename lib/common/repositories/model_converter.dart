import 'package:intl/intl.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/local_storage/storage_models/storage_models.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/network/network_models/network_models.dart';

class ModelsConverter {
  const ModelsConverter(BaseStorageRecipeClient storageRecipeClient,
      BaseNetworkRecipeClient networkRecipeClient)
      : _storageClient = storageRecipeClient,
        _networkClient = networkRecipeClient;

  final BaseStorageRecipeClient _storageClient;
  final BaseNetworkRecipeClient _networkClient;

  Ingredient localIngredientToAppIngredient(LocalIngredient localIngredient) {
    return Ingredient(
        id: localIngredient.id,
        count: localIngredient.count,
        name: localIngredient.name,
        measureUnit: localIngredient.measureUnit);
  }

  LocalIngredient appIngredientToLocalIngredient(Ingredient ingredient) {
    return LocalIngredient(
        id: ingredient.id,
        count: ingredient.count,
        name: ingredient.name,
        measureUnit: ingredient.measureUnit);
  }

  CookingStep localStepToAppStep(LocalCookingStep localCookingStep) {
    return CookingStep(
        id: localCookingStep.id,
        number: localCookingStep.number,
        description: localCookingStep.description,
        duration: localCookingStep.duration);
  }

  LocalCookingStep appStepToLocalStep(CookingStep cookingStep) {
    return LocalCookingStep(
        id: cookingStep.id,
        number: cookingStep.number,
        description: cookingStep.description,
        duration: cookingStep.duration);
  }

  Comment localCommentToAppComment(LocalComment localComment) {
    return Comment(
        text: localComment.text,
        photo: localComment.photo,
        datetime: localComment.datetime,
        user: User(
            id: localComment.user.id,
            login: localComment.user.login,
            password: '',
            token: '',
            avatar: localComment.user.avatar));
  }

  LocalComment appCommentToLocalComment(Comment comment) {
    return LocalComment(
        text: comment.text,
        photo: comment.photo,
        datetime: comment.datetime,
        user: LocalUser(
            id: comment.user.id,
            login: comment.user.login,
            avatar: comment.user.avatar));
  }

  LocalDetection appDetectionToLocalDetection(Detection appDetection) {
    return LocalDetection(
        x: appDetection.x,
        y: appDetection.y,
        width: appDetection.width,
        height: appDetection.height,
        detectedClass: appDetection.detectedClass,
        confidence: appDetection.confidence);
  }

  Detection localDetectionToAppDetection(LocalDetection localDetection) {
    return Detection(
        x: localDetection.x,
        y: localDetection.y,
        width: localDetection.width,
        height: localDetection.height,
        detectedClass: localDetection.detectedClass,
        confidence: localDetection.confidence);
  }

  UserRecipePhoto localRecipePhotoToAppRecipePhoto(
      LocalUserRecipePhoto localPhoto) {
    final appDetections = localPhoto.detections
        .map((e) => localDetectionToAppDetection(e))
        .toList();
    return UserRecipePhoto(
      photoBites: localPhoto.photoBites,
      detections: appDetections,
    );
  }

  LocalUserRecipePhoto appRecipePhotoToLocalRecipePhoto(
      UserRecipePhoto appPhoto) {
    final localDetections = appPhoto.detections
        .map((e) => appDetectionToLocalDetection(e))
        .toList();
    return LocalUserRecipePhoto(
        photoBites: appPhoto.photoBites, detections: localDetections);
  }

  Recipe localRecipeToAppRecipe(LocalRecipe localRecipe) {
    final ingredients = localRecipe.ingredients
        .map((e) => localIngredientToAppIngredient(e))
        .toList();
    final steps = localRecipe.steps.map((e) => localStepToAppStep(e)).toList();
    final comments =
        localRecipe.comments.map((e) => localCommentToAppComment(e)).toList();
    final userPhotos = localRecipe.userPhotos
        .map((e) => localRecipePhotoToAppRecipePhoto(e))
        .toList();
    return Recipe(
        id: localRecipe.id,
        name: localRecipe.name,
        duration: localRecipe.duration,
        photoUrl: localRecipe.photoUrl,
        ingredients: ingredients,
        photoBytes: localRecipe.photoBytes,
        steps: steps,
        comments: comments,
        userPhotos: userPhotos,
        isFavourite: localRecipe.isFavourite);
  }

  LocalRecipe appRecipeToLocalRecipe(Recipe recipe) {
    final localIngredients = recipe.ingredients
        .map((e) => appIngredientToLocalIngredient(e))
        .toList();
    final localSteps = recipe.steps.map((e) => appStepToLocalStep(e)).toList();
    final localComments =
        recipe.comments.map((e) => appCommentToLocalComment(e)).toList();
    final userPhotos = recipe.userPhotos
        .map((e) => appRecipePhotoToLocalRecipePhoto(e))
        .toList();
    return LocalRecipe(
        id: recipe.id,
        name: recipe.name,
        duration: recipe.duration,
        photoUrl: recipe.photoUrl,
        ingredients: localIngredients,
        steps: localSteps,
        comments: localComments,
        photoBytes: recipe.photoBytes,
        userPhotos: userPhotos,
        isFavourite: recipe.isFavourite);
  }

  Future<CookingStep> _netCookingStepToAppCookingStep(
      RecipeStepLink stepLink) async {
    final loadedStep = await _networkClient.getRecipeStepById(stepLink.step.id);
    final formattedDuration = DateFormat('mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
            Duration(minutes: loadedStep.duration).inMilliseconds));
    return CookingStep(
        id: loadedStep.id,
        number: stepLink.number.toString(),
        description: loadedStep.name,
        duration: formattedDuration);
  }

  Future<Ingredient> _netIngredientToAppIngredient(
      RecipeIngredientLink ingredientLink) async {
    final loadedIngredient =
        await _networkClient.getIngredientById(ingredientLink.ingredient.id);
    final loadedMeasureUnit = await _networkClient
        .getMeasureUnitById(loadedIngredient.measureUnit.id);
    return Ingredient(
        id: loadedIngredient.id,
        count: ingredientLink.count.toString(),
        name: loadedIngredient.name,
        measureUnit: _calcMeasureUnit(ingredientLink.count, loadedMeasureUnit));
  }

  String _calcMeasureUnit(int count, NetworkMeasureUnit unit) {
    final countEnding = count % 10;
    if (countEnding == 1) {
      return unit.one;
    }
    if (countEnding == 0) {
      return unit.many;
    }
    if (countEnding <= 4) {
      return unit.few;
    }
    return unit.many;
  }

  String _calcRecipeDurationForm(int duration) {
    final durationEnding = duration % 10;
    if (durationEnding == 1) {
      return TimeUnits.minutesOne;
    }
    if (durationEnding == 0) {
      return TimeUnits.minutesOne;
    }
    if (durationEnding <= 4) {
      return TimeUnits.minutesFew;
    }
    return TimeUnits.minutesMany;
  }

  Future<List<Recipe>> netRecipesToAppRecipes(
      List<NetworkRecipe> networkRecipes) async {
    List<Recipe> recipes = [];
    final ingredientsLinks = await _networkClient.getRecipeIngredientsLinks();
    final stepLinks = await _networkClient.getRecipeStepLinks();
    for (final networkRecipe in networkRecipes) {
      final steps = <CookingStep>[];
      final ingredients = <Ingredient>[];
      final filteredIngredientsLinks = ingredientsLinks
          .where((element) => element.recipe.id == networkRecipe.id);
      final filteredStepLinks =
          stepLinks.where((element) => element.recipe.id == networkRecipe.id);
      for (final stepLink in filteredStepLinks) {
        steps.add(await _netCookingStepToAppCookingStep(stepLink));
      }
      for (final ingredientLink in filteredIngredientsLinks) {
        ingredients.add(await _netIngredientToAppIngredient(ingredientLink));
      }
      final photoBytes = await _networkClient.getImage(networkRecipe.photo);
      final userPhotos = (await _storageClient
              .getLocalUserRecipePhotosByRecipeId(networkRecipe.id))
          .map((e) => localRecipePhotoToAppRecipePhoto(e))
          .toList();
      recipes.add(Recipe(
          id: networkRecipe.id,
          name: networkRecipe.name,
          photoUrl: networkRecipe.photo,
          duration:
              '${networkRecipe.duration} ${_calcRecipeDurationForm(networkRecipe.duration)}',
          steps: steps,
          ingredients: ingredients,
          photoBytes: photoBytes,
          comments: [],
          userPhotos: userPhotos));
    }
    return recipes;
  }
}
