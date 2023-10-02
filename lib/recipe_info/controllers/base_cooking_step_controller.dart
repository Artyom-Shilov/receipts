import 'package:flutter/widgets.dart';

abstract interface  class BaseCookingStepController with ChangeNotifier {

  void changeDoneStatus();
  bool get isDone;
}