import 'package:flutter/material.dart';

class ProfileSettings extends StatelessWidget {
  final Function signout;

  ProfileSettings({@required this.signout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: () {
                print("hi");
              },
              child: ListTile(
                title: Text("Profile Setting"),
                subtitle: Text("Manage Profile Settings"),
              ),
            ),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              child: ListTile(
                title: Text("Cars Setting"),
                subtitle: Text("Manage Cars Sorting settings"),
              ),
              onTap: () {
                print("hi");
              },
            ),
          ),

          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              child: ListTile(
                title: Text("Payments"),
                subtitle: Text("Manage Payments Method"),
              ),
              onTap: () {
                print("meaw");
              },
            ),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              child: ListTile(
                title: Text("Contact Setting"),
                subtitle: Text("Manage Contact Settings"),
              ),
              onTap: () {
                print("meaw");
              },
            ),
          ),
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: InkWell(
              onTap: signout,
              child: ListTile(
                title: Text("Sign out"),
                subtitle: Text("Sign out of your account"),
              ),
            ),
          ),
//          CollapsingNavigationDrawer(),
        ],
      ),
    );
  }
}
