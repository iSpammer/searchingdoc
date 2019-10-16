import 'package:flutter/material.dart';
import 'package:gocars/MapScreen.dart';
import 'package:gocars/Pages/IntroScreen.dart';
import 'package:gocars/Pages/WelcomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

import 'Main/HomePage.dart';

final routeObserver = RouteObserver<PageRoute>();

@override
void initState() {
//  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//    statusBarColor: Constants.lightPrimary,
//    statusBarIconBrightness: Brightness.dark,
//  ));
}

Future<void> main() async {
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//      statusBarIconBrightness: Brightness.dark,
//      statusBarColor: Colors.transparent));

  SharedPreferences prefs = await SharedPreferences.getInstance();
  var userId = prefs.getString('id');
//  var name = prefs.getString('username');

  return runApp(
    MaterialApp(
      title: "Go Cars!",
      home: new SplashScreen(
          seconds: 2,
          navigateAfterSeconds: userId == null ? IntroScreen() : HomePage(),
          title: Text('Go Cars!'),
          loadingText: Text("Drive And Chill!"),
          image: new Image.asset('images/search.png'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red),
//    home: ,
      navigatorObservers: [routeObserver],
    ),
  );
}

class App extends StatelessWidget {
  final Function home;

  App(this.home);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "GoCars",
      home: home(),
      navigatorObservers: [routeObserver],
    );
  }
}
