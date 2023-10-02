import 'package:flutter/widgets.dart';

abstract interface class BaseFavouriteStatusController with ChangeNotifier {

  void changeFavouriteStatus();
  bool get isFavourite;
}