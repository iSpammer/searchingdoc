import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gocars/Pages/CarsSortedList.dart';
import 'package:gocars/Utils/car_list.dart';
import 'package:gocars/api/api.dart';

class CarsListPage extends StatefulWidget {
  final double lat;
  final double long;
  CarsListPage({@required this.lat,@required this.long});
  @override
  _CarsListPageState createState() => _CarsListPageState();
}

class _CarsListPageState extends State<CarsListPage> {
  final TextEditingController _searchControl = new TextEditingController();

  static Future<List> _getCarsData() async {
    Dio http = new Dio();
    final response =
        await http.get("${CallApi().url}/cars");
    //print("alby $response");
    return json.decode(response.data.toString());
  }

  @override
  initState()  {
    // TODO: implement initState
    super.initState();
    //await fetch();
    _getCarsData();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(left: 20),
            children: <Widget>[
              SizedBox(
                height: 20,

              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  "What Car are\nyou looking for?",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Card(
                  elevation: 6.0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                    child: TextField(
                      style: TextStyle(
                        fontSize: 15.0,
                        color: Colors.black,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.all(10.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Search",
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        hintStyle: TextStyle(
                          fontSize: 15.0,
                          color: Colors.black,
                        ),
                      ),
                      maxLines: 1,
                      controller: _searchControl,
                    ),
                  ),
                ),
              ), //search bar
              SizedBox(height: 30),
              Container(
                height: 275,
                child: FutureBuilder<List>(
                  future: _getCarsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new CarListView(
                      cars: snapshot.data,
                    )
                        : new Center(
                          child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Nearby Cars",
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  FlatButton(
                    child: Text(
                      "View More",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    onPressed: () {
                      print("meaw");
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 275,
                child: FutureBuilder<List>(
                  future: _getCarsData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? new CarListSortedView(long: widget.long, lat:widget.lat, cars: snapshot.data,)
                        : new Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
