import 'package:intl/intl.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/local_storage/base_storage_recipe_client.dart';
import 'package:receipts/common/local_storage/storage_models/storage_models.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/network/network_models/network_comment.dart';
import 'package:receipts/common/network/network_models/network_models.dart';
import 'package:receipts/common/util/util_logic.dart';

class ModelsConverter {
  const ModelsConverter(BaseStorageRecipeClient storageRecipeClient,
      BaseNetworkRecipeClient networkRecipeClient)
      : storageClient = storageRecipeClient,
        networkClient = networkRecipeClient;

  final BaseStorageRecipeClient storageClient;
  final BaseNetworkRecipeClient networkClient;

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
        isDone: localCookingStep.isDone,
        duration: localCookingStep.duration);
  }

  LocalCookingStep appStepToLocalStep(CookingStep cookingStep) {
    return LocalCookingStep(
        id: cookingStep.id,
        number: cookingStep.number,
        description: cookingStep.description,
        duration: cookingStep.duration,
        isDone: cookingStep.isDone);
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
      index: localPhoto.index,
      detections: appDetections,
    );
  }

  LocalUserRecipePhoto appRecipePhotoToLocalRecipePhoto(
      UserRecipePhoto appPhoto) {
    final localDetections = appPhoto.detections
        .map((e) => appDetectionToLocalDetection(e))
        .toList();
    return LocalUserRecipePhoto(
        photoBites: appPhoto.photoBites, detections: localDetections, index: appPhoto.index);
  }

  Recipe localRecipeToAppRecipe(LocalRecipe localRecipe) {
    final ingredients = localRecipe.ingredients
        .map((e) => localIngredientToAppIngredient(e))
        .toList();
    final steps = localRecipe.steps.map((e) => localStepToAppStep(e)).toList();
    final userPhotos = localRecipe.userPhotos
        .map((e) => localRecipePhotoToAppRecipePhoto(e))
        .toList();
    return Recipe(
        id: localRecipe.id,
        name: localRecipe.name,
        duration: localRecipe.duration,
        ingredients: ingredients,
        photoBytes: localRecipe.photoBytes,
        steps: steps,
        comments: [],
        userPhotos: userPhotos,
        likesNumber: localRecipe.likesNumber,
    );
  }

  LocalRecipe appRecipeToLocalRecipe(Recipe recipe) {
    final localIngredients = recipe.ingredients
        .map((e) => appIngredientToLocalIngredient(e))
        .toList();
    final localSteps = recipe.steps.map((e) => appStepToLocalStep(e)).toList();
    final userPhotos = recipe.userPhotos
        .map((e) => appRecipePhotoToLocalRecipePhoto(e))
        .toList();
    return LocalRecipe(
        id: recipe.id,
        name: recipe.name,
        duration: recipe.duration,
        ingredients: localIngredients,
        steps: localSteps,
        photoBytes: recipe.photoBytes,
        userPhotos: userPhotos,
        likesNumber: recipe.likesNumber
    );
  }

  Future<CookingStep> netCookingStepToAppCookingStep(
      RecipeStepLink stepLink) async {
    final loadedStep = await networkClient.getRecipeStepById(stepLink.step.id);
    final formattedDuration = DateFormat('mm:ss').format(
        DateTime.fromMillisecondsSinceEpoch(
            Duration(minutes: loadedStep.duration).inMilliseconds));
    return CookingStep(
        id: loadedStep.id,
        number: stepLink.number.toString(),
        description: loadedStep.name,
        duration: formattedDuration);
  }

  Future<Ingredient> netIngredientToAppIngredient(
      RecipeIngredientLink ingredientLink) async {
    final loadedIngredient =
        await networkClient.getIngredientById(ingredientLink.ingredient.id);
    final loadedMeasureUnit = await networkClient
        .getMeasureUnitById(loadedIngredient.measureUnit.id);
    return Ingredient(
        id: loadedIngredient.id,
        count: ingredientLink.count.toString(),
        name: loadedIngredient.name,
        measureUnit: calcMeasureUnit(ingredientLink.count, loadedMeasureUnit));
  }

  Future<Comment> netCommentToAppComment(NetworkComment networkComment) async {
    final networkUser = await networkClient.getUserById(networkComment.user.id);
    return Comment(
        text: networkComment.text,
        photo: UtilLogic.stringToUInt8List(networkComment.photo),
        datetime: DateFormat('dd.MM.yyyy').format(DateTime.parse(networkComment.datetime)),
        user: _netUserToAppUser(networkUser),
        id: networkComment.id
    );
  }

  User _netUserToAppUser(NetworkUser networkUser) {
    return User(
        id: networkUser.id,
        login: networkUser.login,
        token: networkUser.token,
        password: networkUser.password,
        avatar: UtilLogic.stringToUInt8List(networkUser.avatar)
    );
  }

  String calcMeasureUnit(int count, NetworkMeasureUnit unit) {
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

  String calcRecipeDurationForm(int duration) {
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
      final userPhotos = (await storageClient
              .getLocalUserRecipePhotosByRecipeId(networkRecipe.id))
          .map((e) => localRecipePhotoToAppRecipePhoto(e))
          .toList();
      final localDoneStatuses = await storageClient.getDoneStatusesByRecipeId(networkRecipe.id);
      if (localDoneStatuses.length == steps.length && steps.isNotEmpty) {
        for (int i = 0; i < localDoneStatuses.length; i++) {
          steps[i] = steps[i].copyWith(isDone: localDoneStatuses[i]);
        }
      }
      recipes.add(Recipe(
          id: networkRecipe.id,
          name: networkRecipe.name,
          duration:
              '${networkRecipe.duration} ${calcRecipeDurationForm(networkRecipe.duration)}',
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
