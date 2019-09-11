import 'package:cynergy_app/models/user_model.dart';
import 'package:cynergy_app/services/cloud_functions.dart';
import 'package:cynergy_app/widgets/misc_widgets.dart';
import 'package:flutter/material.dart';

class ManageRolesPage extends StatefulWidget {
  @override
  _ManageRolesPageState createState() => _ManageRolesPageState();
}

class _ManageRolesPageState extends State<ManageRolesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 30),
        child: Column(
          children: <Widget>[
            _header(),
            Expanded(
              child: _body(context),
            ),
          ],
        ),
      )
    );
  }

  Widget _header() {
    /**
     * Constructs the header.
     * 
     * Returns:
     *  Widget: The header.
     */

    return Row(
      children: <Widget>[
        BackButtonNoBackground(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Icon(Icons.person_pin),
              SizedBox(width: 10,),
              Text("Manage roles", style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        )
      ],
    );
  }

  Widget _body(BuildContext context) {
    /**
     * Constructs the body.
     * 
     * Args:
     *  context (BuildContext): The current [BuildContext]
     * Returns:
     *  Widget: The body.
     */

    int clearance = User.getInstance().getClearanceLevel();
    String level = "Member";

    if (clearance == 1)
      level = "Coordinator";
    else if (clearance == 2)
      level = "Core";

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text("Your Level", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
            Text(
              clearance.toString(),
              style: TextStyle(fontSize: 140, fontWeight: FontWeight.bold)
            ),
            Text(
              level,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
            ),
            SizedBox(height: 60,),
          ] + ((clearance == 2)
              ? [
                _ManageRoleWidget()
              ]
              : []
            ),
        ),
      )
    );
  }
}

class _ManageRoleWidget extends StatefulWidget {
  @override
  __ManageRoleWidgetState createState() => __ManageRoleWidgetState();
}

class __ManageRoleWidgetState extends State<_ManageRoleWidget> {

  bool _isInputMode;
  GlobalKey<FormState> _formKey;

  String email;
  int clearance;

  @override
  void initState() {
    super.initState();
    _isInputMode = false;
    _formKey = GlobalKey<FormState>();

    clearance = 0;
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (! _isInputMode) {
      body = Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                color: Theme.of(context).accentColor,
                child: Text("Manage Roles", style: TextStyle(fontWeight: FontWeight.bold),),
                onPressed: () {
                  setState(() {
                    _isInputMode = true;
                  });
                },
              ),
            )
          ],
        ),
      );
    } else {
      body = Container(
        padding: EdgeInsets.all(10),
        color: Theme.of(context).dialogBackgroundColor,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text("Enter details of user: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.email),
                  Expanded(
                    child: TextFormField( 
                      decoration: InputDecoration(
                        fillColor: Colors.transparent,
                        filled: true,
                        hintText: "Email"
                      ),
                      onSaved: (value) => email = value,
                    ),
                  )
                ],
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Divider(),),
              SizedBox(height: 20,),
              Row(
                children: <Widget>[
                  SizedBox(width: 10,),
                  Icon(Icons.person_pin),
                  SizedBox(width: 10,),
                  Expanded(child: Text("Clearance", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),)
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: SizedBox(
                  width: 170,
                  child: DropdownButton(
                    isExpanded: true,
                    value: clearance,
                    items: <DropdownMenuItem<int>> [
                      DropdownMenuItem(
                        value: 0,
                        child: Text("0 (Member)"),
                      ),
                      DropdownMenuItem(
                        value: 1,
                        child: Text("1 (Coordinator)"),
                      ),DropdownMenuItem(
                        value: 2,
                        child: Text("2 (Core)"),
                      ),
                    ],
                    onChanged: (value) => setState(() {
                      clearance = value;
                    }),
                  ),
                )
              ),
              SizedBox(height: 30,),
              Center(
                child: FlatButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                  child: Text("Assign", style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      email = email.trim();
                      
                      showConfirmDialog(
                        context: context,
                        message: "Are you sure you want to give $email a clearance level of $clearance?",
                        onConfirm: () {
                          showStatusDialog(
                            context: context,
                            message: "Clearance updated!", 
                            future: () async {
                              // await Future.delayed(Duration(seconds: 1));
                              await updateClearanceForUser(email: email, clearance: clearance);
                            }
                          );
                        }
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 30,)
            ],
          )
        )
      );
    }


    return Padding(
      padding: EdgeInsets.all(10),
      child: body,
    );
  }
}