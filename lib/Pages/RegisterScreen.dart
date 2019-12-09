import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/Main/HomePage.dart';
import 'package:pharmacy/Utils/button.dart';
import 'package:pharmacy/Utils/modal_progress_hud.dart';
import 'package:pharmacy/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginScreen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String name, email, password;
  final _key = new GlobalKey<FormState>();
  bool _showSpinner = false;
  bool _secureText = true;

  showHide() {
    setState(() {
      _secureText = !_secureText;
    });
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      save();
    } else {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  save() async {
    var data = {
      "name": name,
      "email": email,
      "hashed_password": password,
    };
    print("Meaw\n");
    var res = await CallApi().postData(data, 'signup');
    var body = json.decode(res.body);
    print("meaaaw ${res.body}");
    print("asmarany ${body['error']}");
    if (!body['error']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
//      localStorage.setString('token', body['token']);
      print("${json.encode(body['user'])}");
      localStorage.setString('user', json.encode(body['user']));
      print(body['user']);

      setState(
        () {
          Navigator.push(
            context,
            new CupertinoPageRoute(builder: (context) => HomePage()),
          );
        },
      );
      registerToast("Please login using $email");
    } else {
      registerToast("Error Ocured");
    }

    setState(() {
      _showSpinner = false;
    });
  }

  registerToast(String toast) {
    return Fluttertoast.showToast(
        msg: toast,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
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
                  color: Colors.grey,
                  child: Form(
                    key: _key,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 40,
                        ),
                        SizedBox(
                          height: 50,
                          child: Text(
                            "Register",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30.0),
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),

                        //card for Fullname TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Full Name";
                              }
                            },
                            onSaved: (e) => name = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            decoration: InputDecoration(
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child:
                                      Icon(Icons.person, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Fullname"),
                          ),
                        ),

                        //card for Email TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Please insert Email";
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
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.email, color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Email"),
                          ),
                        ),

                        //card for Password TextFormField
                        Card(
                          elevation: 6.0,
                          child: TextFormField(
                            obscureText: _secureText,
                            onSaved: (e) => password = e,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                            validator: (e) {
                              if (e.isEmpty) {
                                return "Password Can't be Empty";
                              }
                            },
                            decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: showHide,
                                  icon: Icon(_secureText
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                ),
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(left: 20, right: 15),
                                  child: Icon(Icons.phonelink_lock,
                                      color: Colors.black),
                                ),
                                contentPadding: EdgeInsets.all(18),
                                labelText: "Password"),
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(12.0),
                        ),
                        Hero(
                          tag: "register",
                          child: new Button(
                            text: "Register",
                            color: Colors.blue,
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
  }
}
