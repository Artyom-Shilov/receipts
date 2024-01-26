import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/authentication/pages/auth_screen.dart';
import 'package:receipts/camera/controllers/base_camera_service.dart';
import 'package:receipts/camera/controllers/base_recognition_service.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/pages/page_not_found_screen.dart';
import 'package:receipts/navigation/controllers/nested_branch_state.dart';
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

import 'route_pages/custom_page.dart';

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
              ...[
                if (state.recipeBranchState.currentPage == Pages.recipeList ||
                  state.recipeBranchState.currentPage == Pages.recipeInfo ||
                  state.recipeBranchState.currentPage == Pages.camera ||
                  state.recipeBranchState.currentPage == Pages.userPhotos ||
                  state.recipeBranchState.currentPage == Pages.carousel ||
                  state.recipeBranchState.currentPage == Pages.commenting_photo)
                const MaterialPage(child: RecipesScreen()),
              ..._similarBranchPages(state.recipeBranchState)
            ] else if (state.currentBranch == Branches.login) ...[
              const MaterialPage(child: AuthScreen()),
            ] else if (state.currentBranch == Branches.favourite)
              ...[
                if (state.favouriteBranchState.currentPage == Pages.favouriteList ||
                    state.favouriteBranchState.currentPage == Pages.recipeInfo ||
                    state.favouriteBranchState.currentPage == Pages.camera ||
                    state.favouriteBranchState.currentPage == Pages.userPhotos ||
                    state.favouriteBranchState.currentPage == Pages.carousel ||
                    state.favouriteBranchState.currentPage == Pages.commenting_photo)
                  const MaterialPage(child: FavouriteScreen()),
                ... _similarBranchPages(state.favouriteBranchState)
              ]
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

  List<Page> _similarBranchPages(NestedBranchState branchState) {
    return [
      if ((branchState.currentPage == Pages.recipeInfo ||
          branchState.currentPage == Pages.camera ||
          branchState.currentPage == Pages.userPhotos ||
          branchState.currentPage == Pages.carousel ||
          branchState.currentPage == Pages.commenting_photo) &&
          branchState.selectedRecipe != null)
        CustomPage(
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
                create: (context) => RecipeInfoCubit(
                    repository: GetIt.instance.get<BaseRecipeRepository>(),
                    networkClient:
                    GetIt.instance.get<BaseNetworkRecipeClient>(),
                    recipe: branchState.selectedRecipe!),
                child: const RecipeInfoScreen())),
      if ((branchState.currentPage == Pages.userPhotos ||
          branchState.currentPage == Pages.carousel ||
          branchState.currentPage == Pages.commenting_photo) &&
          branchState.selectedRecipe != null &&
          branchState.photoViewMode != null)
        CustomPage(
            key: UniqueKey(),
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipePhotoViewCubit>(
                create: (context) => RecipePhotoViewCubit(
                    status: branchState.photoViewMode!,
                    recipe: branchState.selectedRecipe!,
                    recipeRepository:
                    GetIt.instance.get<BaseRecipeRepository>()),
                child: const RecipePhotoGridPage())),
      if ((branchState.currentPage == Pages.carousel) &&
          branchState.selectedRecipe != null &&
          branchState.photoViewMode != null &&
          branchState.initIndexInCarousel != null)
        CustomPage(
            key: UniqueKey(),
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipePhotoViewCubit>(
              create: (context) => RecipePhotoViewCubit(
                  status: branchState.photoViewMode!,
                  recipe: branchState.selectedRecipe!,
                  recipeRepository: GetIt.instance.get<BaseRecipeRepository>()),
              child: RecipePhotoCarouselPage(
                  photos: branchState.selectedRecipe!.userPhotos,
                  initIndex: branchState.initIndexInCarousel!),
            )),
      if ((branchState.currentPage == Pages.commenting_photo) &&
          branchState.selectedRecipe != null &&
          branchState.photoViewMode != null &&
          branchState.photoToComment != null)
        CustomPage(
            key: UniqueKey(),
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseRecipeInfoCubit>(
              create: (context) => RecipeInfoCubit(
                  repository: GetIt.I.get<BaseRecipeRepository>(),
                  networkClient: GetIt.I.get<BaseNetworkRecipeClient>(),
                  recipe: branchState.selectedRecipe!),
              child: RecipePhotoCommentingPage(
                photo: branchState.photoToComment!,
              ),
            )),
      if (branchState.currentPage == Pages.camera &&
          branchState.selectedRecipe != null)
        CustomPage(
            key: UniqueKey(),
            forward: Transitions.slide,
            back: Transitions.fade,
            child: BlocProvider<BaseCameraCubit>(
                create: (context) => CameraCubit(
                    cameraService: GetIt.I.get<BaseCameraService>(),
                    recognitionService: GetIt.I.get<BaseRecognitionService>(),
                    recipe: branchState.selectedRecipe!,
                    repository: GetIt.instance.get<BaseRecipeRepository>()),
                child: const CameraGlobalScreen())),
    ];
  }
}
