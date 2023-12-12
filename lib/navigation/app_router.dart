import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/pages/login_page.dart';
import 'package:receipts/authentication/pages/profile_page.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_cubit.dart';
import 'package:receipts/camera/pages/camera_page.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/pages/home_screen.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/favourite/pages/favourite_page.dart';
import 'package:receipts/freezer/pages/freezer_page.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_cubit.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';
import 'package:receipts/recipes_list/pages/recipes_page.dart';

class AppRouter {
  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final _recipeListKey =
      GlobalKey<NavigatorState>(debugLabel: '${AppTabs.recipes}');
  final _loginKey = GlobalKey<NavigatorState>(debugLabel: '${AppTabs.login}');
  final _freezerKey =
      GlobalKey<NavigatorState>(debugLabel: '${AppTabs.freezer}');
  final _favouriteKey =
      GlobalKey<NavigatorState>(debugLabel: '${AppTabs.favourite}');
  final _profileKey =
      GlobalKey<NavigatorState>(debugLabel: '${AppTabs.profile}');

  int get loginTabCurrentIndexForAppBar => 1;
  int get loginTabIndexAsShellBranch => 4;

  int findCurrentIndexForAppBar(StatefulNavigationShell navigationShell) {
    return navigationShell.shellRouteContext.navigatorKey
            .toString()
            .contains('${AppTabs.login}')
        ? loginTabCurrentIndexForAppBar
        : navigationShell.currentIndex;
  }

  late final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/${AppTabs.recipes}',
    routes: [
      StatefulShellRoute.indexedStack(
          builder: (context, state, shell) {
            return HomeScreen(navigationShell: shell);
          },
          branches: [
            StatefulShellBranch(navigatorKey: _recipeListKey, routes: [
              GoRoute(
                  path: '/${AppTabs.recipes}',
                  builder: (context, state) {
                    return const RecipesPage();
                  },
                  routes: [
                    GoRoute(
                        path:
                            '${RecipesRouteNames.recipe}/:${PathParameters.recipeId}',
                        builder: (context, state) {
                          final recipe = state.extra as Recipe;
                          return BlocProvider<BaseRecipeInfoCubit>(
                            create: (context) => RecipeInfoCubit(
                                repository:
                                    GetIt.instance.get<BaseRecipeRepository>(),
                                recipe: recipe),
                            child: const RecipeInfoScreen(),
                          );
                        },
                        routes: [
                          GoRoute(
                              path: '${RecipesRouteNames.camera}',
                              builder: (context, state) {
                                final recipe = state.extra as Recipe;
                                return BlocProvider<BaseCameraCubit>(
                                    create: (context) => CameraCubit(
                                        recipe: recipe,
                                        repository: GetIt.instance
                                            .get<BaseRecipeRepository>()),
                                    child: const CameraPage());
                              })
                        ]),
                  ])
            ]),
            StatefulShellBranch(navigatorKey: _freezerKey, routes: [
              GoRoute(
                  path: '/${AppTabs.freezer}',
                  builder: (context, state) => const FreezerPage())
            ]),
            StatefulShellBranch(navigatorKey: _favouriteKey, routes: [
              GoRoute(
                  path: '/${AppTabs.favourite}',
                  builder: (context, state) => const FavouritePage())
            ]),
            StatefulShellBranch(navigatorKey: _profileKey, routes: [
              GoRoute(
                  path: '/${AppTabs.profile}',
                  builder: (context, state) => const ProfilePage())
            ]),
            StatefulShellBranch(navigatorKey: _loginKey, routes: [
              GoRoute(
                  path: '/${AppTabs.login}',
                  builder: (context, state) {
                    return const LoginPage();
                  })
            ]),
          ])
    ],
  );
}

enum AppTabs {
  recipes,
  login,
  profile,
  favourite,
  freezer;

  @override
  String toString() {
    return name;
  }
}

enum RecipesRouteNames {
  recipe,
  camera;

  @override
  String toString() {
    return name;
  }
}

enum PathParameters {
  recipeId;

  @override
  String toString() {
    return name;
  }
}
