import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:receipts/authentication/pages/login_page.dart';
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
import 'package:receipts/recipe_info/controllers/recipe_info_cubit.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';
import 'package:receipts/recipes_list/pages/recipes_screen.dart';

import 'custom_page.dart';

class AppRouterDelegate extends RouterDelegate
    with PopNavigatorRouterDelegateMixin, ChangeNotifier {
  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<BaseNavigationCubit>(context);
    return BlocBuilder<BaseNavigationCubit, AppNavigationState>(
        buildWhen: (prev, next) =>
            prev.currentBranch != next.currentBranch ||
            prev.currentPage != next.currentPage,
        builder: (context, state) {
          log(state.currentPage?.name ?? '');
          return Navigator(
              transitionDelegate: CustomTransitionDelegate(state.isBranchChanged),
              key: navigatorKey,
              pages: [
                if (state.currentBranch == Branches.recipeList) ...[
                  const MaterialPage(child: RecipesScreen()),
                  if ((navigationCubit.state.currentPage == Pages.recipeInfo ||
                      navigationCubit.state.currentPage == Pages.camera) &&
                          navigationCubit.state.selectedRecipe != null)
                    CustomPage(
                      forward: Transitions.slide,
                      back: Transitions.fade,
                      child: BlocProvider<BaseRecipeInfoCubit>(
                          create: (context) => RecipeInfoCubit(
                              repository:
                                  GetIt.instance.get<BaseRecipeRepository>(),
                              networkClient:
                                  GetIt.instance.get<BaseNetworkRecipeClient>(),
                              recipe: navigationCubit.state.selectedRecipe!),
                          child: const RecipeInfoScreen()),
                    ),
                  if ((navigationCubit.state.currentPage == Pages.camera) &&
                      navigationCubit.state.selectedRecipe != null)
                    CustomPage(
                        forward: Transitions.slide,
                        back: Transitions.fade,
                        child: BlocProvider<BaseCameraCubit>(
                            create: (context) => CameraCubit(
                                recipe: navigationCubit.state.selectedRecipe!,
                                repository:
                                    GetIt.instance.get<BaseRecipeRepository>()),
                            child: const CameraGlobalScreen()))
                ] else if (state.currentBranch == Branches.login) ...[
                  const MaterialPage(child: LoginPage()),
                ] else if (state.currentBranch ==
                    Branches.recipesFavourite) ...[
                  const MaterialPage(child: FavouriteScreen()),
                  if (navigationCubit.state.currentPage == Pages.recipeInfo &&
                      navigationCubit.state.selectedRecipe != null)
                    CustomPage(
                      forward: Transitions.slide,
                      back: Transitions.fade,
                      child: BlocProvider<BaseRecipeInfoCubit>(
                          create: (context) => RecipeInfoCubit(
                              repository:
                              GetIt.instance.get<BaseRecipeRepository>(),
                              networkClient:
                              GetIt.instance.get<BaseNetworkRecipeClient>(),
                              recipe: navigationCubit.state.selectedRecipe!),
                          child: const RecipeInfoScreen()),
                    ),
                ] else if (state.currentBranch == Branches.profile) ...[
                  const MaterialPage(child: ProfileScreen())
                ]
              ],
              onPopPage: (route, result) {
                print('onPop');
                navigationCubit.changeStateOnPop();
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
