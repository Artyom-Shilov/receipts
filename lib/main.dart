import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/controllers/auth_controller.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/controllers/base_recipes_controller.dart';
import 'package:receipts/recipes_list/controllers/recipes_controller.dart';
import 'package:receipts/recipes_list/services/recipe_service.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final BaseAuthController _authController = AuthController();
  final BaseRecipesController _recipesController =
      RecipesController(const RecipeService());
  late final AppRouter _appRouter = AppRouter(
      authController: _authController, recipesController: _recipesController);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => _authController,
        ),
        ChangeNotifierProvider(
          create: (context) => _recipesController,
        )
      ],
      child: MaterialApp.router(
        routeInformationParser: _appRouter.router.routeInformationParser,
        routeInformationProvider: _appRouter.router.routeInformationProvider,
        routerDelegate: _appRouter.router.routerDelegate,
        title: 'Otus Food',
        theme: ThemeData(
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
                color: Colors.white, surfaceTintColor: Colors.white),
            scaffoldBackgroundColor: Colors.white,
            textTheme:
                GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
      ),
    );
  }
}
