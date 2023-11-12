import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/authentication/pages/login_page.dart';
import 'package:receipts/authentication/pages/profile_page.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/constants/custom_icons.dart';
import 'package:receipts/favourite/pages/favourite_page.dart';
import 'package:receipts/freezer/pages/freezer_page.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/pages/recipes_page.dart';


class HomeScreen extends StatelessWidget {

  final StatefulNavigationShell navigationShell;

  const HomeScreen({Key? key, required this.navigationShell}) : super(key: key);

 /* final List<Widget> loggedOutTabs = [
    const RecipesPage(),
    const LoginPage(),
  ];*/

/*  final List<Widget> loggedInTabs = [
    const RecipesPage(),
    const FreezerPage(),
    const FavouritePage(),
    const ProfilePage(),
  ];*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: navigationShell,
        /* BlocProvider.of<BaseAuthCubit>(context).state.status ==
              AuthStatus.loggedIn
          ? IndexedStack(
              index: AppRouter.loggedInTabRoutes.indexOf(activeTab),
              children: loggedInTabs,
            )
          : IndexedStack(
              index: AppRouter.loggedOutTabRoutes.indexOf(activeTab),
              children: loggedOutTabs,
            ),*/
      bottomNavigationBar:
          BlocBuilder<BaseAuthCubit, AuthState>(builder: (context, state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationShell.currentIndex,
          /*state.status == AuthStatus.loggedIn
              ? AppRouter.loggedInTabRoutes.indexOf(activeTab)
              : AppRouter.loggedOutTabRoutes.indexOf(activeTab),*/
          backgroundColor: Colors.white,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: const Color.fromRGBO(194, 194, 194, 1),
          items: state.status == AuthStatus.loggedIn
              ? [
                  const BottomNavigationBarItem(
                      icon: Icon(CustomIcons.pizza_slice),
                      label: BottomAppBarTexts.recipes),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.favorite),
                      label: BottomAppBarTexts.favourite),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.kitchen),
                      label: BottomAppBarTexts.freezer),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      label: BottomAppBarTexts.profile)
                ]
              : [
                  const BottomNavigationBarItem(
                      icon: Icon(CustomIcons.pizza_slice),
                      label: BottomAppBarTexts.recipes),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: BottomAppBarTexts.login)
                ],
          onTap: (index) {
            navigationShell.goBranch(index);
           /* context.goNamed(AppRouteNames.home.name, pathParameters: {
              AppPathParameters.tab.name: state.status == AuthStatus.loggedIn
                  ? AppRouter.loggedInTabRoutes[index]
                  : AppRouter.loggedOutTabRoutes[index]
            });*/
          },
        );
      }),
    );
  }
}
