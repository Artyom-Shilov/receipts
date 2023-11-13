import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/favourite_state.dart';

abstract interface class BaseFavouriteCubit extends Cubit<FavouriteState>{
  BaseFavouriteCubit(super.initialState);

  void changeFavouriteStatus();
}