import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/authentication/pages/auth_screen.dart';
import 'package:receipts/navigation/recipe_branch_page.dart';
import 'package:receipts/navigation/favourite_branch_page.dart';
import 'package:receipts/profile/profile_screen.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_cubit.dart';
import 'package:receipts/camera/pages/camera_global_screen.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/favourite/pages/favourite_screen.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/navigation/base_navigation_cubit.dart';
import 'package:receipts/navigation/transition_delegate.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_photo_view_cubit.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_cubit.dart';
import 'package:receipts/recipe_info/pages/pages.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';
import 'package:receipts/recipes_list/pages/recipes_screen.dart';

import 'custom_page.dart';

class AppRouterDelegate extends RouterDelegate
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<BaseNavigationCubit>(context);
    return BlocBuilder<BaseNavigationCubit, AppNavigationState>(
        builder: (context, state) {
          return Navigator(
          transitionDelegate: CustomTransitionDelegate(state.isBranchChanged),
          key: navigatorKey,
          pages: [
            if (state.currentBranch == Branches.recipes) ...[
              if (state.recipeBranchState.currentPage == Pages.recipeList
              || state.recipeBranchState.currentPage == Pages.recipeInfo
              || state.recipeBranchState.currentPage == Pages.camera
              || state.recipeBranchState.currentPage == Pages.userPhotosGrid
              )
                const MaterialPage(child: RecipesScreen()),
              if ((state.recipeBranchState.currentPage == Pages.recipeInfo ||
                  state.recipeBranchState.currentPage == Pages.camera ||
                  state.recipeBranchState.currentPage == Pages.userPhotosGrid) &&
                  state.recipeBranchState.selectedRecipe != null)
                RecipeBranchPage(
                  forward: Transitions.slide,
                  back: Transitions.fade,
                  child: RecipeInfoScreen(recipe: state.recipeBranchState.selectedRecipe!)),
              if (state.recipeBranchState.currentPage == Pages.camera &&
                  state.recipeBranchState.selectedRecipe != null)
                RecipeBranchPage(
                    forward: Transitions.slide,
                    back: Transitions.fade,
                    child: BlocProvider<BaseCameraCubit>(
                        create: (context) => CameraCubit(
                            recipe: navigationCubit.state.recipeBranchState.selectedRecipe!,
                            repository:
                                GetIt.instance.get<BaseRecipeRepository>()),
                        child: const CameraGlobalScreen())),
              if(state.recipeBranchState.currentPage == Pages.userPhotosGrid &&
                  state.recipeBranchState.selectedRecipe != null &&
                  state.recipeBranchState.photoViewMode != null)
                RecipeBranchPage(
                    forward: Transitions.slide,
                    back: Transitions.fade,
                    child: BlocProvider<BaseRecipePhotoViewCubit>(
                        create: (context) => RecipePhotoViewCubit(
                            status: state.recipeBranchState.photoViewMode!,
                            recipe: navigationCubit.state.recipeBranchState.selectedRecipe!,
                            recipeRepository:
                            GetIt.instance.get<BaseRecipeRepository>()),
                        child: const RecipePhotoGridPage()))
            ] else if (state.currentBranch == Branches.login) ...[
                const MaterialPage(child: AuthScreen()),
            ] else if (state.currentBranch == Branches.favourite) ...[
              if (state.favouriteBranchState.currentPage == Pages.favouriteList
                  || state.favouriteBranchState.currentPage == Pages.recipeInfo
                  || state.favouriteBranchState.currentPage == Pages.camera
                  || state.favouriteBranchState.currentPage == Pages.userPhotosGrid
              )
                const MaterialPage(child: FavouriteScreen()),
              if ((state.favouriteBranchState.currentPage == Pages.recipeInfo
                  || state.favouriteBranchState.currentPage == Pages.camera
                  ||state.favouriteBranchState.currentPage == Pages.userPhotosGrid)
                  && state.favouriteBranchState.selectedRecipe != null)
                FavouriteBranchPage(
                  forward: Transitions.slide,
                  back: Transitions.fade,
                  child: RecipeInfoScreen(recipe: state.favouriteBranchState.selectedRecipe!)),
              if (state.favouriteBranchState.currentPage == Pages.camera &&
                  navigationCubit.state.favouriteBranchState.selectedRecipe != null)
                FavouriteBranchPage(
                    forward: Transitions.slide,
                    back: Transitions.fade,
                    child: BlocProvider<BaseCameraCubit>(
                        create: (context) => CameraCubit(
                            recipe: state.favouriteBranchState.selectedRecipe!,
                            repository:
                            GetIt.instance.get<BaseRecipeRepository>()),
                        child: const CameraGlobalScreen())),
              if(state.favouriteBranchState.currentPage == Pages.userPhotosGrid &&
                  state.favouriteBranchState.selectedRecipe != null &&
                  state.favouriteBranchState.photoViewMode != null)
                FavouriteBranchPage(
                    forward: Transitions.slide,
                    back: Transitions.fade,
                    child: BlocProvider<BaseRecipePhotoViewCubit>(
                        create: (context) => RecipePhotoViewCubit(
                            status: state.favouriteBranchState.photoViewMode!,
                            recipe: state.favouriteBranchState.selectedRecipe!,
                            recipeRepository:
                            GetIt.instance.get<BaseRecipeRepository>()),
                        child: const RecipePhotoGridPage()))
            ] else if (state.currentBranch == Branches.profile) ...[
                const MaterialPage(child: ProfileScreen())
            ]
          ],
          onPopPage: (route, result) {
                navigationCubit.changeOnPop();
                return route.didPop(result);
              });
        });
  }

  final _key = GlobalKey<NavigatorState>();

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _key;

  @override
  Future<void> setNewRoutePath(configuration) {
    // TODO: implement setNewRoutePath
    throw UnimplementedError();
  }
}
