import 'package:bloc/bloc.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/models/user_recipe_photo.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/navigation/controllers/nested_branch_state.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class NavigationCubit extends Cubit<AppNavigationState>
    implements BaseNavigationCubit {
  NavigationCubit()
      : super(const AppNavigationState(
      currentBranch: Branches.recipes,
      recipeBranchState: NestedBranchState(currentPage: Pages.recipeList),
      favouriteBranchState: NestedBranchState(currentPage: Pages.favouriteList)
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
      case Branches.pageNotFound:
        return 0;
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
  void toPhotoCarousel(Recipe recipe, int initIndex) {
    if(state.currentBranch == Branches.recipes) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.carousel,
            selectedRecipe: recipe,
            initIndexInCarousel: initIndex
          )));
      return;
    }
    if(state.currentBranch == Branches.favourite) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
              currentPage: Pages.carousel,
              selectedRecipe: recipe,
              initIndexInCarousel: initIndex
          )));
      return;
    }
  }

  @override
  void toPhotoCommenting(UserRecipePhoto photo, Recipe recipe) {
    if(state.currentBranch == Branches.recipes) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.commenting_photo,
            photoToComment: photo,
          )
      ));
      return;
    }
    if(state.currentBranch == Branches.favourite) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.commenting_photo,
            photoToComment: photo,
          )
      ));
      return;
    }
  }

  @override
  void toUserPhotoGrid(Recipe recipe, RecipePhotoViewStatus mode) {
    if (state.currentBranch == Branches.recipes) {
      emit(
        state.copyWith(
            isBranchChanged: false,
            recipeBranchState: state.recipeBranchState.copyWith(
              currentPage: Pages.userPhotos,
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
              currentPage: Pages.userPhotos,
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
  void toLogin() {
    emit(state.copyWith(isBranchChanged: true, currentBranch: Branches.login));
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
    if (state.recipeBranchState.currentPage == Pages.userPhotos) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.recipeInfo,
          )));
      return;
    }
    if (state.recipeBranchState.currentPage == Pages.carousel) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.recipeBranchState.copyWith(
            currentPage: Pages.userPhotos,
            initIndexInCarousel: null,
          )));
      return;
    }
    if (state.recipeBranchState.currentPage == Pages.commenting_photo) {
      emit(state.copyWith(
          isBranchChanged: false,
          recipeBranchState: state.favouriteBranchState.copyWith(
              currentPage: Pages.userPhotos,
              photoToComment: null
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
    if (state.favouriteBranchState.currentPage == Pages.userPhotos) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.recipeInfo,
          )));
      return;
    }
    if (state.favouriteBranchState.currentPage == Pages.carousel) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.userPhotos,
            initIndexInCarousel: null,
          )));
      return;
    }
    if (state.favouriteBranchState.currentPage == Pages.commenting_photo) {
      emit(state.copyWith(
          isBranchChanged: false,
          favouriteBranchState: state.favouriteBranchState.copyWith(
            currentPage: Pages.userPhotos,
            photoToComment: null
          )));
      return;
    }
  }

  @override
  bool isShowingBottomAppBar() {
    return !(
        state.currentBranch == Branches.pageNotFound ||
        state.recipeBranchState.currentPage == Pages.camera ||
        state.recipeBranchState.currentPage == Pages.carousel ||
        state.recipeBranchState.currentPage == Pages.commenting_photo ||
        state.favouriteBranchState.currentPage == Pages.camera ||
        state.favouriteBranchState.currentPage == Pages.carousel ||
        state.favouriteBranchState.currentPage == Pages.commenting_photo);
  }
}
