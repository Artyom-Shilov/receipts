import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receipts/authentication/pages/login_page.dart';
import 'package:receipts/authentication/pages/profile_page.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/custom_icons.dart';
import 'package:receipts/favourite/pages/favourite_page.dart';
import 'package:receipts/freezer/pages/freezer_page.dart';
import 'package:receipts/navigation/app_router.dart';
import 'package:receipts/recipes_list/pages/recipes_page.dart';

import '../controllers/base_auth_controller.dart';

class HomeScreen extends StatelessWidget {
  final String activeTab;

  HomeScreen({Key? key, required this.activeTab}) : super(key: key);

  final List<Widget> loggedOutTabs = [
    const RecipesPage(),
    const LoginPage(),
  ];

  final List<Widget> loggedInTabs = [
    const RecipesPage(),
    const FreezerPage(),
    const FavouritePage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: context.read<BaseAuthController>().isLoggedIn
          ? IndexedStack(
              index: AppRouter.loggedInTabRoutes.indexOf(activeTab),
              children: loggedInTabs,
            )
          : IndexedStack(
              index: AppRouter.loggedOutTabRoutes.indexOf(activeTab),
              children: loggedOutTabs,
            ),
      bottomNavigationBar:
          Consumer<BaseAuthController>(builder: (context, authController, _) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: authController.isLoggedIn
              ? AppRouter.loggedInTabRoutes.indexOf(activeTab)
              : AppRouter.loggedOutTabRoutes.indexOf(activeTab),
          backgroundColor: Colors.white,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: const Color.fromRGBO(194, 194, 194, 1),
          items: authController.isLoggedIn
              ? [
                  const BottomNavigationBarItem(
                      icon: Icon(CustomIcons.pizza_slice), label: 'Рецепты'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: 'Избранное'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.kitchen), label: 'Рецепты'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Профиль')
                ]
              : [
                  const BottomNavigationBarItem(
                      icon: Icon(CustomIcons.pizza_slice), label: 'Рецепты'),
                  const BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Вход')
                ],
          onTap: (index) {
            context.goNamed(AppRouteNames.home.name, pathParameters: {
              AppPathParameters.tab.name: authController.isLoggedIn
                  ? AppRouter.loggedInTabRoutes[index]
                  : AppRouter.loggedOutTabRoutes[index]
            });
          },
        );
      }),
    );
  }
}
