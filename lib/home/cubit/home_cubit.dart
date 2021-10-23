import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:songs_repository/songs_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit({required FirestoreSongsRepository repository})
      : super(const HomeState.init());

  Future<void> loadScreen(String id) async {
    await Future.delayed(const Duration(seconds: 3), () {});

    emit(const HomeState.loaded());
  }
}
