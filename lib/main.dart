import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipts/authentication/controllers/auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/services/recipe_service.dart';

import 'recipes_list/controllers/recipe_list_cubit.dart';

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
  final AppRouter _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BaseAuthCubit>(create: (context) => AuthCubit()),
        BlocProvider<BaseRecipeListCubit>(
            create: (context) => RecipeListCubit(const RecipeService()))
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
