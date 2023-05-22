import 'package:bloc/bloc.dart';

class FavouriteBtnCubit extends Cubit<int> {
  FavouriteBtnCubit() : super(1);


  // 0 is disable the button 
  // 1 is add 
  // 2 is remove
  void onFavChanged(int value) {
    emit(value);
  }
}
