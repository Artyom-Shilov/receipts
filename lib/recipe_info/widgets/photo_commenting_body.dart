import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/authentication/controllers/base_auth_cubit.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/constants/insets.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/widgets/back_navigation_arrow.dart';
import 'package:receipts/navigation/controllers/base_navigation_cubit.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_info_cubit.dart';

class PhotoCommentingBody extends HookWidget {
  const PhotoCommentingBody({Key? key, required this.photo}) : super(key: key);

  final UserRecipePhoto photo;

  @override
  Widget build(BuildContext context) {
    late final TextEditingController textController;
    final scrollController = ScrollController();
    useEffect(() {
      textController = TextEditingController();
      return () {
        textController.dispose();
      };
    });
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.amber,
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: MemoryImage(photo.photoBites),
                  fit: BoxFit.cover),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width,
                minHeight: MediaQuery.of(context).size.height,
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const BackNavigationArrow(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Insets.horizontal1, 0, Insets.horizontal1, 30),
                        child: TextField(
                          controller: textController,
                          maxLines: 2,
                          textInputAction: kIsWeb
                              ? TextInputAction.search
                              : TextInputAction.done,
                          decoration: const InputDecoration(
                            hintText: RecipeInfoTexts.commentInputHint,
                            hintStyle:
                                TextStyle(color: AppColors.main, fontSize: 16),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.main)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.main)),
                          ),
                          onSubmitted: (text) async {
                            final navigation =
                                BlocProvider.of<BaseNavigationCubit>(context);
                            final user = BlocProvider.of<BaseAuthCubit>(context).state.user!;
                            final recipe = BlocProvider.of<BaseRecipeInfoCubit>(context).recipe;
                            textController.clear();
                            await BlocProvider.of<BaseRecipeInfoCubit>(context)
                                .saveComment(
                                    user: user,
                                    recipe: recipe,
                                    text: text,
                                    photo: photo.photoBites);
                            navigation.toRecipeInfo(recipe);
                          },
                        ),
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}
