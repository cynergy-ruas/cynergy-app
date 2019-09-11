import 'package:Cynergy/bloc/auth_bloc.dart';
import 'package:Cynergy/pages/home_page.dart';
import 'package:Cynergy/widgets/login_form.dart';
import 'package:Cynergy/widgets/modal_barrier.dart';
import 'package:Cynergy/widgets/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginPage extends StatefulWidget {  
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthBloc authBloc = AuthBloc();

  @override
  void initState() {
    authBloc.dispatch(AppStart());
    super.initState();
  }

  void toggleVisibility(){
    setState(() {
      LoginForm.isHidden = !LoginForm.isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Contains a bloc builder which returns widgets depending
    /// on the current state of the authentication bloc, i.e
    /// if the user has logged in or not

    List<Widget> body = List<Widget>();
    return Container(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocBuilder<AuthEvent, AuthState>(
          bloc: authBloc,
          builder: (BuildContext context, AuthState state){
            if (state is AuthUninitialized) {
              body.add(SplashScreen());
            }

            else if (state is AuthValid){
              /// if the state is AuthValid, switch to home page
              /// Note: You cannot use [Navigator.push] here inside a builder directly.
              /// This is because when [Navigator.push] is called, it triggers the
              /// [BlocBuilder] to build. Since the state remains the same when it
              /// is rebuilding, [Navigator.push] is again called. In the end, 
              /// [Navigator.push] is called infinite number of times and app crashes.
              /// To use [Navigator.push], wrap this [BlocBuilder] around a [BlocListener]
              /// and listen for [AuthValid] state there.
              return HomePage();
            }

            else if (state is AuthInvalid) {
              /// if state is AuthInvalid, show the login prompts
              try {
                body.removeAt(0); /// removing the SplashScreen widget already present in the list
              }
              catch (e) {}
              body.add(LoginForm(authBloc: authBloc,));
            }

            else if (state is AuthLoading){
              /// if state is AuthLoading, show loading thingy
              body = new List.from(body)..addAll(loadingModalBarrier());
            }
            
            else {
              /// state is AuthError. show error prompt
              /// best practice is to show the snackbar in a [BlocListener] which
              /// should be wrapped around this [BlocBuilder]
              _onWidgetDidBuild(() {
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Error logging in"),
                    backgroundColor: Colors.red,
                  )
                );
              });
              
              /// removes the loading modal barrier if present.
              print(body);
              print(body.length);
              if (body.length > 1) {
                try {
                  /// removes the modal barrier and circularprogressindicator, which are the 
                  /// second and third elements in the list
                  body.removeAt(1);
                  body.removeAt(1);
                }
                catch (e) {}
              }
              print(body);
            }

            /// returning a scaffold object with body
            return Stack(
              children: body,
            );
          },
        ),
      ),
    );
  }

  void _onWidgetDidBuild(Function callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      callback();
    });
  }
}