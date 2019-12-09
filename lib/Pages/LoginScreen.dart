import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/Main/HomePage.dart';
import 'package:pharmacy/Main/States.dart';
import 'package:pharmacy/Utils/button.dart';
import 'package:pharmacy/Utils/modal_progress_hud.dart';
import 'package:pharmacy/api/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showSpinner = false;

  LoginStatus _loginStatus = LoginStatus.notSignIn;
  String email, password;
  final _key = new GlobalKey<FormState>();

  bool _secureText = true;

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
        return ModalProgressHUD(
          inAsyncCall: _showSpinner,
          child: Scaffold(
            backgroundColor: Colors.grey,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.all(15.0),
                children: <Widget>[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
//            color: Colors.grey.withAlpha(20),
                      color: Colors.grey,
                      child: Form(
                        key: _key,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 40,
                            ),
                            Hero(
                              tag: "logo",
                              child: Container(
                                height: 200.0,
                                child: Image.asset('images/search2.png'),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: Text(
                                "Login",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 30.0),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),

                            //card for Email TextFormField
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Please Insert Email";
                                  }
                                },
                                onSaved: (e) => email = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                    prefixIcon: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, right: 15),
                                      child: Icon(Icons.person,
                                          color: Colors.black),
                                    ),
                                    contentPadding: EdgeInsets.all(18),
                                    labelText: "Email"),
                              ),
                            ),

                            // Card for password TextFormField
                            Card(
                              elevation: 6.0,
                              child: TextFormField(
                                validator: (e) {
                                  if (e.isEmpty) {
                                    return "Password Can't be Empty";
                                  }
                                },
                                obscureText: _secureText,
                                onSaved: (e) => password = e,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  prefixIcon: Padding(
                                    padding:
                                        EdgeInsets.only(left: 20, right: 15),
                                    child: Icon(Icons.phonelink_lock,
                                        color: Colors.black),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: showHide,
                                    icon: Icon(_secureText
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                  ),
                                  contentPadding: EdgeInsets.all(18),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 12,
                            ),

                            FlatButton(
                              onPressed: null,
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.all(14.0),
                            ),

                            Hero(
                              tag: "login",
                              child: new Button(
                                text: "Login",
                                color: Colors.lightBlueAccent,
                                fn: () {
                                  setState(() {
                                    _showSpinner = true;
                                  });
                                  check();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        break;
      case LoginStatus.signIn:
        return HomePage();
//        return ProfilePage(signOut);
        break;
    }
  }

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      login();
    } else {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  login() async {
    var data = {
      'email' : email,
      'hashed_password' : password
    };
    var res = await CallApi().postData(data, 'signin');
    var body = json.decode(res.body);
    setState(() {
      _showSpinner = false;
    });
    print(body);

    if(!body['error']){
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      print(body['user']);
      setState(() {
        _loginStatus = LoginStatus.signIn;
      });
    }else{
      print("fail");
      loginToast("Login failed");
    }

  }

  loginToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  savePref(int value, String email, String name, String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("name", name);
      preferences.setString("email", email);
      preferences.setString("id", id);
      preferences.commit();
    });
  }

  var value;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      value = preferences.getInt("value");

      _loginStatus = value == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }
}
