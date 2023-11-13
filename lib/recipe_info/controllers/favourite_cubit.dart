import 'package:bloc/bloc.dart';
import 'package:receipts/recipe_info/controllers/base_favourite_cubit.dart';
import 'package:receipts/recipe_info/controllers/favourite_state.dart';

class FavouriteCubit extends Cubit<FavouriteState> implements BaseFavouriteCubit {

  FavouriteCubit() : super(const FavouriteState(isFavourite: false));

  @override
  void changeFavouriteStatus() {
    emit(state.copyWith(isFavourite: !state.isFavourite));
  }
}