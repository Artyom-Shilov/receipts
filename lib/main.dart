import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:receipts/authentication/controllers/auth_cubit.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/ble_scan/controllers/base_ble_cubit.dart';
import 'package:receipts/ble_scan/controllers/ble_cubit.dart';
import 'package:receipts/ble_scan/services/base_ble_service.dart';
import 'package:receipts/ble_scan/services/ble_service.dart';
import 'package:receipts/camera/controllers/base_camera_service.dart';
import 'package:receipts/camera/controllers/base_recognition_service.dart';
import 'package:receipts/camera/controllers/camera_service.dart';
import 'package:receipts/camera/controllers/recognition_service.dart';
import 'package:receipts/common/local_storage/hive_recipe_client.dart';
import 'package:receipts/common/network/base_network_recipe_client.dart';
import 'package:receipts/common/network/dio_recipe_client.dart';
import 'package:receipts/common/pages/home_screen.dart';
import 'package:receipts/common/repositories/base_recipe_repository.dart';
import 'package:receipts/common/repositories/recipe_repository.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/favourite/controllers/favourite_recipes_cubit.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/navigation/controllers/navigation_cubit.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';
import 'package:receipts/recipes_list/controllers/recipe_list_cubit.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  final directory = await path_provider.getApplicationDocumentsDirectory();
  final storageClient = HiveRecipeClient();
  await storageClient.init(directory.path);
  GetIt.I.registerSingleton<BaseNetworkRecipeClient>(DioRecipeClient());
  GetIt.I.registerSingleton<BaseCameraService>(CameraService());
  GetIt.I.registerSingleton<BaseRecognitionService>(RecognitionService());
  GetIt.I.registerSingleton<BaseRecipeRepository>(RecipeRepository(
      storageClient: storageClient,
      networkClient: GetIt.I.get<BaseNetworkRecipeClient>()));
  GetIt.I.registerSingleton<BaseBleService>(BleService());
  runApp(MultiBlocProvider(providers: [
    BlocProvider<BaseAuthCubit>(
        create: (context) => AuthCubit(
            recipeRepository: GetIt.I.get<BaseRecipeRepository>(),
            networkRecipeClient: GetIt.I.get<BaseNetworkRecipeClient>())),
    BlocProvider<BaseRecipeListCubit>(
        create: (context) =>
            RecipeListCubit(GetIt.instance.get<BaseRecipeRepository>())),
    BlocProvider<BaseNavigationCubit>(create: (context) => NavigationCubit()),
    BlocProvider<BaseFavouriteRecipesCubit>(
        create: (context) =>
            FavouriteRecipesCubit(GetIt.instance.get<BaseRecipeRepository>())),
    BlocProvider<BaseBleCubit>(create: (context) =>
        BleCubit(GetIt.instance.get<BaseBleService>()))
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
    return MaterialApp(
      title: 'Otus Food',
      theme: ThemeData(
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
              color: Colors.white, surfaceTintColor: Colors.white),
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme)),
      home: const HomeScreen(),
    );
  }
}
