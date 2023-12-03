import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
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
              'login: ${BlocProvider.of<BaseAuthCubit>(context).state.user?.login ?? ''}'),
          const SizedBox(
            height: 60,
          ),
          ControlButton(
            text: const Text(ProfilePageTexts.doLogout),
            backgroundColor: AppColors.main,
            borderColor: AppColors.main,
            onPressed: () {
              BlocProvider.of<BaseAuthCubit>(context).logOut();
              GoRouter.of(context).go('/${AppTabs.recipes}');
            },
          )
        ],
      ),
    );
  }
}
