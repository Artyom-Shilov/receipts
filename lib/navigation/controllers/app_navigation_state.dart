import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:receipts/navigation/controllers/nested_branch_state.dart';

part 'app_navigation_state.freezed.dart';

enum Pages {
  recipeList,
  recipeInfo,
  camera,
  userPhotos,
  carousel,
  commenting_photo,
  favouriteList,
  profile,
  login;

  static Pages fromString(String string) {
    return Pages.values.firstWhere((element) => element.name == string);
  }
}

enum Branches {
  recipes,
  login,
  profile,
  favourite,
  page_not_found;

  static Branches fromString(String string) {
    return Branches.values.firstWhere((element) => element.name == string);
  }
}

@freezed
class AppNavigationState with _$AppNavigationState {
  const factory AppNavigationState({
    required Branches currentBranch,
    required NestedBranchState favouriteBranchState,
    required NestedBranchState recipeBranchState,
    @Default(false) bool isBranchChanged,
  }) = _AppNavigationState;
}