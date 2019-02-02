import "package:flutter/material.dart";

class LoginPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{

  final formKey = new GlobalKey<FormState>();

  String _email;
  String _password;

  void validateAndSave(){
    final form = formKey.currentState;

    if(form.validate()){
      form.save();
      print("email: $_email, password: $_password");
    } else {
      print("Form is not valid");
    }
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
            children: <Widget>[
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
              new RaisedButton(
                child: new Text("login", style: new TextStyle(fontSize: 20.0),),
                onPressed: validateAndSave,
              )
            ],
          ),
        )
      )
    );
  }
}