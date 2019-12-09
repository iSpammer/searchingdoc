import 'dart:async';
import 'dart:convert';

import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/Pages/MedicinesListPage.dart';
import 'package:pharmacy/Pages/History.dart';
import 'package:pharmacy/Pages/ProfileSettings.dart';
import 'package:pharmacy/Pages/WelcomeScreen.dart';
import 'package:pharmacy/api/api.dart';
import 'package:pharmacy/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Settings.dart';

final duration = const Duration(milliseconds: 300);

class HomePage extends StatefulWidget {
  HomePage();

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  GlobalKey _fabKey = GlobalKey();
  bool _fabVisible = true;
  var userData;

  //initial page is 0
  int currentIndex;

//  signOut() {
//    setState(() {
//      widget.signOut();
//    });
//  }

  String email = "", name = "", id = "";
  List<String> favs = [];

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      id = preferences.getString("id");
      email = preferences.getString("email");
      name = preferences.getString("name");
    });
  }

  void changePage(int index) {
    setState(() {
      //bottom bar page changer
      currentIndex = index;
    });
  }

  //fab
  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  dispose() {
    super.dispose();
    routeObserver.unsubscribe(this);
  }

  @override
  didPopNext() {
    // Show back the FAB on transition back ended
    Timer(duration, () {
      setState(() => _fabVisible = true);
    });
  }

  @override
  void initState() {
    super.initState();
    //refreshing all the lists
    // refreshList();
    //initial Buttom bar page indicator
    currentIndex = 1;
    _getUserInfo();
    getPref();
  }




  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: Visibility(
          visible: _fabVisible,
          child: _buildFAB(context, key: _fabKey),
        ),
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(
              Icons.exit_to_app,
              color: Colors.black,
            ),
            onPressed: () async {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Container(
                    height: 200.0,
                    width: 260.0,
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Text(
                            'Are you sure u wanna quit',
                            style:
                                TextStyle(color: Colors.black, fontSize: 22.0),
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,children: <Widget>[
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: (){
                              signOut();
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                        ],),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          elevation: 0.1,
          backgroundColor: Colors.white,
          title: Center(
              child: Text(
            "Pharmacy Manager",
            style: TextStyle(color: Colors.black),
          )),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.list),
              onPressed: () {
                //refreshList();
              },
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BubbleBottomBar(
          opacity: .2,
          currentIndex: currentIndex,
          onTap: changePage,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          elevation: 20,
          fabLocation: BubbleBottomBarFabLocation.end,
          hasNotch: true,
          hasInk: true,
          //gives a cute ink effect
          inkColor: Colors.black12,
          //optional, uses theme color if not specified
          items: <BubbleBottomBarItem>[
            BubbleBottomBarItem(
                backgroundColor: Colors.red,
                icon: Icon(
                  Icons.dashboard,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
                title: Text("Medicine List")),
            BubbleBottomBarItem(
                backgroundColor: Colors.deepPurple,
                icon: Icon(
                  Icons.shopping_basket,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.shopping_basket,
                  color: Colors.deepPurple,
                ),
                title: Text("Repo")),
            BubbleBottomBarItem(
                backgroundColor: Colors.green,
                icon: Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                activeIcon: Icon(
                  Icons.menu,
                  color: Colors.green,
                ),
                title: Text("Menu"))
          ],
        ),
        body: getChildren(currentIndex),
      ),
    );
  }

  callToast(String msg) {
    Fluttertoast.showToast(
        msg: "$msg",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Widget getChildren(int i) {
    List<Widget> _children = [
      MedicinesListPage(),
      History(),
      ProfileSettings(
        signout: signOut,
      ),
    ];
    return _children[i];
  }

  Widget _buildFAB(context, {key}) => FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.pink,
        key: key,
        onPressed: () => _onFabTap(context),
        child: Icon(Icons.search),
      );

  _onFabTap(BuildContext context) {
    setState(() => _fabVisible = false);
    final RenderBox fabRenderBox = _fabKey.currentContext.findRenderObject();
    final fabSize = fabRenderBox.size;
    final fabOffset = fabRenderBox.localToGlobal(Offset.zero);

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: duration,
      pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) =>
          Settings(
        favs: this.favs,
      ),
      transitionsBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation, Widget child) =>
          _buildTransition(child, animation, fabSize, fabOffset),
    ));
    // refreshList();
  }

  Widget _buildTransition(
    Widget page,
    Animation<double> animation,
    Size fabSize,
    Offset fabOffset,
  ) {
    if (animation.value == 1) return page;

    final borderTween = BorderRadiusTween(
      begin: BorderRadius.circular(fabSize.width / 2),
      end: BorderRadius.circular(0.0),
    );
    final sizeTween = SizeTween(
      begin: fabSize,
      end: MediaQuery.of(context).size,
    );
    final offsetTween = Tween<Offset>(
      begin: fabOffset,
      end: Offset.zero,
    );

    final easeInAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeIn,
    );
    final easeAnimation = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    );

    final radius = borderTween.evaluate(easeInAnimation);
    final offset = offsetTween.evaluate(animation);
    final size = sizeTween.evaluate(easeInAnimation);

    final transitionFab = Opacity(
      opacity: 1 - easeAnimation.value,
      child: _buildFAB(context),
    );

    Widget positionedClippedChild(Widget child) => Positioned(
        width: size.width,
        height: size.height,
        left: offset.dx,
        top: offset.dy,
        child: ClipRRect(
          borderRadius: radius,
          child: child,
        ));

    return Stack(
      children: [
        positionedClippedChild(page),
        positionedClippedChild(transitionFab),
      ],
    );
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }

  signOut() async {
//    var data = {
//      'userId' : userData['userId'],
//    };
//    var res = await CallApi().postData(data, 'signout');
//    var body = json.decode(res.body);
//
//    print(body.toString());
//    if (!body['error']) {
//      SharedPreferences localStorage = await SharedPreferences.getInstance();
//      localStorage.remove('user');
//      localStorage.remove('token');
//      Navigator.pushReplacement(
//          context,
//          new MaterialPageRoute(
//              builder: (BuildContext context) => new WelcomeScreen()));
//
//    }
//    SharedPreferences localStorage = await SharedPreferences.getInstance();
//    localStorage.remove('user');
//    localStorage.remove('token');
    Navigator.pushAndRemoveUntil(context, new MaterialPageRoute(
        builder: (BuildContext context) => new WelcomeScreen()), (e) => false);

//    Navigator.pushReplacement(
//        context,
//        new MaterialPageRoute(
//            builder: (BuildContext context) => new WelcomeScreen()));
//
//  }
  }
}
