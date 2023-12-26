import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:receipts/common/models/models.dart';

class RecipePhotoCarouselPage extends StatelessWidget {
  const RecipePhotoCarouselPage({Key? key, required this.photos}) : super(key: key);

  final List<UserRecipePhoto> photos;

  @override
  Widget build(BuildContext context) {
    print(photos.length);
    return CarouselSlider(
      options: CarouselOptions(
          height: MediaQuery.of(context).size.height,
          viewportFraction: 1.0,
          enlargeCenterPage: false,
    ),
      items: photos.map((item) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    image: DecorationImage(
                        alignment: Alignment.topCenter,
                        image: MemoryImage(item.photoBites),
                        fit: BoxFit.fill
                    )
                ),
            );
          },
        );
      }).toList(),
    );
  }
}
