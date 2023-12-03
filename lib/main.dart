import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipts/authentication/controllers/auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/services/base_recipe_service.dart';
import 'package:receipts/common/services/recipe_service.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_cubit.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  GetIt.instance.registerSingleton<BaseRecipeService>(RecipeService());
  GetIt.instance.registerSingleton<AppRouter>(AppRouter());
  runApp(MultiBlocProvider(providers: [
    BlocProvider<BaseAuthCubit>(create: (context) => AuthCubit()),
    BlocProvider<BaseRecipeListCubit>(
        create: (context) =>
            RecipeListCubit(GetIt.instance.get<BaseRecipeService>()))
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    BlocProvider.of<BaseRecipeListCubit>(context).loadRecipes();
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = GetIt.instance.get<AppRouter>();
    return MaterialApp.router(
      routeInformationParser: appRouter.router.routeInformationParser,
      routeInformationProvider: appRouter.router.routeInformationProvider,
      routerDelegate: appRouter.router.routerDelegate,
      title: 'Otus Food',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              color: Colors.white, surfaceTintColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
    );
  }
}
