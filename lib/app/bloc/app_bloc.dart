import 'dart:async';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc({required AuthenticationRepository authenticationRepository})
      : _authenticationRepository = authenticationRepository,
        super(
          authenticationRepository.currentUser.isNotEmpty
              ? AppState.authenticated(authenticationRepository.currentUser)
              : const AppState.unauthenticated(),
        ) {
    on<AppUserChanged>(_onUserChanged);

    _userSubscription = _authenticationRepository.user.listen(
      (u) => add(AppUserChanged(u)),
    );

    _loginAnon();
  }

  final AuthenticationRepository _authenticationRepository;
  late final StreamSubscription<User> _userSubscription;

  Future<void> _loginAnon() async {
    await _authenticationRepository.logInWithAnon();
  }
}

void _onUserChanged(AppUserChanged event, Emitter<AppState> emit) {
  emit(event.user.isNotEmpty
      ? AppState.authenticated(event.user)
      : const AppState.unauthenticated());
}
