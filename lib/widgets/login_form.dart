import 'package:Cynergy/bloc/auth_bloc.dart';
import 'package:Cynergy/pages/login_page.dart';
import 'package:Cynergy/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:Cynergy/pages/login_page.dart';
import 'package:gradient_text/gradient_text.dart';
import 'misc_widgets.dart';

class LoginForm extends StatelessWidget {
  final AuthBloc authBloc;
  final _emailidController = TextEditingController();
  final _passwordController = TextEditingController();
  final textFieldRadius = 20.0;
  static bool isHidden = true;
  Color col=Colors.white;

  LoginForm({@required this.authBloc});


  @override
  Widget build(BuildContext context) {
    col = Theme.of(context).accentColor;
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
          child: ListView(children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              headerText1(),headerText2(),
            ],),
            // SizedBox(
            //   height: 100,
            // ),
            Center(
              child: Text("Bigger, Better, Open-Source and Free for all."),
            ),
            SizedBox(
              height: 100,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: textFields()),
            SizedBox(
              height: 80,
            ),
            Align(
              alignment: Alignment.center,
                child: buttons())
          ]),
        ));
  }

  Widget headerText1() {//make this list of widgets
    /*
    Returns the header text.

    Returns:
      GradientText: The header text.
      
    */
    return Text(
      "Cy",
      // gradient: LinearGradient(colors: [gradientPurple, gradientLightYellow]),
      style: TextStyle(
        color: Colors.white,
        fontSize: 80,
        fontWeight: FontWeight.w600,
        fontFamily: "Calibre-Semibold",
      ),
    );
    

  }

Widget headerText2() {//make this list of widgets
    /*
    Returns the header text.

    Returns:
      GradientText: The header text.
      
    */
    return Text(
      "nergy",
      // gradient: LinearGradient(colors: [gradientPurple, gradientLightYellow]),
      style: TextStyle(
        color: col,
        fontSize: 80,
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
        decoration: InputDecoration(hintText: "Email"),
        style: TextStyle(fontFamily: "Calibre-Semibold", letterSpacing: 1.25),
        controller: _emailidController,
        cursorColor: Colors.white,
      ),
      SizedBox(
        height: 15,
      ),
      TextFormField(
        decoration: InputDecoration(
            hintText: "Password",
            suffixIcon: IconButton(
              onPressed: (){},
              icon: isHidden
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
            )),
        style: TextStyle(fontFamily: "Calibre-Semibold", letterSpacing: 1.25),
        controller: _passwordController,
        obscureText: isHidden,
        cursorColor: Colors.white,
      )
    ];
  }

  Widget buttons() {
    /*
    Returns the login buttons.

    Returns:
      List<Widget>: The login button.
    */

    return Container(
          child: ButtonTheme(
        minWidth: 300.0,
        height: 50,
        child: RaisedButton(
          child: Text(
            "Sign In",
          ),
          color: col,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
          onPressed: () {
            authBloc.dispatch(LogIn(
                email: _emailidController.text.trim(),
                password: _passwordController.text));
          },
        ),
      ));
  }
}
