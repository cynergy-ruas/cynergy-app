import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';

import 'package:cynergy_app/events/AuthenticationEvents.dart';
import 'package:cynergy_app/states/AuthenticationStates.dart';
import 'package:cynergy_app/repository/UserRepository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository userRepository;

  AuthenticationBloc({@required this.userRepository})
      : assert(userRepository != null);

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationState currentState, AuthenticationEvent event,) async* {
    if (event is AppStarted) {
      final bool isLoggedIn = await userRepository.isLoggedIn();

      if (isLoggedIn) {
        yield AuthenticationAuthenticated();
      } else {
        yield AuthenticationUnauthenticated();
      }
    }

    if (event is LoggedIn) {
      yield AuthenticationAuthenticated();
    }

    if (event is LoggedOut) {
      yield AuthenticationLoading();
      await userRepository.logout();
      yield AuthenticationUnauthenticated();
    }
  }
}