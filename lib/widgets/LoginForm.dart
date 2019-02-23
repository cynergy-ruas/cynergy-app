import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cynergy_app/bloc/AuthenticationBloc.dart';
import 'package:cynergy_app/bloc/LoginBloc.dart';
import 'package:cynergy_app/events/LoginEvents.dart';
import 'package:cynergy_app/states/LoginStates.dart';

class LoginForm extends StatefulWidget {
  final LoginBloc loginBloc;
  final AuthenticationBloc authenticationBloc;

  LoginForm({
    Key key,
    @required this.loginBloc,
    @required this.authenticationBloc,
  }) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  LoginBloc get _loginBloc => widget.loginBloc;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginEvent, LoginState>(
      bloc: _loginBloc,
      builder: (
          BuildContext context,
          LoginState state,
          ) {
        if (state is LoginFailure) {
          _onWidgetDidBuild(() {
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.error}'),
                backgroundColor: Colors.red,
              ),
            );
          });
        }

        return Center(
          child: Container(
            child: Form(
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'username'),
                    controller: _usernameController,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'password'),
                    controller: _passwordController,
                    obscureText: true,
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward),
                    onPressed:
                    state is! LoginLoading ? _onLoginButtonPressed : null,
                  ),
                  Container(
                    child:
                    state is LoginLoading ? CircularProgressIndicator() : null,
                  ),
                ],
              ),
            ),
            constraints: BoxConstraints(
              minHeight: 250,
              maxHeight: 300,
              minWidth: 250,
              maxWidth: 300,
            ),
          )
        );
      },
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }

  _onLoginButtonPressed() {
    _loginBloc.dispatch(LoginButtonPressed(
      email: _usernameController.text,
      password: _passwordController.text,
    ));
  }
}