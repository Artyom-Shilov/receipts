import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/authentication/controllers/auth_state.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/common/widgets/bookmark.dart';
import 'package:receipts/navigation/base_navigation_cubit.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({Key? key, required this.recipe}) : super(key: key);
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<BaseNavigationCubit>(context).toRecipeInfo(recipe);
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: const [
            BoxShadow(
                color: Color.fromRGBO(49, 146, 146, 0.1),
                blurStyle: BlurStyle.normal,
                blurRadius: 4,
                spreadRadius: 2,
                offset: Offset(0, 4))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              flex: 8,
              child: BlocBuilder<BaseAuthCubit, AuthState>(
                builder: (context, state) => Stack(children: [
                  Image.memory(
                    recipe.photoBytes,
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.longestSide * 0.15,
                  ),
                  if (recipe.favouriteStatus.isFavourite &&
                      state.status == AuthStatus.loggedIn)
                    Positioned(
                      bottom: 10,
                      right: 0,
                      child: Bookmark(
                          color: AppColors.accent,
                          number: recipe.likesNumber,
                          height: 17,
                          width: 40),
                    )
                ]),
              ),
            ),
            const Spacer(flex: 1),
            Expanded(
              flex: 10,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.access_time, size: 16),
                        Expanded(
                          child: Text(
                            '   ${recipe.duration}',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.accent),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const Spacer(flex: 1)
          ],
        ),
      ),
    );
  }
}
