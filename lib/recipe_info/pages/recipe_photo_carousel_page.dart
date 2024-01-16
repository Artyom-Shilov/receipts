import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/util/util_logic.dart';
import 'package:receipts/recipe_info/widgets/photo_viewing_body.dart';

class RecipePhotoCarouselPage extends HookWidget {
  const RecipePhotoCarouselPage(
      {Key? key, required this.photos, required this.initIndex})
      : super(key: key);

  final List<UserRecipePhoto> photos;
  final int initIndex;

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      UtilLogic.fixPortraitUpOrientation();
      return () {
        UtilLogic.unfixOrientation();
      };
    });
    return Scaffold(
      body: Stack(children: [
        CarouselSlider(
          options: CarouselOptions(
            initialPage: initIndex,
            height: MediaQuery.of(context).size.height,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
          ),
          items: photos.map((item) {
            return PhotoViewingBody(photo: item);
          }).toList(),
        ),
      ]),
    );
  }
}
