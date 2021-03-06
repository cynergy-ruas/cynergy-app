/*
Contains the states, events, and bloc during logging in process. 
*/

import 'package:bloc/bloc.dart';
import 'package:cynergy_app/services/login.dart';
import 'package:cynergy_app/services/notifications.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:cynergy_app/models/user_model.dart';

////////////////////////////////////////////
/// Defining the events
////////////////////////////////////////////

/// The base class
abstract class AuthEvent extends Equatable {
  AuthEvent([List props = const []]) : super(props);
}

/// The event emitted when the app first starts
class AppStart extends AuthEvent {
  @override
  String toString() => "App started.";
}

/// The event emitted when the user attempts to log in
class LogIn extends AuthEvent {
  final String email;
  final String password;

  LogIn({@required this.email, @required this.password}) : super([email, password]);

  @override
  String toString() => "User is logging in";
}

/// The event emitted when the user attempts to logs out
class LogOut extends AuthEvent {
  @override
  String toString() => "User is logging out";
}

////////////////////////////////////////////
/// Defining the states
////////////////////////////////////////////

/// The base class
abstract class AuthState extends Equatable {}

/// The state when the authentication is not initialized, initial state
class AuthUninitialized extends AuthState {
  String toString() => "AuthenticationUninitialized";
}

/// The state when the authentication is valid
class AuthValid extends AuthState {
  String toString() => "AuthenticationValid";
}

/// The state when authentication is invalid/when user has logged out/when user has not logged in
class AuthInvalid extends AuthState {
  String toString() => "AuthenticationInvalid";
}

/// The state when authentication is loading
class AuthLoading extends AuthState {
  String toString() => "AuthLoading";
}

/// The state when an error occurs while logging in
class AuthError extends AuthState {
  String toString() => "AuthError";
}

////////////////////////////////////////////
/// Defining the Bloc. Logic goes here
////////////////////////////////////////////

class AuthBloc extends Bloc<AuthEvent, AuthState> {

  LoginAuth _auth = LoginAuth.getInstance();

  @override
  AuthState get initialState => AuthUninitialized();

  @override
  Stream<AuthState> mapEventToState(AuthState currentState, AuthEvent event) async* {
    /**
    * Maps auth events to auth states.
    * 
    * Args:
    *  currentState (AuthState): The current state.
    *  event (AuthEvent): The event generated by user/system.
    *
    * Yields:
    *  AuthState: The state to change to in response to events.
    */

    if (event is AppStart) {
      /// check if user is logged in, then do stuff
      yield AuthUninitialized();

      var user = User.getInstance();
      /// checking if user is already logged in
      if (await _auth.isLoggedIn()) {
        user.setClaims(await _auth.getClaims());
        yield AuthValid();
      }
      else
        /// user has not logged in, yield AuthInvalid
        yield AuthInvalid();
    }

    else if (event is LogIn) {
      yield AuthLoading();
      
      try{
        /// logging in
        await _auth.login(email: event.email, password: event.password);
        // setting claims
        User.getInstance().setClaims(await _auth.getClaims());
        // subscribing device to topic for new event notifications
        FirebaseNotifications.instance().subscribeToNewEvents();

        print("User has logged in.");
        yield AuthValid();
      }
      catch (e) {
        /// error occured while logging in
        yield AuthError();
      }
    }

    else if (event is LogOut){
      yield AuthLoading();
      // unsubscribing device from new events notifications
      FirebaseNotifications.instance().unsubsribeFromNewEvents();
      /// logging out
      await _auth.logout();
      yield AuthInvalid();
    }
  }
  
}
