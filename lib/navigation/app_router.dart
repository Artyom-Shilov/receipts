/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/pages/auth_screen.dart';
import 'package:receipts/profile/profile_screen.dart';
import 'package:receipts/camera/controllers/base_camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_cubit.dart';
import 'package:receipts/camera/controllers/camera_service.dart';
import 'package:receipts/camera/controllers/recognition_service.dart';
import 'package:receipts/camera/pages/camera_global_screen.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/pages/home_screen.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/favourite/pages/favourite_screen.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/pages/pages.dart';
import 'package:receipts/recipes_list/pages/recipes_screen.dart';

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
            return HomeScreen();
          },
          branches: [
            StatefulShellBranch(navigatorKey: _recipeListKey, routes: [
              GoRoute(
                  path: '/${AppTabs.recipes}',
                  builder: (context, state) => const RecipesScreen(),
                  routes: [
                    GoRoute(
                        path:
                            '${RecipesRouteNames.recipe}/:${PathParameters.recipeId}',
                        pageBuilder: (context, state) {
                          final recipe = (state.extra
                                  as Map<ExtraKeys, dynamic>)[ExtraKeys.recipe]
                              as Recipe;
                          return CustomTransitionPage(
                              child: BlocProvider<BaseRecipeInfoCubit>(
                                create: (context) => RecipeInfoCubit(
                                    repository: GetIt.instance
                                        .get<BaseRecipeRepository>(),
                                    networkClient: GetIt.instance
                                        .get<BaseNetworkRecipeClient>(),
                                    recipe: recipe),
                                child: const RecipeInfoScreen(),
                              ),
                              transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) =>
                                  animation.status == AnimationStatus.forward
                                      ? SlideTransition(
                                          position:
                                              animation.drive(Tween<Offset>(
                                            begin: const Offset(1, 0),
                                            end: Offset.zero,
                                          )),
                                          child: child)
                                      : FadeTransition(
                                          opacity: animation, child: child));
                        },
                        routes: [
                          GoRoute(
                              path: '${RecipesRouteNames.camera}',
                              parentNavigatorKey: _rootNavigatorKey,
                              builder: (context, state) {
                                final recipe = (state.extra as Map<ExtraKeys,
                                    dynamic>)[ExtraKeys.recipe] as Recipe;
                                return BlocProvider<BaseCameraCubit>(
                                    create: (context) => CameraCubit(
                                        cameraService: CameraService(),
                                        recognitionService: RecognitionService(),
                                        recipe: recipe,
                                        repository: GetIt.instance
                                            .get<BaseRecipeRepository>()),
                                    child: const CameraGlobalScreen());
                              }),
                          GoRoute(
                              path: '${RecipesRouteNames.photoView}',
                              pageBuilder: (context, state) {
                                final recipe = (state.extra as Map<ExtraKeys,
                                    dynamic>)[ExtraKeys.recipe] as Recipe;
                                final mode = (state.extra as Map<ExtraKeys,
                                        dynamic>)[ExtraKeys.recipePhotoViewMode]
                                    as RecipePhotoViewStatus;
                                return CustomTransitionPage(
                                    child: BlocProvider<
                                            BaseRecipePhotoViewCubit>(
                                        create: (context) =>
                                            RecipePhotoViewCubit(
                                                status: mode,
                                                recipe: recipe,
                                                recipeRepository:
                                                    GetIt.instance.get<
                                                        BaseRecipeRepository>()),
                                        child: const RecipePhotoGridPage()),
                                    transitionsBuilder: (context, animation, _,
                                            child) =>
                                        animation.status ==
                                                AnimationStatus.forward
                                            ? SlideTransition(
                                                position: animation
                                                    .drive(Tween<Offset>(
                                                  begin: const Offset(1, 0),
                                                  end: Offset.zero,
                                                )),
                                                child: child)
                                            : FadeTransition(
                                                opacity: animation,
                                                child: child));
                              },
                              routes: [
                                GoRoute(
                                    path:
                                        '${RecipesRouteNames.photoCommenting}',
                                    parentNavigatorKey: _rootNavigatorKey,
                                    pageBuilder: (context, state) {
                                      final recipe = (state.extra as Map<
                                          ExtraKeys,
                                          dynamic>)[ExtraKeys.recipe] as Recipe;
                                      final photo = (state.extra as Map<
                                              ExtraKeys,
                                              dynamic>)[ExtraKeys.photo]
                                          as UserRecipePhoto;
                                      return CustomTransitionPage(
                                          child: BlocProvider<
                                                  BaseRecipeInfoCubit>(
                                              create: (context) => RecipeInfoCubit(
                                                  repository: GetIt.instance.get<
                                                      BaseRecipeRepository>(),
                                                  networkClient: GetIt.instance.get<
                                                      BaseNetworkRecipeClient>(),
                                                  recipe: recipe),
                                              child: RecipePhotoCommentingPage(
                                                photo: photo,
                                              )),
                                          transitionsBuilder: (context,
                                                  animation, _, child) =>
                                              animation.status ==
                                                      AnimationStatus.forward
                                                  ? ScaleTransition(
                                                      scale: animation,
                                                      child: child)
                                                  : FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ));
                                    }),
                                GoRoute(
                                    path: '${RecipesRouteNames.carousel}',
                                    parentNavigatorKey: _rootNavigatorKey,
                                    pageBuilder: (context, state) {
                                      final recipe = (state.extra as Map<
                                          ExtraKeys,
                                          dynamic>)[ExtraKeys.recipe] as Recipe;
                                      final mode = (state.extra
                                                  as Map<ExtraKeys, dynamic>)[
                                              ExtraKeys.recipePhotoViewMode]
                                          as RecipePhotoViewStatus;
                                      final photos = recipe.userPhotos;
                                      final initIndex = (state.extra
                                              as Map<ExtraKeys, dynamic>)[
                                          ExtraKeys.recipePhotoIndex] as int;
                                      return CustomTransitionPage(
                                          child: MultiBlocProvider(
                                              providers: [
                                                BlocProvider<
                                                        BaseRecipePhotoViewCubit>(
                                                    create: (context) =>
                                                        RecipePhotoViewCubit(
                                                            recipe: recipe,
                                                            status: mode,
                                                            recipeRepository:
                                                                GetIt.instance.get<
                                                                    BaseRecipeRepository>())),
                                                BlocProvider<
                                                    BaseRecipeInfoCubit>(
                                                  create: (context) => RecipeInfoCubit(
                                                      repository: GetIt.instance
                                                          .get<
                                                              BaseRecipeRepository>(),
                                                      networkClient:
                                                          GetIt.instance.get<
                                                              BaseNetworkRecipeClient>(),
                                                      recipe: recipe),
                                                )
                                              ],
                                              child: RecipePhotoCarouselPage(
                                                photos: photos,
                                                initIndex: initIndex,
                                              )),
                                          transitionsBuilder: (context,
                                                  animation, _, child) =>
                                              animation.status ==
                                                      AnimationStatus.forward
                                                  ? ScaleTransition(
                                                      scale: animation,
                                                      child: child)
                                                  : FadeTransition(
                                                      opacity: animation,
                                                      child: child,
                                                    ));
                                    })
                              ]),
                        ]),
                  ])
            ]),
            StatefulShellBranch(navigatorKey: _favouriteKey, routes: [
              GoRoute(
                  path: '/${AppTabs.favourite}',
                  builder: (context, state) => const FavouriteScreen())
            ]),
            StatefulShellBranch(navigatorKey: _profileKey, routes: [
              GoRoute(
                  path: '/${AppTabs.profile}',
                  builder: (context, state) => const ProfileScreen())
            ]),
            StatefulShellBranch(navigatorKey: _loginKey, routes: [
              GoRoute(
                  path: '/${AppTabs.login}',
                  builder: (context, state) {
                    return AuthScreen();
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
  camera,
  carousel,
  photoCommenting,
  photoView;

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

enum ExtraKeys {
  recipe,
  recipePhotoIndex,
  photo,
  recipePhotoViewMode;

  @override
  String toString() {
    return name;
  }
}
*/
