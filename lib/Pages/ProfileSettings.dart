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
    print(userJson);
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
                Center(
                  child: Text(
                    "_____________________\n",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Profile Info",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ////////////// 1st card///////////
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
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
                                ? '${userData['name']}'
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
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin:
                  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.supervisor_account,
                                color: Color(0xFFFF835F),
                              ),
                            ),
                            Text(
                              'User id',
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
                            userData != null ? '${userData['userId']}' : '',
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
                  margin:
                      EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
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
                            userData != null ? '${userData['email']}' : '',
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

                Center(
                  child: Text(
                    "_____________________\n",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
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
                      padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.contact_mail,
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
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                ),
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.dock,
                                color: Color(0xFFFF835F),
                              ),
                            ),
                            Text(
                              'Medicine Settings',
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
                            'Manage Medicine Sorting Settings',
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

                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.payment,
                                color: Color(0xFFFF835F),
                              ),
                            ),
                            Text(
                              'Payments Settings',
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
                            'Manage Payments Methods',
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
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: EdgeInsets.only(
                      left: 10, right: 10, top: 10, bottom: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.contacts,
                                color: Color(0xFFFF835F),
                              ),
                            ),
                            Text(
                              'Contact Settings',
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
                            'Manage Contact info/requests',
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
                  onTap: (){print("asd");},
                  child: Card(
                    elevation: 4.0,
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      padding: EdgeInsets.only(left: 15, top: 10, bottom: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Icon(
                                  Icons.exit_to_app,
                                  color: Color(0xFFFF835F),
                                ),
                              ),
                              Text(
                                  'Sign out',
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
                              'Sign out of your account',
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

                /////////////// Button////////////
              ],
            ),
          ),

        ],
      ),
    );
  }
}
