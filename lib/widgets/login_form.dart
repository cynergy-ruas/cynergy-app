import 'package:cynergy_app/bloc/auth_bloc.dart';
import 'package:cynergy_app/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:gradient_text/gradient_text.dart';

class LoginForm extends StatelessWidget {

  final AuthBloc authBloc;

  final _emailidController = TextEditingController();
  final _passwordController = TextEditingController();
  final textFieldRadius = 20.0;

  LoginForm({@required this.authBloc});

  @override
  Widget build(BuildContext context) {
    /*
    Returns the widget to be displayed.

    Args:
      context (BuildContext): The build context

    Returns:
      Container: The widget to be displayed.
    */

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 100),
        // ScrollConfiguration is used to remove the glowing overscroll effect.
        child: ScrollConfiguration(
          behavior: NoGlowingOverscrollBehaviour(),
          child: ListView(
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft,
                child: headerText()
              ),
              SizedBox(height: 100,),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: textFields()
              ),
              SizedBox(height: 70,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: buttons()
              )
            ]
          ),
        )
      );
  }

  Widget headerText() {
    /*
    Returns the header text.

    Returns:
      GradientText: The header text.
    */

    return GradientText("Nice\nTo see you\nAgain",
      gradient: LinearGradient(
        colors: [gradientPurple, gradientLightYellow]
      ),
      style: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w600,
        fontFamily: "Calibre-Semibold",
      ),
    );
  }

  List<Widget> textFields() {
    /*
    Returns the text fields.

    Returns:
      List<Widget>: The text form fields.
    */

    return [
      TextFormField(
        decoration: textFieldInputDecoration(
          textFieldRadius: textFieldRadius,
          icon: Icon(Icons.person, color: Colors.white,),
          hintText: "email"
        ),
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Calibre-Semibold",
          letterSpacing: 1.25
        ),
        controller: _emailidController,
        cursorColor: Colors.white,
      ),

      SizedBox(height: 15,),
      
      TextFormField(
        decoration: textFieldInputDecoration(
          textFieldRadius: textFieldRadius,
          icon: Icon(Icons.lock_outline, color: Colors.white),
          hintText: "password"
        ),
        style: TextStyle(
          color: Colors.white,
          fontFamily: "Calibre-Semibold",
          letterSpacing: 1.25
        ),
        controller: _passwordController,
        obscureText: true,
        cursorColor: Colors.white,
      )
    ];
  }

  List<Widget> buttons() {
    /*
    Returns the login buttons.

    Returns:
      List<Widget>: The login button.
    */
    
    return [
      Text("Sign In",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: colorLightOrange,
          fontFamily: "Calibre-Semibold",
        ),
      ),

      SizedBox(width: 30,),

      IconButton(
        icon: Icon(Icons.arrow_forward),
        iconSize: 30,
        color: colorLightOrange,
        onPressed: () {
          authBloc.dispatch(LogIn(
            email: _emailidController.text.trim(),
            password: _passwordController.text
          ));
        },
      )
    ];
  }
}