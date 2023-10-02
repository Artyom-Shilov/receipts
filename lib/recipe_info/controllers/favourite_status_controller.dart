import 'package:flutter/cupertino.dart';
import 'package:receipts/recipe_info/controllers/base_favourite_status_controller.dart';

class FavouriteStatusController with ChangeNotifier implements BaseFavouriteStatusController {

  bool _status = false;

  @override
  void changeFavouriteStatus() {
    _status = !_status;
    notifyListeners();
  }

  @override
  bool get isFavourite => _status;
}
