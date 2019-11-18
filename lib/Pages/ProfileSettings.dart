import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Edit.dart';

class ProfileSettings extends StatefulWidget {
  final Function signout;

  ProfileSettings({@required this.signout});

  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  var userData;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ////////////// 1st card///////////
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ////////////  first name ////////////

                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Color(0xFFFF835F),
                                  ),
                                ),
                                Text(
                                  'Name',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 17.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Text(
                                userData != null
                                    ? '${userData['name']} #${userData['id']}'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    ////////////// last name //////////////
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Color(0xFFFF835F),
                                  ),
                                ),
                                Text(
                                  'Nation',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 17.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Text(
                                userData != null
                                    ? '${userData['nation']}'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ////////////  Email/////////
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.mail,
                                    color: Color(0xFFFF835F),
                                  ),
                                ),
                                Text(
                                  'Email',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 17.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Text(
                                userData != null
                                    ? '${userData['email']}'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ////////////////////// phone ///////////
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.phone,
                                    color: Color(0xFFFF835F),
                                  ),
                                ),
                                Text(
                                  'Phone',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 17.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Text(
                                userData != null
                                    ? '${userData['phone']}'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ////////////////////// Age ///////////
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, top: 10, bottom: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 10, bottom: 10),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding:
                                      const EdgeInsets.only(right: 10),
                                  child: Icon(
                                    Icons.accessibility_new,
                                    color: Color(0xFFFF835F),
                                  ),
                                ),
                                Text(
                                  'Age',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 17.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 35),
                              child: Text(
                                userData != null
                                    ? '${userData['age']}'
                                    : '',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Color(0xFF9b9b9b),
                                  fontSize: 15.0,
                                  decoration: TextDecoration.none,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) {
                              return Edit();
                            },
                          ),
                        );
                      },
                      child: Card(
                        elevation: 4.0,
                        color: Colors.white,
                        margin: EdgeInsets.only(
                            left: 10, right: 10, top: 10, bottom: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 15, top: 10, bottom: 10),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(right: 10),
                                    child: Icon(
                                      Icons.accessibility_new,
                                      color: Color(0xFFFF835F),
                                    ),
                                  ),
                                  Text(
                                    'Profile Settings',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Color(0xFF9b9b9b),
                                      fontSize: 17.0,
                                      decoration: TextDecoration.none,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 35),
                                child: Text(
                                  'Manage Profile Settings',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF9b9b9b),
                                    fontSize: 15.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ////////////end  part////////////
                  ],
                ),

                /////////////// Button////////////

              ],
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
              onTap: () {
                print("KILL ME");
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return Edit();
                    },
                  ),
                );
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
              onTap: widget.signout,
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
