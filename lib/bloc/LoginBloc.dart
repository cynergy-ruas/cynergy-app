import 'dart:async';

import 'package:meta/meta.dart';
import 'package:bloc/bloc.dart';
import 'package:cynergy_app/repository/UserRepository.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/states/LoginStates.dart';
import 'package:cynergy_app/events/LoginEvents.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final UserRepository userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.userRepository,
    @required this.authenticationBloc,
  })  : assert(userRepository != null),
        assert(authenticationBloc != null);

  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginState currentState, LoginEvent event,) async* {
    if (event is LoginButtonPressed) {
      yield LoginLoading();

      try {
        final token = await userRepository.login(
          email: event.email,
          password: event.password,
        );
        await userRepository.setClaims();
        authenticationBloc.dispatch(LoggedIn(token: token));
        yield LoginInitial();
      } catch (error) {
        yield LoginFailure(error: "Invalid username or password");
      }
    }
  }
}