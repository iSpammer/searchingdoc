import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarPictureDisplay.dart';
import 'package:gocars/Pages/MapsPage.dart';
import 'package:gocars/widgets/badge.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  initState()  {
    super.initState();
    _getDeviceLocation();
    //response.data['rows'][0]['elements'][0]['distance']['text']
  }
  getDistance() async{
    Dio dio = new Dio();
    Response response= await dio.get("https://maps.googleapis.com/maps/api/distancematrix/json?units=metric&origins=$latitudeCurrent,$longitudeCurrent&destinations=${widget.car['car_lat']},${widget.car['car_long']}&key=AIzaSyCJLNSD5zB42B-Ubd-Lr0LPQsrlVtQHCXo");
    print (response.data);
    setState(() {
      distance = response.data['rows'][0]['elements'][0]['distance']['text'];
      time = response.data['rows'][0]['elements'][0]['duration']['text'];
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
    print("favs 1");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> temp = (prefs.getStringList('fav') ?? List<String>());
    List<int> list = temp.map((i) => int.parse(i)).toList();
    print("asddd $list");
    if (list == null) {
      return prefs.setStringList("fav", ["$carUid"]);
    } else {
      list.add(carUid);
      List<String> temp2 = list.map((i) => i.toString()).toList();
      return await prefs.setStringList("fav", temp2);
    }
  }

  @override
  Widget build(BuildContext context) {
    print("${widget.car}");
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          "${widget.car["car_name"]}",
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
                          "http://192.168.64.2/signaling/images/${widget.car['car_img_path']}",
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
                          print("favs ${widget.car['uid']}");
                          _saveFavList(widget.car['uid']);
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
              Text(
                "${widget.car['car_name']}",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "$distance from your location\nEstimated trip time $time",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "\$550.00",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 30),
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
                    //print("aaaaaaxxxxa ${car}");
                    if (widget.car['uid'] != car['uid']) {
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
                                "http://192.168.64.2/signaling/images/${car["car_img_path"]}",
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
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.only(right: 20),
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
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
                    onPressed: (){
                      MapsActivity(
                          latLng: LatLng(double.parse(widget.car['car_lat']), double.parse(widget.car['car_long']))
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


}

