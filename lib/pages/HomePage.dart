import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/repository/UserRepository.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';

class HomePage extends StatelessWidget {
  @override

  UserRepository userRepository;

  HomePage({@required this.userRepository}):
      assert(userRepository != null);

  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    bool isCoordinator = userRepository.isCoordinator();

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              authenticationBloc.dispatch(LoggedOut());
            },
          )
        ],
      ),
      body: Center(
        child: Text("Welcome: coordinator: $isCoordinator"),
      ),
    );
  }
}