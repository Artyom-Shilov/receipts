import 'package:flutter/widgets.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/navigation/controllers/nested_branch_state.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';

class AppInformationParser extends RouteInformationParser<AppNavigationState> {
  AppInformationParser(
      {required this.recipeListCubit,
      required this.favouriteRecipesCubit,
      required this.navigationCubit,
      required this.authCubit});

  final BaseRecipeListCubit recipeListCubit;
  final BaseFavouriteRecipesCubit favouriteRecipesCubit;
  final BaseNavigationCubit navigationCubit;
  final BaseAuthCubit authCubit;

  @override
  Future<AppNavigationState> parseRouteInformation(
      RouteInformation routeInformation) async {
    try {
      final segments = routeInformation.uri.pathSegments;
      if (segments.isEmpty) {
        return AppNavigationState(
            currentBranch: Branches.recipes,
            favouriteBranchState: navigationCubit.state.favouriteBranchState,
            recipeBranchState:
                const NestedBranchState(currentPage: Pages.favouriteList));
      }
      if (segments.length == 1) {
        return _firstLayerParser(segments);
      }
      if (segments.length == 2) {
        return _secondLayerParser(segments);
      }
      if (segments.length == 3) {
        return _thirdLayerParser(segments);
      }
      if (segments.length == 4) {
        return _fourthLayerParser(segments);
      }
      return AppNavigationState(
          currentBranch: Branches.pageNotFound,
          favouriteBranchState: navigationCubit.state.favouriteBranchState,
          recipeBranchState: navigationCubit.state.recipeBranchState);
    } catch (e) {
      return AppNavigationState(
          currentBranch: Branches.pageNotFound,
          favouriteBranchState: navigationCubit.state.favouriteBranchState,
          recipeBranchState: navigationCubit.state.recipeBranchState);
    }
  }

  AppNavigationState _firstLayerParser(List<String> segments) {
    final branch = Branches.fromString(segments[0]);
    if ((authCubit.isLoggedIn && branch != Branches.login) ||
        (!authCubit.isLoggedIn && branch != Branches.favourite) ||
        (!authCubit.isLoggedIn) && branch != Branches.profile) {
      return AppNavigationState(
          currentBranch: Branches.fromString(segments[0]),
          favouriteBranchState:
              const NestedBranchState(currentPage: Pages.recipeList),
          recipeBranchState:
              const NestedBranchState(currentPage: Pages.favouriteList));
    }
    return AppNavigationState(
        currentBranch: Branches.pageNotFound,
        favouriteBranchState: navigationCubit.state.favouriteBranchState,
        recipeBranchState: navigationCubit.state.recipeBranchState);
  }

  AppNavigationState _secondLayerParser(List<String> segments) {
    final branch = Branches.fromString(segments[0]);
    final index = int.parse(segments[1]);
    if (branch == Branches.recipes) {
      final recipe = recipeListCubit.recipes[index];
      return AppNavigationState(
          currentBranch: Branches.recipes,
          favouriteBranchState: navigationCubit.state.favouriteBranchState,
          recipeBranchState: NestedBranchState(
              currentPage: Pages.recipeInfo, selectedRecipe: recipe));
    }
    if (branch == Branches.favourite && authCubit.isLoggedIn) {
      final recipe = favouriteRecipesCubit.favouriteRecipes[index];
      return AppNavigationState(
          currentBranch: Branches.favourite,
          favouriteBranchState: NestedBranchState(
              currentPage: Pages.recipeInfo, selectedRecipe: recipe),
          recipeBranchState: navigationCubit.state.recipeBranchState);
    }
    return AppNavigationState(
        currentBranch: Branches.pageNotFound,
        favouriteBranchState: navigationCubit.state.favouriteBranchState,
        recipeBranchState: navigationCubit.state.recipeBranchState);
  }

  AppNavigationState _thirdLayerParser(List<String> segments) {
    final branch = Branches.fromString(segments[0]);
    final index = int.parse(segments[1]);
    if (segments[2] == Pages.camera.name) {
      if (branch == Branches.recipes) {
        final recipe = recipeListCubit.recipes[index];
        return AppNavigationState(
            currentBranch: Branches.recipes,
            favouriteBranchState: navigationCubit.state.favouriteBranchState,
            recipeBranchState: NestedBranchState(
                currentPage: Pages.camera, selectedRecipe: recipe));
      }
      if (branch == Branches.favourite && authCubit.isLoggedIn) {
        final recipe = favouriteRecipesCubit.favouriteRecipes[index];
        return AppNavigationState(
            currentBranch: Branches.favourite,
            favouriteBranchState: NestedBranchState(
                currentPage: Pages.camera, selectedRecipe: recipe),
            recipeBranchState: navigationCubit.state.recipeBranchState);
      }
    }
    if (segments[2] == RecipePhotoViewStatus.viewing.name ||
        segments[2] == RecipePhotoViewStatus.viewing.name) {
      final mode = RecipePhotoViewStatus.fromString(segments[2]);
      if (branch == Branches.recipes) {
        final recipe = recipeListCubit.recipes[index];
        return AppNavigationState(
            currentBranch: Branches.recipes,
            favouriteBranchState: navigationCubit.state.favouriteBranchState,
            recipeBranchState: NestedBranchState(
              currentPage: Pages.userPhotos,
              selectedRecipe: recipe,
              photoViewMode: mode,
            ));
      }
      if (branch == Branches.favourite && authCubit.isLoggedIn) {
        final recipe = favouriteRecipesCubit.favouriteRecipes[index];
        return AppNavigationState(
            currentBranch: Branches.favourite,
            favouriteBranchState: NestedBranchState(
              currentPage: Pages.userPhotos,
              selectedRecipe: recipe,
              photoViewMode: mode,
            ),
            recipeBranchState: navigationCubit.state.recipeBranchState);
      }
    }
    return AppNavigationState(
        currentBranch: Branches.pageNotFound,
        favouriteBranchState: navigationCubit.state.favouriteBranchState,
        recipeBranchState: navigationCubit.state.recipeBranchState);
  }

  AppNavigationState _fourthLayerParser(List<String> segments) {
    final branch = Branches.fromString(segments[0]);
    final index = int.parse(segments[1]);
    if (segments[2] == Pages.commenting_photo.name) {
      final photoIndex = int.parse(segments[3]);
      if (branch == Branches.recipes) {
        final recipe = recipeListCubit.recipes[index];
        return AppNavigationState(
            currentBranch: branch,
            favouriteBranchState: navigationCubit.state.favouriteBranchState,
            recipeBranchState: NestedBranchState(
                currentPage: Pages.commenting_photo,
                photoViewMode: RecipePhotoViewStatus.commenting,
                selectedRecipe: recipe,
                photoToComment: recipe.userPhotos[photoIndex]));
      }
      if (branch == Branches.favourite && authCubit.isLoggedIn) {
        final recipe = favouriteRecipesCubit.favouriteRecipes[index];
        return AppNavigationState(
            currentBranch: branch,
            favouriteBranchState: NestedBranchState(
                currentPage: Pages.commenting_photo,
                photoViewMode: RecipePhotoViewStatus.commenting,
                selectedRecipe: recipe,
                photoToComment: recipe.userPhotos[photoIndex]),
            recipeBranchState: navigationCubit.state.recipeBranchState);
      }
    }
    if (segments[2] == Pages.carousel.name) {
      final initIndex = int.parse(segments[3]);
      if (branch == Branches.recipes) {
        final recipe = recipeListCubit.recipes[index];
        return AppNavigationState(
            currentBranch: branch,
            favouriteBranchState: navigationCubit.state.favouriteBranchState,
            recipeBranchState: NestedBranchState(
                currentPage: Pages.commenting_photo,
                photoViewMode: RecipePhotoViewStatus.viewing,
                selectedRecipe: recipe,
                initIndexInCarousel: initIndex));
      }
      if (branch == Branches.favourite && authCubit.isLoggedIn) {
        final recipe = favouriteRecipesCubit.favouriteRecipes[index];
        return AppNavigationState(
            currentBranch: branch,
            favouriteBranchState: NestedBranchState(
                currentPage: Pages.commenting_photo,
                photoViewMode: RecipePhotoViewStatus.viewing,
                selectedRecipe: recipe,
                initIndexInCarousel: initIndex),
            recipeBranchState: navigationCubit.state.recipeBranchState);
      }
    }
    return AppNavigationState(
        currentBranch: Branches.pageNotFound,
        favouriteBranchState: navigationCubit.state.favouriteBranchState,
        recipeBranchState: navigationCubit.state.recipeBranchState);
  }

  @override
  RouteInformation? restoreRouteInformation(AppNavigationState configuration) {
    if (configuration.currentBranch == Branches.login) {
      return RouteInformation(uri: Uri.parse('/${Branches.login.name}'));
    }
    if (configuration.currentBranch == Branches.profile) {
      return RouteInformation(uri: Uri.parse('/${Branches.profile.name}'));
    }
    if (configuration.currentBranch == Branches.recipes) {
      _informationInNestedBranchBranch(
          configuration.recipeBranchState, Branches.recipes);
    }
    if (configuration.currentBranch == Branches.favourite) {
      _informationInNestedBranchBranch(
          configuration.favouriteBranchState, Branches.favourite);
    }
    if (configuration.currentBranch == Branches.pageNotFound) {
      return RouteInformation(uri: Uri.parse('/404'));
    }
    return null;
  }

  RouteInformation? _informationInNestedBranchBranch(
      NestedBranchState state, Branches branch) {
    if (branch == Branches.recipes && state.currentPage == Pages.recipeList) {
      return RouteInformation(uri: Uri.parse('/${Branches.recipes.name}'));
    }
    if (branch == Branches.recipes &&
        state.currentPage == Pages.favouriteList) {
      return RouteInformation(uri: Uri.parse('/${Branches.favourite.name}'));
    }
    if (state.currentPage == Pages.recipeInfo && state.selectedRecipe != null) {
      return RouteInformation(
          uri: Uri.parse('/${branch.name}/${state.selectedRecipe!.id}'));
    }
    if (state.currentPage == Pages.camera && state.selectedRecipe != null) {
      return RouteInformation(
          uri: Uri.parse('/${branch.name}'
              '/${state.selectedRecipe!.id}'
              '/${Pages.camera.name}'));
    }
    if (state.currentPage == Pages.userPhotos &&
        state.selectedRecipe != null &&
        state.photoViewMode != null) {
      return RouteInformation(
          uri: Uri.parse('/${branch.name}'
              '/${state.selectedRecipe!.id}'
              '/${state.photoViewMode}'));
    }
    if (state.currentPage == Pages.carousel &&
        state.selectedRecipe != null &&
        state.initIndexInCarousel != null) {
      return RouteInformation(
          uri: Uri.parse('/${branch.name}'
              '/${state.selectedRecipe!.id}'
              '/${Pages.carousel.name}'
              '/${state.initIndexInCarousel}'));
    }
    if (state.currentPage == Pages.commenting_photo &&
        state.selectedRecipe != null &&
        state.photoToComment != null) {
      return RouteInformation(
          uri: Uri.parse('/${branch.name}'
              '/${state.selectedRecipe!.id}'
              '/${Pages.commenting_photo.name}'
              '/${state.photoToComment!.index}'));
    }
    return null;
  }
}
