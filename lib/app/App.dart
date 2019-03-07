import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';
import 'package:cynergy_app/pages/HomePage.dart';
import 'package:cynergy_app/pages/LoginPage.dart';
import 'package:cynergy_app/pages/SplashPage.dart';
import 'package:cynergy_app/repository/UserRepository.dart';
import 'package:cynergy_app/states/AuthenticationStates.dart';
import 'package:cynergy_app/widgets/LoadingIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cynergy_app/pages/HomePage.dart';
class App extends StatefulWidget {
  final UserRepository userRepository;

  App({Key key, @required this.userRepository}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  AuthenticationBloc authenticationBloc;
  UserRepository get userRepository => widget.userRepository;

  @override
  void initState() {
    authenticationBloc = AuthenticationBloc(userRepository: userRepository);
    authenticationBloc.dispatch(AppStarted());
    super.initState();
  }

  @override
  void dispose() {
    authenticationBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthenticationBloc>(
      bloc: authenticationBloc,
      child: MaterialApp(
        theme: themeData,
        home: BlocBuilder<AuthenticationEvent, AuthenticationState>(
          bloc: authenticationBloc,
          builder: (BuildContext context, AuthenticationState state) {
            if (state is AuthenticationUninitialized) {
              return SplashPage();
            }
            if (state is AuthenticationAuthenticated) {
              return HomePage(userRepository: userRepository,);
            }
            if (state is AuthenticationUnauthenticated) {
              return LoginPage(userRepository: userRepository);
            }
            if (state is AuthenticationLoading) {
              return LoadingIndicator();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}