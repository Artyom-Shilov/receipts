import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/authentication/pages/auth_screen.dart';
import 'package:receipts/camera/controllers/base_camera_service.dart';
import 'package:receipts/camera/controllers/base_recognition_service.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/pages/page_not_found_screen.dart';
import 'package:receipts/navigation/custom_pages/favourite_branch_page.dart';
import 'package:receipts/navigation/custom_pages/recipe_branch_page.dart';
import 'package:receipts/profile/profile_screen.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_cubit.dart';
import 'package:receipts/camera/pages/camera_global_screen.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/favourite/pages/favourite_screen.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/navigation/transition_delegate.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/pages/pages.dart';
import 'package:receipts/recipes_list/pages/recipes_screen.dart';

import 'custom_pages/custom_page.dart';

class AppRouterDelegate extends RouterDelegate<AppNavigationState>
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {

  AppRouterDelegate(this.navigationCubit);

  BaseNavigationCubit navigationCubit;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BaseNavigationCubit, AppNavigationState>(
        builder: (context, state) {
        log('branch: ${state.currentBranch}');
      return Navigator(
          transitionDelegate: CustomTransitionDelegate(state.isBranchChanged),
          key: navigatorKey,
          pages: [
            if (state.currentBranch == Branches.recipes)
              ..._recipeBranchPages(state)
            else if (state.currentBranch == Branches.login) ...[
              const MaterialPage(child: AuthScreen()),
            ] else if (state.currentBranch == Branches.favourite)
              ..._favouriteBranchPages(state)
            else if (state.currentBranch == Branches.profile) ...[
              const MaterialPage(child: ProfileScreen())
            ]
            else if (state.currentBranch == Branches.page_not_found)
              ...[
                const MaterialPage(child: PageNotFoundScreen())
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
  Future<void> setNewRoutePath(configuration) async {
    navigationCubit.onSetNewRoutePath(configuration);
  }

  @override
  AppNavigationState get currentConfiguration => navigationCubit.state;

  //We won't have information updates for BlocProvider without different classes for pages in favourite and recipe branches when scrolling branches between similar pages
  List<Page> _recipeBranchPages(AppNavigationState state) {
    return [
      if (state.recipeBranchState.currentPage == Pages.recipeList ||
          state.recipeBranchState.currentPage == Pages.recipeInfo ||
          state.recipeBranchState.currentPage == Pages.camera ||
          state.recipeBranchState.currentPage == Pages.userPhotos ||
          state.recipeBranchState.currentPage == Pages.carousel ||
          state.recipeBranchState.currentPage == Pages.commenting_photo)
        const MaterialPage(child: RecipesScreen()),
      if ((state.recipeBranchState.currentPage == Pages.recipeInfo ||
              state.recipeBranchState.currentPage == Pages.camera ||
              state.recipeBranchState.currentPage == Pages.userPhotos ||
              state.recipeBranchState.currentPage == Pages.carousel ||
              state.recipeBranchState.currentPage == Pages.commenting_photo) &&
          state.recipeBranchState.selectedRecipe != null)
        RecipeBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
                create: (context) => RecipeInfoCubit(
                    repository: GetIt.instance.get<BaseRecipeRepository>(),
                    networkClient:
                        GetIt.instance.get<BaseNetworkRecipeClient>(),
                    recipe: state.recipeBranchState.selectedRecipe!),
                child: const RecipeInfoScreen())),
      if ((state.recipeBranchState.currentPage == Pages.userPhotos ||
              state.recipeBranchState.currentPage == Pages.carousel ||
              state.recipeBranchState.currentPage == Pages.commenting_photo) &&
          state.recipeBranchState.selectedRecipe != null &&
          state.recipeBranchState.photoViewMode != null)
        RecipeBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipePhotoViewCubit>(
                create: (context) => RecipePhotoViewCubit(
                    status: state.recipeBranchState.photoViewMode!,
                    recipe: state.recipeBranchState.selectedRecipe!,
                    recipeRepository:
                        GetIt.instance.get<BaseRecipeRepository>()),
                child: const RecipePhotoGridPage())),
      if ((state.recipeBranchState.currentPage == Pages.carousel) &&
          state.recipeBranchState.selectedRecipe != null &&
          state.recipeBranchState.photoViewMode != null &&
          state.recipeBranchState.initIndexInCarousel != null)
        RecipeBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipePhotoViewCubit>(
              create: (context) => RecipePhotoViewCubit(
                  status: state.recipeBranchState.photoViewMode!,
                  recipe: state.recipeBranchState.selectedRecipe!,
                  recipeRepository: GetIt.instance.get<BaseRecipeRepository>()),
              child: RecipePhotoCarouselPage(
                  photos: state.recipeBranchState.selectedRecipe!.userPhotos,
                  initIndex: state.recipeBranchState.initIndexInCarousel!),
            )),
      if ((state.recipeBranchState.currentPage == Pages.commenting_photo) &&
          state.recipeBranchState.selectedRecipe != null &&
          state.recipeBranchState.photoViewMode != null &&
          state.recipeBranchState.photoToComment != null)
        RecipeBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
              create: (context) => RecipeInfoCubit(
                  repository: GetIt.I.get<BaseRecipeRepository>(),
                  networkClient: GetIt.I.get<BaseNetworkRecipeClient>(),
                  recipe: state.recipeBranchState.selectedRecipe!),
              child: RecipePhotoCommentingPage(
                photo: state.recipeBranchState.photoToComment!,
              ),
            )),
      if (state.recipeBranchState.currentPage == Pages.camera &&
          state.recipeBranchState.selectedRecipe != null)
        RecipeBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseCameraCubit>(
                create: (context) => CameraCubit(
                    cameraService: GetIt.I.get<BaseCameraService>(),
                    recognitionService: GetIt.I.get<BaseRecognitionService>(),
                    recipe: state.recipeBranchState.selectedRecipe!,
                    repository: GetIt.instance.get<BaseRecipeRepository>()),
                child: const CameraGlobalScreen())),
    ];
  }

  List<Page> _favouriteBranchPages(AppNavigationState state) {
    return [
      if (state.favouriteBranchState.currentPage == Pages.favouriteList ||
          state.favouriteBranchState.currentPage == Pages.recipeInfo ||
          state.favouriteBranchState.currentPage == Pages.camera ||
          state.favouriteBranchState.currentPage == Pages.userPhotos ||
          state.favouriteBranchState.currentPage == Pages.carousel ||
          state.favouriteBranchState.currentPage == Pages.commenting_photo)
        const MaterialPage(child: FavouriteScreen()),
      if ((state.favouriteBranchState.currentPage == Pages.recipeInfo ||
              state.favouriteBranchState.currentPage == Pages.camera ||
              state.favouriteBranchState.currentPage == Pages.userPhotos ||
              state.favouriteBranchState.currentPage == Pages.carousel ||
              state.favouriteBranchState.currentPage == Pages.commenting_photo) &&
          state.favouriteBranchState.selectedRecipe != null)
        FavouriteBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
                create: (context) => RecipeInfoCubit(
                    repository: GetIt.instance.get<BaseRecipeRepository>(),
                    networkClient:
                        GetIt.instance.get<BaseNetworkRecipeClient>(),
                    recipe: state.favouriteBranchState.selectedRecipe!),
                child: const RecipeInfoScreen())),
      if ((state.favouriteBranchState.currentPage == Pages.userPhotos ||
              state.favouriteBranchState.currentPage == Pages.carousel ||
              state.favouriteBranchState.currentPage == Pages.commenting_photo) &&
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
                child: const RecipePhotoGridPage())),
      if ((state.favouriteBranchState.currentPage ==
              Pages.carousel) &&
          state.favouriteBranchState.selectedRecipe != null &&
          state.favouriteBranchState.photoViewMode != null &&
          state.favouriteBranchState.initIndexInCarousel != null)
        FavouriteBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipePhotoViewCubit>(
              create: (context) => RecipePhotoViewCubit(
                  status: state.favouriteBranchState.photoViewMode!,
                  recipe: state.favouriteBranchState.selectedRecipe!,
                  recipeRepository: GetIt.instance.get<BaseRecipeRepository>()),
              child: RecipePhotoCarouselPage(
                  photos: state.favouriteBranchState.selectedRecipe!.userPhotos,
                  initIndex: state.favouriteBranchState.initIndexInCarousel!),
            )),
      if ((state.favouriteBranchState.currentPage == Pages.commenting_photo) &&
          state.favouriteBranchState.selectedRecipe != null &&
          state.favouriteBranchState.photoViewMode != null &&
          state.favouriteBranchState.photoToComment != null)
        FavouriteBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
              create: (context) => RecipeInfoCubit(
                  repository: GetIt.I.get<BaseRecipeRepository>(),
                  networkClient: GetIt.I.get<BaseNetworkRecipeClient>(),
                  recipe: state.favouriteBranchState.selectedRecipe!),
              child: RecipePhotoCommentingPage(
                photo: state.favouriteBranchState.photoToComment!,
              ),
            )),
      if (state.favouriteBranchState.currentPage == Pages.camera &&
          state.favouriteBranchState.selectedRecipe != null)
        FavouriteBranchPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseCameraCubit>(
                create: (context) => CameraCubit(
                    cameraService: GetIt.I.get<BaseCameraService>(),
                    recognitionService: GetIt.I.get<BaseRecognitionService>(),
                    recipe: state.favouriteBranchState.selectedRecipe!,
                    repository: GetIt.instance.get<BaseRecipeRepository>()),
                child: const CameraGlobalScreen())),
    ];
  }
}
