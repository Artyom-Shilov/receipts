import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/navigation/controllers/app_navigation_state.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';

abstract interface class BaseNavigationCubit extends Cubit<AppNavigationState>{
  BaseNavigationCubit(super.initialState);

  void toBranch(Branches branch);

  void toRecipeList();
  void toLogin();

  void toRecipeInfo(Recipe recipe);
  void toCamera(Recipe recipe);
  void toUserPhotoGrid(Recipe recipe, RecipePhotoViewStatus mode);
  void toPhotoCarousel(Recipe recipe, int initIndex);
  void toPhotoCommenting(UserRecipePhoto photo, Recipe recipe);

  int findAppBarIndexByBranch();
  void navigateToBranchByAppBarIndex(bool isLoggedIn, int index);
  bool isShowingBottomAppBar();
  void changeOnPop();
  void onSetNewRoutePath(AppNavigationState newStat);
}