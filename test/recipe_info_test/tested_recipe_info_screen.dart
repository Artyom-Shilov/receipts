import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/navigation/controllers/navigation_cubit.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';
import 'package:receipts/recipe_info/pages/recipe_info_screen.dart';

import 'auth_cubit_for_test.dart';
import 'recipe_info_cubit_for_test.dart';

class TestedRecipeInfoScreen extends StatelessWidget {
  const TestedRecipeInfoScreen({Key? key, required this.recipe}) : super(key: key);

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(providers: [
      BlocProvider<BaseRecipeInfoCubit>(
          create: (context) => RecipeInfoCubitForTests(recipe: recipe)),
      BlocProvider<BaseAuthCubit>(create: (context) => AuthCubitForTest()),
      BlocProvider<BaseNavigationCubit>(
          create: (context) => NavigationCubit()),
    ], child: const MaterialApp(home: RecipeInfoScreen()));
  }
}
