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

 main()  {
  WidgetsFlutterBinding.ensureInitialized();
  // This app is designed only to work vertically, so we limit
  // orientations to portrait up and down.
//  SystemChrome.setPreferredOrientations(
//      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
//  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
//      statusBarIconBrightness: Brightness.dark,
//      statusBarColor: Colors.transparent));

//
//    bool _isLoggedIn = false;
//
////  var name = prefs.getString('username');
//    // check if token is there
//    SharedPreferences localStorage = await SharedPreferences.getInstance();
//    var token = localStorage.getString('token');
//    print("$token asddddd");
//    if(token!= null) {
//      _isLoggedIn = true;
//      print("meaaaaaaw");
//    }
//    else{
//      print("fml");
//      _isLoggedIn = false;
//    }

  return runApp(
   Runner(),
  );
}

class Runner extends StatefulWidget {

  @override
  _RunnerState createState() => _RunnerState();
}

class _RunnerState extends State<Runner> {
  bool _isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin();
  }
  _checkLogin() async {

    bool _isLoggedIn = false;

//  var name = prefs.getString('username');
    // check if token is there
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    print("$token asddddd");
    if(token!= null) {
      _isLoggedIn = true;
      print("meaaaaaaw");
    }
    else{
      print("fml");
      _isLoggedIn = false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: "Go Cars!",
      home: new SplashScreen(
          seconds: 2,
          navigateAfterSeconds: _isLoggedIn == false ? IntroScreen() : HomePage(),
          title: Text('Go Cars!'),
          loadingText: Text("Drive And Chill!"),
          image: new Image.asset('images/search.png'),
          backgroundColor: Colors.white,
          styleTextUnderTheLoader: new TextStyle(),
          photoSize: 100.0,
          loaderColor: Colors.red),
//    home: ,
      navigatorObservers: [routeObserver],
    );
  }
}
