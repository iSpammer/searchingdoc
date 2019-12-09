import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Pages/LoginScreen.dart';
import 'package:pharmacy/Pages/RegisterScreen.dart';
import 'package:pharmacy/Utils/button.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  Animation _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        new AnimationController(duration: Duration(seconds: 2), vsync: this);
    _animation =
        ColorTween(begin: Colors.blue, end: Colors.grey).animate(_controller);
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: "logo",
                  child: Container(
                    child: Image.asset('images/search2.png'),
                    height: 60,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Center(
                  child: TypewriterAnimatedTextKit(
                    text: ['The Searching Doc!'],
                    textStyle: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Hero(
              tag: "login",
              child: new Button(
                text: "Login",
                color: Colors.lightBlueAccent,
                fn: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (
                        BuildContext context,
                      ) =>
                          LoginScreen(),
                    ),
                  );
                },
              ),
            ),
            Hero(
              tag: "register",
              child: new Button(
                text: "Register",
                color: Colors.blue,
                fn: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (
                        BuildContext context,
                      ) =>
                          RegisterScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
