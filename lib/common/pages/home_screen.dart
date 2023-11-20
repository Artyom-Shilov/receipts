import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/navigation/app_router.dart';

class HomeScreen extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeScreen({Key? key, required this.navigationShell}) : super(key: key);

  final List<BottomNavigationBarItem> loggedInItems = const [
    BottomNavigationBarItem(
        icon: Icon(CustomIcons.pizza_slice), label: BottomAppBarTexts.recipes),
    BottomNavigationBarItem(
        icon: Icon(Icons.favorite), label: BottomAppBarTexts.favourite),
    BottomNavigationBarItem(
        icon: Icon(Icons.kitchen), label: BottomAppBarTexts.freezer),
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
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: navigationShell,
      bottomNavigationBar:
          BlocBuilder<BaseAuthCubit, AuthState>(builder: (context, state) {
        bool isLoggedIn = BlocProvider.of<BaseAuthCubit>(context).isLoggedIn;
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: GetIt.I
              .get<AppRouter>()
              .findCurrentIndexForAppBar(navigationShell),
          backgroundColor: Colors.white,
          selectedFontSize: 10.0,
          unselectedFontSize: 10.0,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: const Color.fromRGBO(194, 194, 194, 1),
          items: isLoggedIn ? loggedInItems : loggedOutItems,
          onTap: (index) {
            !isLoggedIn &&
                    loggedOutItems[index].label == BottomAppBarTexts.login
                ? navigationShell.goBranch(
                    GetIt.I.get<AppRouter>().loginTabIndexAsShellBranch)
                : navigationShell.goBranch(index);
          },
        );
      }),
    );
  }
}
