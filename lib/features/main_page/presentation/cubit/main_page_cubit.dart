import 'package:flutter_bloc/flutter_bloc.dart';

class MainPageCubit extends Cubit<int> {
  MainPageCubit() : super(0);

  void changeIndex(int index) => emit(index);
  
  void goToDashboard() => emit(0);
  
  void goToProfile() => emit(4);
}
