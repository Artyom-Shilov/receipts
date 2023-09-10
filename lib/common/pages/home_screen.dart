import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/custom_icons.dart';
import 'package:receipts/recipes_list/pages/recipes_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activeTab = 0;

  List<Widget> tabs = [
    const RecipeTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBackground,
      body: tabs[0],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _activeTab,
        backgroundColor: Colors.white,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: const Color.fromRGBO(194, 194, 194, 1),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(CustomIcons.pizza_slice), label: 'Рецепты'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Вход')
        ],
        onTap: (index) {
          setState(() {
            _activeTab = index;
          });
        },
      ),
    );
  }
}
