import 'dart:convert';
import 'dart:math';
import 'package:flutter_svg/svg.dart';
import 'package:gocars/Utils/button.dart';
import 'package:gocars/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarDetailMapPage.dart';
import 'package:gocars/Pages/CarPictureDisplay.dart';
import 'package:gocars/Pages/MapsPage.dart';
import 'package:gocars/widgets/badge.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:morpheus/morpheus.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class CarsDetailPage extends StatefulWidget {
  final dynamic car;
  final dynamic cars;

  CarsDetailPage({Key key, @required this.car, @required this.cars})
      : super(key: key);

  @override
  _CarsDetailPageState createState() => _CarsDetailPageState();
}

class _CarsDetailPageState extends State<CarsDetailPage> {
  double latitudeCurrent = 30.0271556;
  double longitudeCurrent = 31.0133856;
  String distance = "";
  String time = "";
  String comment = "";
  int rating = 3;
  double defaultRating = 5;
  bool _showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  var userData;

  List comments = new List();
  List users = new List();
  var isLoading = false;

  @override
  initState() {
    super.initState();
    fetchUsers();
    fetchComments();
    _getDeviceLocation();
    _getUserInfo();
    //response.data['rows'][0]['elements'][0]['distance']['text']
  }

  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }

  check() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      postComment();
    } else {
      setState(() {
        _showSpinner = false;
      });
    }
  }

  getDistance() async {
    Dio dio = new Dio();
    Response response = await dio.get(
        "https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$latitudeCurrent,$longitudeCurrent&destinations=${widget.car['car_lat']},${widget.car['car_long']}&key=AIzaSyCJLNSD5zB42B-Ubd-Lr0LPQsrlVtQHCXo");
    // print(response.data);
    setState(() {
      try {
        distance = response.data['rows'][0]['elements'][0]['distance']['text'];
        time = response.data['rows'][0]['elements'][0]['duration']['text'];
      } catch (e) {}
    });
  }

  void _getDeviceLocation() async {
    var location = new Location();
    location.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      distanceFilter: 0,
      interval: 100,
    );
    location.onLocationChanged().listen((LocationData currentLocation) {
      latitudeCurrent = currentLocation.latitude;
      longitudeCurrent = currentLocation.longitude;
      getDistance();
    });
  }

  Future<bool> _saveFavList(int carUid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = (prefs.getStringList('fav') ?? List<String>());
    List<int> list = temp.map((i) => int.parse(i)).toList();
    if (list == null) {
      return prefs.setStringList("fav", ["$carUid"]);
    } else {
      list.add(carUid);
      List<String> temp2 = list.map((i) => i.toString()).toList();
      return await prefs.setStringList("fav", temp2);
    }
  }

  fetchComments() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("${CallApi().url}/comments");
    if (response.statusCode == 200) {
      comments = json.decode(response.body) as List;
      int i = 0;
      while (i < comments.length) {
        if (comments[i]['car_id'] != widget.car['id']) {
          comments.removeAt(i);
        } else {
          i++;
        }
      }
      int sum = 0;
//      print(defaultRating);
      comments.forEach((comment) {
//        print("${comment['rating']} meaw");
        sum += comment['rating'];
      });
//      print(defaultRating);

      setState(() {
        defaultRating = sum / comments.length;
      });
      print("$defaultRating xdd");
      if(defaultRating == 0 || defaultRating.isNaN || defaultRating.isInfinite)
        defaultRating = 0;

//      print("$comments after");
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("${CallApi().url}/users");
    if (response.statusCode == 200) {
      users = json.decode(response.body) as List;
      print("$users meaaawww");
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load comments');
    }
  }

  @override
  Widget build(BuildContext context) {
//    print("${widget.car}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          StringUtils.capitalize(widget.car["car_name"]),
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Center(
            child: IconBadge(
              icon: Icons.add_shopping_cart,
            ),
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Stack(
        children: <Widget>[
          ListView(

            padding: EdgeInsets.symmetric(horizontal: 20),
            children: <Widget>[
              SizedBox(height: 10),
              Container(
                height: 240,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (BuildContext context) {
                                return CarPictureDisplay(
                                  picturePath: widget.car['car_img_path'],
                                );
                              },
                            ),
                          );
                        },
                        child: Image.network(
                          "${CallApi().url}/img/${widget.car['car_img_path']}",
                          height: 240,
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      right: -10.0,
                      bottom: 3.0,
                      child: RawMaterialButton(
                        onPressed: () {
                          print("favs ${widget.car['id']}");
                          _saveFavList(widget.car['id']);
                        },
                        fillColor: Colors.white,
                        shape: CircleBorder(),
                        elevation: 4.0,
                        child: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                          size: 17,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  StringUtils.capitalize(widget.car['car_name']),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "$distance from your location\nEstimated trip time $time",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Rating",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Center(
                child: RatingBar(
                  ignoreGestures: true,
                  initialRating: defaultRating,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    print(rating);
                  },
                )
              ),
              SizedBox(height: 10),
              Text(
                "Price",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${widget.car["car_price"]}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Car Color",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "${widget.car["car_color"]}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Description",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 10),
              Text(
                widget.car['car_description'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Fuel Level",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.car['car_fuel_level'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Photos",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
//                  SizedBox(height: 10),
//                  Container(
//                    height: 100,
//                    child: ListView.builder(
//                      scrollDirection: Axis.horizontal,
//                      shrinkWrap: true,
//                      itemCount: cars[widget.carId]['otherImg'].length,
//                      itemBuilder: (BuildContext context, int index) {
//                        String carpic = cars[widget.carId]['otherImg'][index];
//                        print("$carpic asd");
//                        return Padding(
//                          padding: EdgeInsets.only(right: 20),
//                          child: GestureDetector(
//                            onTap: () {
//                              print("$carpic");
//                              Navigator.of(context).push(
//                                CupertinoPageRoute(
//                                  builder: (BuildContext context) {
//                                    return CarPictureDisplay(
//                                      picturePath: carpic,
//                                    );
//                                  },
//                                ),
//                              );
//                            },
//                            child: Container(
//                              height: 100,
//                              width: 100,
//                              child: ClipRRect(
//                                borderRadius: BorderRadius.circular(15),
//                                child: Image.asset(
//                                  "$carpic",
//                                  height: 100,
//                                  width: 100,
//                                  fit: BoxFit.cover,
//                                ),
//                              ),
//                            ),
//                          ),
//                        );
//                      },
//                    ),
//                  ),
              SizedBox(height: 20),
              Text(
                "Other Cars",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: widget.cars.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map car = widget.cars.toList()[index];
                    if (widget.car['id'] != car['id']) {
                      return Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (BuildContext context) {
                                  return CarsDetailPage(
                                    car: widget.cars[index],
                                    cars: widget.cars,
                                  );
                                },
                              ),
                            );
                          },
                          child: Container(
                            height: 100,
                            width: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.network(
                                "${CallApi().url}/img/${car["car_img_path"]}",
                                height: 100,
                                width: 100,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),

              SizedBox(height: 10),
              Text(
                "Comments and Ratings",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height:
                    comments.length > 0 ? comments.length > 1 ? 300 : 100 : 0,
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: comments.length,
                        itemBuilder: (BuildContext context, int index) {
                          for (int i = 0; i < users.length; i++) {
                            if (users[i]['id'] == comments[index]['user_id']) {
                              return Card(
                                elevation: 8,
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(10.0),
                                  title: Text(
                                      "${users[i]['name']} : ${comments[index]['comment']}"),
                                  leading: Image.network(
                                      "https://api.adorable.io/avatars/70/${users[i]['name']}.png"),
                                ),
                              );
                            }
                          }
                          return Container();
                        },
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Card(
                        elevation: 6.0,
                        child: TextFormField(
                          validator: (e) {
                            if (e.isEmpty) {
                              return "Please Insert Your Comment";
                            }
                          },
                          onSaved: (e) => comment = e,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                          ),
                          decoration: InputDecoration(
                              prefixIcon: Padding(
                                padding: EdgeInsets.only(left: 20, right: 15),
                                child: Icon(Icons.comment, color: Colors.black),
                              ),
                              contentPadding: EdgeInsets.all(18),
                              labelText: "Comment"),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      RatingBar(
                        initialRating: 5,
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          switch (index) {
                            case 0:
                              return Icon(
                                Icons.sentiment_very_dissatisfied,
                                color: Colors.red,
                              );
                            case 1:
                              return Icon(
                                Icons.sentiment_dissatisfied,
                                color: Colors.pink,
                              );
                            case 2:
                              return Icon(
                                Icons.sentiment_neutral,
                                color: Colors.amber,
                              );
                            case 3:
                              return Icon(
                                Icons.sentiment_satisfied,
                                color: Colors.lightGreen,
                              );
                            case 4:
                              return Icon(
                                Icons.sentiment_very_satisfied,
                                color: Colors.green,
                              );
                          }
                        },
                        onRatingUpdate: (rating) {
//                          print(rating);
                          this.rating = rating.toInt();
                          print(this.rating);
                        },
                      ),
                      new Button(
                        text: "Post",
                        color: Colors.lightBlueAccent,
                        fn: () {
                          setState(() {
                            _showSpinner = true;
                          });
                          check();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20, bottom: 20, top: 30),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).accentColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange[200],
                      offset: Offset(0.0, 10.0),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Center(
                  child: IconButton(
                    icon: Icon(
                      Icons.map,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      print("asd !");
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (BuildContext context) {
                            return CarDetailMapActivity(currlong: longitudeCurrent, currlat: latitudeCurrent,car: widget.car);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future postComment() async {
    var data = {
      'car_id': widget.car['id'],
      'user_id': userData['id'],
      'comment': comment,
      'rating': rating,
    };
    var res = await CallApi().postData(data, 'comment');
    var body = json.decode(res.body);
    setState(() {
      _showSpinner = false;
    });
    print("$body xddd i hate my life");
    if (body['success']) {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.setString('token', body['token']);
      localStorage.setString('user', json.encode(body['user']));
      setState(() {
        fetchComments();
      });
      print("$defaultRating xdd");
      setState(() {
        comment = "";
      });
    } else {
      print("fail");
    }
  }
}
