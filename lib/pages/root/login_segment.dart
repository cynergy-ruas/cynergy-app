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
      if (_formType == FormType.login) {
          User.login(_email, _password).then((userID){
            if (userID != null){
              _loading = false;
              widget.onSignedIn();
            } else {
              _showErrorDialog();
            }
          });
        }else{
          User.register(_email, _password).then((userID){
            if (userID != null){
              _loading = false;
              widget.onSignedIn();
            } else {
              _showErrorDialog();
            }
          });
        }
        setState(() {
          _loading = true;
        });
    }
  }

  void moveToRegister(){
    if(formKey.currentState != null){
      formKey.currentState.reset();
    }
    setState(() {
      _loading = false;
      _formType = FormType.register;
    });
  }

  void moveToLogin(){
    if(formKey.currentState != null){
      formKey.currentState.reset();
    }
    setState(() {
      _loading = false;
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context){
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: new AppBar(
        title: new Text("Cynergy"),
      ),
      body: buildPage(),
      backgroundColor: Colors.black87,
    );
  }

  Widget buildPage(){
    Widget c = Center(
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          new Container(
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10)
            ),
            child: Container(
              padding: EdgeInsets.all(20),
              height: 300,
              child: Form(
                key: formKey,
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: buildInputs() + buildSubmitButtons()
                ),
              ),
            )
          )
        ]
      ),
    );
    if (!_loading){
      return c;
    }
    return SplashPage();
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
        // new RaisedButton(
        //   child: new Text("login", style: new TextStyle(fontSize: 20.0),),
        //   onPressed: validateAndSumbit,
        // ),
        new IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: validateAndSumbit,
        ),
        new FlatButton(
          child: new Text("create an account", style: new TextStyle(fontSize: 16.0),),
          onPressed: moveToRegister,                
        )
      ];
    }
    return [
      new IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: validateAndSumbit,
      ),
      new FlatButton(
        child: new Text("Already have an account? login", style: new TextStyle(fontSize: 16.0),),
        onPressed: moveToLogin,                
      )
    ];
  }

  void _showErrorDialog(){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return new AlertDialog(
          title: Text("Error"),
          content: Text("Invalid username or password."),
          actions: <Widget>[
            FlatButton(
              child: Text("ok"),
              onPressed: () {
                Navigator.of(context).pop();
                moveToLogin();
              }
            )
          ],
        );
      }
    );
  }
}