import "package:flutter/material.dart";
import "package:firebase_auth/firebase_auth.dart";

class LoginPage extends StatefulWidget{
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
          FirebaseUser user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          print("Signed in: ${user.uid}");
        }else{
          FirebaseUser user = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email, password: _password);
          print("Registed user: ${user.uid}");
        }
      }
      catch(e){
        print("Error: $e");
      }
    }
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
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildInputs() + buildSubmitButtons()
          ),
        )
      )
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
}