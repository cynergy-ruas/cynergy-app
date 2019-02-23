import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/repository/UserRepository.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/events/AuthenticationEvents.dart';

class HomePage extends StatefulWidget {

  UserRepository userRepository;

  HomePage({@required this.userRepository}):
        assert(userRepository != null);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  UserRepository get _userRepository => widget.userRepository;

  @override
  Widget build(BuildContext context) {
    final AuthenticationBloc authenticationBloc =
    BlocProvider.of<AuthenticationBloc>(context);

    bool isCoordinator = _userRepository.isCoordinator();

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