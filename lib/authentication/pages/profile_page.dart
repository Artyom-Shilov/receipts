import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/controllers/base_auth_controller.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/navigation/app_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(
            height: 120,
          ),
          Text(
              'login: ${context.read<BaseAuthController>().currentUser?.login ?? ''}'),
          const SizedBox(
            height: 60,
          ),
          ControlButton(
            text: const Text(ProfilePageTexts.doLogout),
            backgroundColor: AppColors.main,
            borderColor: AppColors.main,
            onPressed: () {
              context.read<BaseAuthController>().logout();
              context.goNamed(/*AppRouteNames.home.name*/'', pathParameters: {
                /*AppPathParameters.tab.name*/'': AppTabs.recipes.name
              });
            },
          )
        ],
      ),
    );
  }
}
