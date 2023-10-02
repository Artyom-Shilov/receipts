import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/common/pages/home_screen.dart';
import 'package:receipts/recipe_info/controllers/base_comments_controller.dart';
import 'package:receipts/recipe_info/controllers/base_favourite_status_controller.dart';
import 'package:receipts/recipe_info/controllers/comments_controller.dart';
import 'package:receipts/recipe_info/controllers/favourite_status_controller.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';
import 'package:receipts/recipe_info/services/comments_service.dart';
import 'package:receipts/recipes_list/controllers/base_recipes_controller.dart';

class AppRouter {
  static final List<String> loggedOutTabRoutes = [
    AppTabs.recipes.name,
    AppTabs.login.name
  ];
  static final List<String> loggedInTabRoutes = [
    AppTabs.recipes.name,
    AppTabs.freezer.name,
    AppTabs.favourite.name,
    AppTabs.profile.name
  ];

  final BaseAuthController _authController;
  final BaseRecipesController _recipesController;

  AppRouter({required authController, required recipesController})
      : _authController = authController,
        _recipesController = recipesController;

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: _authController,
    initialLocation: '/${AppTabs.recipes.name}',
    routes: [
      GoRoute(
          name: AppRouteNames.home.name,
          path: '/:${AppPathParameters.tab.name}',
          builder: (context, state) {
            final tab = state.pathParameters[AppPathParameters.tab.name] ??
                AppTabs.recipes.name;
            return HomeScreen(activeTab: tab);
          },
          routes: [
            GoRoute(
              name: AppRouteNames.recipe.name,
              path:
                  '${AppRouteNames.recipe.name}/:${AppPathParameters.recipeId.name}',
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
                    )
                  ],
                  child: RecipeInfoScreen(recipe: recipe),
                );
              },
            )
          ]),
    ],
  );
}

enum AppTabs {
  recipes,
  login,
  profile,
  favourite,
  freezer;
}

enum AppRouteNames {
  home,
  recipe;
}

enum AppPathParameters {
  tab,
  recipeId;
}
