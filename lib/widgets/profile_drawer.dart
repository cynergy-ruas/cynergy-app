import 'package:cynergy_app/bloc/auth_bloc.dart';
import 'package:cynergy_app/models/user_model.dart';
import 'package:cynergy_app/pages/manage_roles_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'misc_widgets.dart';
import 'package:flutter/material.dart';

class ProfileDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.5,
      child: Drawer(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 40,),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text("Edit profile",),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(),
            ),
          ] + (
                (User.getInstance().getClearanceLevel() > 0)
                ? [
                  GestureDetector(
                    child: ListTile(
                      leading: Icon(Icons.person_pin),
                      title: Text("Manage roles"),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        SlideFromRightPageRouteBuilder(page: ManageRolesPage())
                      );
                    }
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Divider(),
                  ),
                ]
                : []
          )
          + [
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Divider(),
                      GestureDetector(
                        child: ListTile(
                          title: Text(
                            "Logout",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        onTap: () {
                          // hacky
                          BlocProvider.of<AuthBloc>(context).dispatch(LogOut());
                        },
                      )
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }
}