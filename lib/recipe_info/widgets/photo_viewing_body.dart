import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/camera/widgets/detections_stack.dart';
import 'package:receipts/common/constants/app_colors.dart';
import 'package:receipts/common/constants/app_texts.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/widgets/back_navigation_arrow.dart';
import 'package:receipts/recipe_info/controllers/base_recipe_photo_view_cubit.dart';
import 'package:receipts/recipe_info/controllers/recipe_photo_view_state.dart';

class PhotoViewingBody extends StatelessWidget {
  const PhotoViewingBody({Key? key, required this.photo}) : super(key: key);

  final UserRecipePhoto photo;

  @override
  Widget build(BuildContext context) {
    final recipePhotoCubit = BlocProvider.of<BaseRecipePhotoViewCubit>(context);
    return BlocBuilder<BaseRecipePhotoViewCubit, RecipePhotoViewState>(
      buildWhen: (prev, next) => prev.status != next.status,
      builder: (context, state) => Stack(children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.amber,
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: MemoryImage(photo.photoBites),
                  fit: BoxFit.cover)),
        ),
        if (photo.detections.isNotEmpty &&
            state.status == RecipePhotoViewStatus.viewingWithDetections)
          DetectionStack(
            detections: photo.detections,
          ),
        if (state.status == RecipePhotoViewStatus.viewingWithDetections ||
            state.status == RecipePhotoViewStatus.viewing)
          Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: ElevatedButton(
                      onPressed: () async {
                        if (state.status == RecipePhotoViewStatus.viewing) {
                          if (photo.detections.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: const Text(DetectionTexts
                                    .couldNotReliableFindDetections),
                                action: SnackBarAction(
                                  label: DetectionTexts.undoSnackBar,
                                  onPressed: () {},
                                )));
                          }
                          recipePhotoCubit.viewPhotoWithDetections();
                        } else {
                          recipePhotoCubit.viewPhoto();
                        }
                      },
                      child: Icon(
                        Icons.search,
                        color: state.status == RecipePhotoViewStatus.viewing
                            ? Colors.grey
                            : AppColors.accent,
                      )))),
        const BackNavigationArrow()
      ]),
    );
  }
}
