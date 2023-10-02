import 'package:flutter/cupertino.dart';
import 'package:receipts/recipe_info/controllers/base_cooking_step_controller.dart';

class CookingStepController with ChangeNotifier implements BaseCookingStepController {

  bool _doneStatus = false;

  @override
  void changeDoneStatus(){
   _doneStatus = !_doneStatus;
   notifyListeners();
  }

  @override
  bool get isDone => _doneStatus;
}