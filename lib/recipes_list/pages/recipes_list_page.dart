import 'package:flutter/material.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/widgets/common_persistent_header.dart';

class RecipesListPage extends StatelessWidget {
  const RecipesListPage({Key? key, required this.sliverList}) : super(key: key);

  final Widget sliverList;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Insets.horizontal1,
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              backgroundColor: AppColors.greyBackground,
              toolbarHeight: MediaQuery.of(context).size.height * 0.05,
            ),
            sliverList,
            const CommonPersistentHeader(
              maxExtent: 20,
              color: AppColors.greyBackground,
            ),
          ],
        ),
      ),
    );
  }
}
