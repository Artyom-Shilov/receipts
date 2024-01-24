import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/constants.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit =  BlocProvider.of<BaseAuthCubit>(context);
    return SafeArea(
          child: SingleChildScrollView(
            child: Column(
            children: [
            const SizedBox(height: 60),
            Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.main,
                child: CircleAvatar(
                  radius: 55,
                  backgroundImage: authCubit.currentUser?.avatar == null
                      ? const AssetImage('assets/avatars/empty_avatar.jpg')
                      : Image.memory(authCubit.currentUser!.avatar!).image
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
              child: Container(
                height: 65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(BottomAppBarTexts.profile,
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.main,
                              fontWeight: FontWeight.w400)),
                      Text(
                          authCubit.state.user?.login ?? '',
                          style: const TextStyle(
                              fontSize: 20,
                              color: AppColors.accent,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: Insets.horizontal1),
                child: Container(
                  height: 60,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          authCubit.logOut();
                          BlocProvider.of<BaseNavigationCubit>(context).toRecipeList();
                        },
                        child: const Text(ProfilePageTexts.doLogout, style: TextStyle(
                            fontSize: 16,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w400
                        )),
                      )
                    )
                )),
              const SizedBox(height: 60),
            ],
      ),
          ),
    );
  }
}
