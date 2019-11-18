import 'dart:convert';
import 'dart:math';

import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarDetailsPage.dart';
import 'package:gocars/api/api.dart';
import 'package:gocars/util/harvisne.dart';
import 'package:great_circle_distance/great_circle_distance.dart';
import 'package:location/location.dart';

class CarListSortedView extends StatefulWidget {
  final List cars;
  final double lat;
  final double long;

  CarListSortedView(
      {@required this.lat, @required this.long, @required this.cars});

  @override
  _CarListSortedViewState createState() => _CarListSortedViewState();
}

class _CarListSortedViewState extends State<CarListSortedView> {
  double latitudeCurrent = 29.986174;
  double longitudeCurrent = 31.44081380001691;
  String googleAPiKey = "AIzaSyCJLNSD5zB42B-Ubd-Lr0LPQsrlVtQHCXo";
  String time = "";
  var cars;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    latitudeCurrent = widget.lat;
    longitudeCurrent = widget.long;
    cars = widget.cars;
    _getDeviceLocation();
    //sort 3rbyat
    cars.sort((a, b) {
      var distance1 = new GreatCircleDistance.fromDegrees(
          latitude1: latitudeCurrent == null ? 0.0 : latitudeCurrent,
          longitude1: longitudeCurrent == null ? 0.0 : longitudeCurrent,
          latitude2: double.parse(a['car_lat']),
          longitude2: double.parse(a['car_long']));
      double totaldistance1 = distance1.haversineDistance();

      var distance2 = new GreatCircleDistance.fromDegrees(
          latitude1: latitudeCurrent == null ? 0.0 : latitudeCurrent,
          longitude1: longitudeCurrent == null ? 0.0 : longitudeCurrent,
          latitude2: double.parse(b['car_lat']),
          longitude2: double.parse(b['car_long']));
      double totaldistance2 = distance2.haversineDistance();
      return (totaldistance1 - totaldistance2).toInt();
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
    });
  }

  double distance(double lat2, double lon2) {
    double theta = longitudeCurrent - lon2;
    double dist = sin(deg2rad(latitudeCurrent)) * sin(deg2rad(lat2)) +
        cos(deg2rad(latitudeCurrent)) *
            cos(deg2rad(lat2)) *
            cos(deg2rad(theta));
    dist = acos(dist);
    dist = rad2deg(dist);
    dist = dist * 60 * 1.1515;

    dist = dist * 1.609344;

    return (dist);
  }

  /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*::  This function converts decimal degrees to radians             :*/
  /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  double deg2rad(double deg) {
    return (deg * (22 / 7) / 180.0);
  }

  /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  /*::  This function converts radians to decimal degrees             :*/
  /*:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::*/
  double rad2deg(double rad) {
    return (rad * 180.0 / (22 / 7));
  }

  double calculateDistance(lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - widget.lat) * p) / 2 +
        c(widget.lat * p) * c(lat2 * p) * (1 - c((lon2 - widget.long) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  Widget build(context) {
    var cars = widget.cars;

//    print("aaa ${widget.cars[0]['car_name']}");
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.cars == null ? 0 : widget.cars.length,
      itemBuilder: (context, i) {
        final _parentKey = GlobalKey();
        return Padding(
          padding: EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) {
                    return CarsDetailPage(
                      car: cars[i],
                      cars: cars,
                    );
                  },
                ),
              );
            },
            child: Container(
              height: 275,
              width: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    StringUtils.capitalize(cars[i]['car_name']),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(
                          "${CallApi().url}/img/${cars[i]['car_img_path']}",
                          height: 240,
                          width: 340,
                          fit: BoxFit.contain,
                        ),
                      ),
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text("${cars[i]['car_year']}"),
                        ),
                      ),
//                      Positioned.fill(
//                        child: Align(
//                          alignment: Alignment.bottomRight,
//                          child: Text(calculateDistance(double.parse(cars[i]['car_long']), double.parse(cars[i]['car_lat'])).toString()),
//                        ),
//                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

//  Widget createViewItem(Car car, BuildContext context) {
//    return new  Padding(
//      padding: EdgeInsets.only(right: 20),
//      child: GestureDetector(
//        onTap: () {
//          Navigator.of(context).push(
//            MaterialPageRoute(
//              builder: (BuildContext context) {
//                return CarsDetailPage(
//                  carId: int.parse(car.id),
//                );
//              },
//            ),
//          );
//        },
//        child: Container(
//          height: 275,
//          width: 280,
//          child: Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: <Widget>[
//              Text(
//                car.name,
//                style: TextStyle(
//                  fontWeight: FontWeight.bold,
//                  fontSize: 20,
//                ),
//              ),
//              SizedBox(height: 10),
//              ClipRRect(
//                borderRadius: BorderRadius.circular(15),
//                child:
//                Image.network(car.imageUrl,  height: 240,
//                  width: 280,
//                  fit: BoxFit.cover,
//                )
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}

//Future is n object representing a delayed computation.
}
