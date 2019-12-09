import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/Utils/MedicineListView.dart';

class MedicinesListPage extends StatefulWidget {
  @override
  _MedicinesListPageState createState() => _MedicinesListPageState();
}

class _MedicinesListPageState extends State<MedicinesListPage> {

  Future<List> _getMedicineData(String medicine) async {
    print("loool $medicine");
    Dio http = new Dio();
    final response = await http
        .get("https://rximage.nlm.nih.gov/api/rximage/1/rxnav?name=$medicine");
    var medicines = json.decode(response.toString());
    var med = medicines['nlmRxImages'];
    return med;
  }

  @override
  initState() {
    super.initState();
    //await fetch();
  }

  String medicineName = "";

  Widget futureBuilder() {
    return new FutureBuilder<List<dynamic>>(
      future: _getMedicineData(medicineName),
      builder: (context, snapshot) {
        if (snapshot.hasError) print(snapshot.error);
        return snapshot.hasData
            ? new MedicineListView(
                medicine: snapshot.data,
              )
            : new Center(
                child: CircularProgressIndicator(),
              );
      },
    );
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
                  "What Medicine are\nyou looking for?",
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 18.0, top: 10),
                child: Card(
                  elevation: 6.0,
                  child: TextFormField(
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Password Can't be Empty";
                      }
                    },
                    onChanged: (e) => medicineName = e,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                      labelText: "Medicine Name",
                      prefixIcon: Padding(
                        padding: EdgeInsets.only(left: 20, right: 15),
                        child: Icon(Icons.phonelink_lock, color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.all(18),
                    ),
                  ),
                ),
              ),
              MaterialButton(
                  onPressed: () {
                    setState(() {
                      medicineName = medicineName +
                          ""; //assign any string value from result to display variable.
                    });
                  },
                  child: new Text("Get Data")),
              SizedBox(height: 10),
              Container(
                height: 500,
                child: futureBuilder(),
              ),
              SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }
}
