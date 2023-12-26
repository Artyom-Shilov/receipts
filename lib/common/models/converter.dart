import 'package:receipts/common/local_storage/storage_models/storage_models.dart';
import 'package:receipts/common/models/models.dart';

Ingredient localIngredientToAppIngredient(LocalIngredient localIngredient) {
  return Ingredient(
      id: localIngredient.id,
      count: localIngredient.count,
      name: localIngredient.name,
      measureUnit: localIngredient.measureUnit);
}

LocalIngredient appIngredientLocalIngredient(Ingredient ingredient) {
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
      confidence: appDetection.confidence
  );
}

Detection localDetectionToAppDetection(LocalDetection localDetection) {
  return Detection(
      x: localDetection.x,
      y: localDetection.y,
      width: localDetection.width,
      height: localDetection.height,
      detectedClass: localDetection.detectedClass,
      confidence: localDetection.confidence
  );
}

UserRecipePhoto localRecipePhotoToAppRecipePhoto(LocalUserRecipePhoto localPhoto) {
  final appDetections = localPhoto.detections.map((e) => localDetectionToAppDetection(e)).toList();
  return UserRecipePhoto(
      photoBites: localPhoto.photoBites,
      detections: appDetections,
  );
}

LocalUserRecipePhoto appRecipePhotoToLocalRecipePhoto(UserRecipePhoto appPhoto) {
  final localDetections = appPhoto.detections.map((e) => appDetectionToLocalDetection(e)).toList();
  return LocalUserRecipePhoto(
      photoBites: appPhoto.photoBites,
      detections: localDetections
  );
}

Recipe localRecipeToAppRecipe(LocalRecipe localRecipe) {
  final ingredients = localRecipe.ingredients
      .map((e) => localIngredientToAppIngredient(e))
      .toList();
  final steps = localRecipe.steps.map((e) => localStepToAppStep(e)).toList();
  final comments =
      localRecipe.comments.map((e) => localCommentToAppComment(e)).toList();
  final userPhotos = localRecipe.userPhotos.map((e) => localRecipePhotoToAppRecipePhoto(e)).toList();
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
  final localIngredients =
      recipe.ingredients.map((e) => appIngredientLocalIngredient(e)).toList();
  final localSteps = recipe.steps.map((e) => appStepToLocalStep(e)).toList();
  final localComments =
      recipe.comments.map((e) => appCommentToLocalComment(e)).toList();
  final userPhotos = recipe.userPhotos.map((e) => appRecipePhotoToLocalRecipePhoto(e)).toList();
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
