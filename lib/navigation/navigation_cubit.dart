import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/navigation/base_navigation_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class NavigationCubit extends Cubit<AppNavigationState>
    implements BaseNavigationCubit {
  NavigationCubit()
      : super(const AppNavigationState(currentBranch: Branches.recipeList));

  @override
  int findAppBarIndexByBranch() {
    switch (state.currentBranch) {
      case Branches.recipeList:
        return 0;
      case Branches.login:
        return 1;
      case Branches.profile:
        return 2;
      case Branches.recipesFavourite:
        return 1;
    }
  }

  @override
  void navigateToBranchByAppBarIndex(bool isLoggedIn, int index) {
    if (index == 0) {
      toBranch(Branches.recipeList);
      return;
    }
    if (isLoggedIn) {
      if (index == 1) {
        toBranch(Branches.recipesFavourite);
        return;
      }
      if (index == 2) {
        toBranch(Branches.profile);
        return;
      }
    } else {
      toBranch(Branches.login);
    }
  }

  @override
  void toRecipeInfo(Recipe recipe) {
    emit(state.copyWith(
        currentPage: Pages.recipeInfo,
        selectedRecipe: recipe,
        isBranchChanged: false));
  }

  @override
  void toCamera(Recipe recipe) {
    emit(state.copyWith(
        currentPage: Pages.camera,
        selectedRecipe: recipe,
        isBranchChanged: false
    ));
  }

  @override
  void toPhotoCarousel(List<UserRecipePhoto> photos, int initIndex) {
    // TODO: implement toPhotoCarousel
  }

  @override
  void toPhotoCommenting(UserRecipePhoto photo) {
    // TODO: implement toPhotoCommenting
  }

  @override
  void toUserPhotoGrid(Recipe recipe, RecipePhotoViewStatus mode) {
    // TODO: implement toUserPhotoGrid
  }

  @override
  void changeStateOnPop() {
    emit(state.copyWith(isBranchChanged: false));
    switch (state.currentPage!) {
      case Pages.recipeInfo:
        emit(state.copyWith(currentPage: null));
      case Pages.camera:
        emit(state.copyWith(currentPage: Pages.recipeInfo));
      case Pages.userPhotosGrid:
        emit(state.copyWith(currentPage: Pages.recipeInfo));
      case Pages.userPhotosCarousel:
        emit(state.copyWith(currentPage: Pages.userPhotosGrid));
      case Pages.userPhotoCommenting:
        emit(state.copyWith(currentPage: Pages.userPhotosGrid));
      case Pages.registration : emit(state.copyWith(currentPage: null));
    }
  }

  @override
  void toBranch(Branches branch) {
    emit(state.copyWith(currentBranch: branch, isBranchChanged: true));
  }

  @override
  void toRecipeList() {
    emit(state.copyWith(currentBranch: Branches.recipeList, selectedRecipe: null, currentPage: null));
  }

  @override
  void toLogin() {
    // TODO: implement toLogin
  }

  @override
  void toRegistration() {
    emit(state.copyWith(currentBranch: Branches.login, currentPage: Pages.registration));
  }
}
