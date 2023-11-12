import 'dart:js';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receipts/authentication/pages/login_page.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/common/pages/home_screen.dart';
import 'package:receipts/recipe_info/controllers/base_comments_controller.dart';
import 'package:receipts/recipe_info/controllers/base_favourite_status_controller.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';
import 'package:receipts/recipe_info/controllers/comments_controller.dart';
import 'package:receipts/recipe_info/controllers/favourite_status_controller.dart';
import 'package:receipts/recipe_info/controllers/recipe_info_cubit.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';
import 'package:receipts/recipe_info/services/comments_service.dart';
import 'package:receipts/recipe_info/services/recipe_info_service.dart';
import 'package:receipts/recipes_list/pages/recipes_page.dart';

class AppRouter {
  static final List<String> loggedOutTabRoutes = [
    '${AppTabs.recipes}',
    '${AppTabs.login}'
  ];
  static final List<String> loggedInTabRoutes = [
    AppTabs.recipes.name,
    AppTabs.freezer.name,
    AppTabs.favourite.name,
    AppTabs.profile.name
  ];

  final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
  final _recipeListKey = GlobalKey<NavigatorState>(debugLabel: 'recipeListShell');
  final _loginKey = GlobalKey<NavigatorState>(debugLabel: 'loginShell');

  late final router = GoRouter(
    debugLogDiagnostics: true,
    navigatorKey:  _rootNavigatorKey,
    initialLocation: '/${AppTabs.recipes}',
    routes: [
      StatefulShellRoute.indexedStack(
          builder: (context, state, shell) {
            return HomeScreen(navigationShell: shell);
          },
          branches: [
            StatefulShellBranch(
                navigatorKey: _recipeListKey,
                routes: [
                  GoRoute(
                      path: '/${AppTabs.recipes}',
                      builder: (context, state) {
                        return const RecipesPage();
                      },
                    routes: [
                      GoRoute(
                        path: '${RecipesRouteNames.recipe}/:${PathParameters.recipeId}',
                        builder: (context, state) {
                          print('qqqqqqqq');
                          print(state.pathParameters);
                          final id = state.pathParameters['${PathParameters.recipeId}']!;
                          return BlocProvider<BaseRecipeInfoCubit>(
                              create: (context) => RecipeInfoCubit(RecipeInfoService()),
                              child: RecipeInfoScreen(recipeId: id),
                          );
                        }
                      )
                    ]
                  )
                ]
            ),
            StatefulShellBranch(
                navigatorKey: _loginKey,
                routes: [
                  GoRoute(
                      path: '/${AppTabs.login}',
                      builder: (context, state) {
                        return const LoginPage();
                      }
                  )
                ]
            ),
            /* StatefulShellBranch(routes: routes),
            StatefulShellBranch(routes: routes),
            StatefulShellBranch(routes: routes)*/
          ]
      )
    /*  GoRoute(
          name: '${AppRouteNames.home}',
          path: '/:${AppPathParameters.tab}',
          builder: (context, state) {
            final tab = state.pathParameters[AppPathParameters.tab] ?? AppTabs.recipes.name;
            print(tab);
            return HomeScreen(activeTab: tab);
          },*/
/*          routes: [
            GoRoute(
              name: '${AppRouteNames.recipe}',
              path: '${AppRouteNames.recipe}/:${AppPathParameters.recipeId}',
              builder: (context, state) {
                final id =
                    state.pathParameters[AppPathParameters.recipeId.name] ?? '';
                final recipe = _recipesController.findRecipeById(id)!;
                BaseCommentsController commentsController =
                    CommentsController(CommentsService());
                BaseFavouriteStatusController favouriteStatusController =
                    FavouriteStatusController();
                return MultiProvider(
                  providers: [
                    ChangeNotifierProvider(
                      create: (context) => commentsController,
                    ),
                    ChangeNotifierProvider(
                      create: (context) => favouriteStatusController,
                    ),
                  ],
                  child: RecipeInfoScreen(recipe: recipe),
                );
              },
            )
          ]*/,
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
  recipe;

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
