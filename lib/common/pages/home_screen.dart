import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/favourite/controllers/base_favourite_recipes_cubit.dart';
import 'package:receipts/navigation/app_information_parser.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/navigation/app_router_delegate.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/recipes_list/controllers/base_recipe_list_cubit.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  final List<BottomNavigationBarItem> loggedInItems = const [
    BottomNavigationBarItem(
        icon: Icon(CustomIcons.pizza_slice), label: BottomAppBarTexts.recipes),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: BottomAppBarTexts.favourite),
    BottomNavigationBarItem(
        icon: Icon(Icons.person), label: BottomAppBarTexts.profile)
  ];

  final List<BottomNavigationBarItem> loggedOutItems = const [
    BottomNavigationBarItem(
        icon: Icon(CustomIcons.pizza_slice), label: BottomAppBarTexts.recipes),
    BottomNavigationBarItem(
        icon: Icon(Icons.person), label: BottomAppBarTexts.login)
  ];

  @override
  Widget build(BuildContext context) {
    final navigationCubit = BlocProvider.of<BaseNavigationCubit>(context);
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: Router(
        routerDelegate: AppRouterDelegate(navigationCubit),
        routeInformationParser: AppInformationParser(
          recipeListCubit: BlocProvider.of<BaseRecipeListCubit>(context),
          favouriteRecipesCubit: BlocProvider.of<BaseFavouriteRecipesCubit>(context),
          authCubit: BlocProvider.of<BaseAuthCubit>(context),
          navigationCubit: navigationCubit
        ),
      ),
      bottomNavigationBar:
          BlocBuilder<BaseAuthCubit, AuthState>(builder: (context, state) {
        bool isLoggedIn = BlocProvider.of<BaseAuthCubit>(context).isLoggedIn;
        return BlocBuilder<BaseNavigationCubit, AppNavigationState>(
            builder: (context, state) {
          return navigationCubit.isShowingBottomAppBar()
              ? BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  currentIndex: navigationCubit.findAppBarIndexByBranch(),
                  backgroundColor: Colors.white,
                  selectedFontSize: 10.0,
                  unselectedFontSize: 10.0,
                  selectedItemColor: AppColors.accent,
                  unselectedItemColor: const Color.fromRGBO(194, 194, 194, 1),
                  items: isLoggedIn ? loggedInItems : loggedOutItems,
                  onTap: (index) {
                    navigationCubit.navigateToBranchByAppBarIndex(
                        isLoggedIn, index);
                  },
                )
              :const SizedBox.shrink();
        });
      }),
    );
  }
}
