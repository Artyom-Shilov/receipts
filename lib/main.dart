import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipts/authentication/controllers/auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/local_storage/hive_recipe_client.dart';
import 'package:receipts/common/network/dio_recipe_client.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/common/repositories/recipe_repository.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_cubit.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final storageClient = HiveRecipeClient();
  await storageClient.init(directory.path);
  GetIt.instance.registerSingleton<BaseRecipeRepository>(RecipeRepository(
      storageClient: storageClient, networkClient: DioRecipeClient()));
  GetIt.instance.registerSingleton<AppRouter>(AppRouter());
  runApp(MultiBlocProvider(providers: [
    BlocProvider<BaseAuthCubit>(create: (context) => AuthCubit()),
    BlocProvider<BaseRecipeListCubit>(
        create: (context) =>
            RecipeListCubit(GetIt.instance.get<BaseRecipeRepository>()))
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
