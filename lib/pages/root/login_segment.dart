import "package:flutter/material.dart";
import "../../utils/user/user.dart";
import "splash_segment.dart";

class LoginPage extends StatefulWidget{

  final VoidCallback onSignedIn;
  
  LoginPage({this.onSignedIn});
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType{
  login,
  register
}

class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;
  bool _loading = false;
  FormType _formType = FormType.login;

  bool validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSumbit() async{
    if(validateAndSave()){
      try{
        if (_formType == FormType.login) {
          User.login(_email, _password).then((userID){
            _loading = false;
            widget.onSignedIn();
          });
        }else{
          User.register(_email, _password).then((userID){
            _loading = false;
            widget.onSignedIn();
          });
        }
      }
      catch(e){
        print("Error: $e");
      }
    }

    setState(() {
      _loading = true;
    });
  }

  void moveToRegister(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Login page"),
      ),
      body: buildPage()
    );
  }

  List<Widget> buildInputs(){
    return [
      new TextFormField(
        decoration: new InputDecoration(labelText: "email"),
        validator: (value) => value.isEmpty ? "Email cannot be empty" : null,
        onSaved: (value) => _email = value,
      ),
      new TextFormField(
        decoration: new InputDecoration(labelText: "password"),
        obscureText: true,
        validator: (value) => value.isEmpty ? "Password cannot be empty" : null,
        onSaved: (value) => _password = value
      ),
    ];
  }

  List<Widget> buildSubmitButtons(){
    if (_formType == FormType.login){
      return [
        new RaisedButton(
          child: new Text("login", style: new TextStyle(fontSize: 20.0),),
          onPressed: validateAndSumbit,
        ),
        new FlatButton(
          child: new Text("create an account", style: new TextStyle(fontSize: 20.0),),
          onPressed: moveToRegister,                
        )
      ];
    }
    return [
      new RaisedButton(
        child: new Text("register", style: new TextStyle(fontSize: 20.0),),
        onPressed: validateAndSumbit,
      ),
      new FlatButton(
        child: new Text("Already have an account? login", style: new TextStyle(fontSize: 20.0),),
        onPressed: moveToLogin,                
      )
    ];
  }

  Widget buildPage(){
    if (!_loading){
      return new Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons()
          ),
        )
      );
    }
    return SplashPage();
  }
}