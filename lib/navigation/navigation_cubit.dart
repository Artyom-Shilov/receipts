import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/navigation/base_navigation_cubit.dart';
import 'package:receipts/navigation/favourite_branch_state.dart';
import 'package:receipts/navigation/recipe_branch_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class NavigationCubit extends Cubit<AppNavigationState>
    implements BaseNavigationCubit {
  NavigationCubit()
      : super(const AppNavigationState(
      currentBranch: Branches.recipes,
      recipeBranchState: RecipeBranchState(),
      favouriteBranchState: FavouriteBranchState()
  ));

  @override
  int findAppBarIndexByBranch() {
    switch (state.currentBranch) {
      case Branches.recipes:
        return 0;
      case Branches.login:
        return 1;
      case Branches.profile:
        return 2;
      case Branches.favourite:
        return 1;
    }
  }

  @override
  void navigateToBranchByAppBarIndex(bool isLoggedIn, int index) {
    if (index == 0) {
      toBranch(Branches.recipes);
      return;
    }
    if (isLoggedIn) {
      if (index == 1) {
        toBranch(Branches.favourite);
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
    if (state.currentBranch == Branches.recipes) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.recipeInfo,
            selectedRecipe: recipe,
          )));
      return;
    }
    if (state.currentBranch == Branches.favourite) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.recipeInfo,
            selectedRecipe: recipe,
          )));
      return;
    }
  }

  @override
  void toCamera(Recipe recipe) {
    if (state.currentBranch == Branches.recipes) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.camera,
            selectedRecipe: recipe,
          )));
      return;
    }
    if(state.currentBranch == Branches.favourite) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.camera,
            selectedRecipe: recipe,
          )));
      return;
    }
  }

  @override
  void toPhotoCarousel(List<UserRecipePhoto> photos, int initIndex) {
    // TODO: implement toPhotoCarousel
  }

  @override
  void toPhotoCommenting(UserRecipePhoto photo, Recipe recipe) {
/*    if(state.currentBranch == Branches.recipes) {
      emit(state.copyWith(
          currentRecipeBranchPage: Pages.userPhotosGrid,
          selectedRecipeRecipeBranch: recipe,
          photoViewModeRecipeBranch: mode,
          isBranchChanged: false));
      return;
    }
    if(state.currentBranch == Branches.favourite) {
      emit(state.copyWith(
          currentFavouriteBranchPage: Pages.recipeInfo,
          selectedRecipeFavouriteBranch: recipe,
          photoViewModeFavouriteBranch: mode,
          isBranchChanged: false));
      return;
    }*/
  }

  @override
  void toUserPhotoGrid(Recipe recipe, RecipePhotoViewStatus mode) {
    if (state.currentBranch == Branches.recipes) {
      emit(
        state.copyWith(
            isBranchChanged: false,
            recipeBranchState: state.recipeBranchState.copyWith(
              currentPage: Pages.userPhotosGrid,
              selectedRecipe: recipe,
              photoViewMode: mode,
            )),
      );
      return;
    }
    if (state.currentBranch == Branches.favourite) {
      emit(
        state.copyWith(
            isBranchChanged: false,
            favouriteBranchState: state.favouriteBranchState.copyWith(
              currentPage: Pages.userPhotosGrid,
              selectedRecipe: recipe,
              photoViewMode: mode,
            )),
      );
      return;
    }
  }

  @override
  void toBranch(Branches branch) {
    emit(state.copyWith(currentBranch: branch, isBranchChanged: true));
  }

  @override
  void toRecipeList() {
    emit(state.copyWith(
        isBranchChanged: true,
        currentBranch: Branches.recipes,
        recipeBranchState: state.recipeBranchState.copyWith(
        selectedRecipe: null,
        currentPage: Pages.recipeList,
        )
    ));
  }

  @override
  void changeOnPop() {
    if (state.currentBranch == Branches.recipes) {
      _onPopRecipeBranch();
      return;
    }
    if (state.currentBranch == Branches.favourite) {
      _onPopFavouriteBranch();
      return;
    }
  }

  void _onPopRecipeBranch() {
    if (state.recipeBranchState.currentPage == Pages.recipeInfo) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.recipeList,
            selectedRecipe: null,
          )));
      return;
    }
    if (state.recipeBranchState.currentPage == Pages.camera) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
              currentPage: Pages.recipeInfo
          )));
      return;
    }
    if (state.recipeBranchState.currentPage == Pages.userPhotosGrid) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.recipeInfo,
          )));
      return;
    }
  }

  void _onPopFavouriteBranch() {
    if (state.favouriteBranchState.currentPage == Pages.recipeInfo) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.favouriteList,
            selectedRecipe: null,
          )));
      return;
    }
    if (state.favouriteBranchState.currentPage == Pages.camera) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
              currentPage: Pages.recipeInfo
          )));
      return;
    }
    if (state.favouriteBranchState.currentPage == Pages.userPhotosGrid) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.recipeInfo,
          )));
      return;
    }
  }

  @override
  bool isShowingBottomAppBar() {
    return !(state.recipeBranchState.currentPage == Pages.camera ||
        state.recipeBranchState.currentPage == Pages.userPhotosCarousel ||
        state.recipeBranchState.currentPage == Pages.userPhotoCommenting ||
        state.favouriteBranchState.currentPage == Pages.camera ||
        state.favouriteBranchState.currentPage == Pages.userPhotosCarousel ||
        state.favouriteBranchState.currentPage == Pages.userPhotoCommenting);
  }
}
