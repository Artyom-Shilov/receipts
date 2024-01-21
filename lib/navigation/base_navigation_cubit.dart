import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:receipts/common/models/models.dart';
import 'package:receipts/common/models/recipe.dart';
import 'package:receipts/navigation/app_navigation_state.dart';
import 'package:receipts/recipe_info/controllers/controllers.dart';

abstract interface class BaseNavigationCubit extends Cubit<AppNavigationState>{
  BaseNavigationCubit(super.initialState);

  void toBranch(Branches branch);

  void toRecipeList();

  void toRecipeInfo(Recipe recipe);
  void toCamera(Recipe recipe);
  void toUserPhotoGrid(Recipe recipe, RecipePhotoViewStatus mode);
  void toPhotoCarousel(List<UserRecipePhoto> photos, int initIndex);
  void toPhotoCommenting(UserRecipePhoto photo);
  void toRegistration();
  void toLogin();

  int findAppBarIndexByBranch();
  void navigateToBranchByAppBarIndex(bool isLoggedIn, int index);
  void changeStateOnPop();
}