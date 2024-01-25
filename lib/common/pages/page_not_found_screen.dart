import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/widgets/control_button.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';

class PageNotFoundScreen extends StatelessWidget {
  const PageNotFoundScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigation = BlocProvider.of<BaseNavigationCubit>(context);
    return Scaffold(
        backgroundColor: AppColors.accent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(PageNotFoundTexts.title),
              const SizedBox(height: 20),
              ControlButton(
                  backgroundColor: AppColors.main,
                  borderColor: AppColors.main,
                  onPressed: () => navigation.toRecipeList(),
                  child: const Text(PageNotFoundTexts.toMain)),
            ],
          )
        ),
    );

  }
}
