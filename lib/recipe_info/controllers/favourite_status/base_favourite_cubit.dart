import 'package:bloc/bloc.dart';

import 'favourite_state.dart';

abstract interface class BaseFavouriteCubit extends Cubit<FavouriteState>{
  BaseFavouriteCubit(super.initialState);

  void changeFavouriteStatus();
}