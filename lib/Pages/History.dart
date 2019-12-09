import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy/api/api.dart';
import 'package:pharmacy/util/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  Future<List> _getMedicineData() async {
    print("loool");
    Dio http = new Dio();
    final response = await http
        .get("${CallApi().url}/viewMedicine/${userData['userId']}");
    var medicines = json.decode(response.toString());
    print("$medicines/${userData['userId']} aaaaaaaaa");
//    var med = medicines['nlmRxImages'];
    return medicines['medicines'];
  }
  void _getUserInfo() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var userJson = localStorage.getString('user');
    print(userJson);
    var user = json.decode(userJson);
    setState(() {
      userData = user;
    });
  }
  var userData;
  @override
  void initState() {
    // TODO: implement initState
    _getUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<List<dynamic>>(
        future: _getMedicineData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
          return snapshot.hasData
              ? ListView.builder(
                  physics: ScrollPhysics(),
                  primary: false,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      child: InkWell(
                        onTap: () {
                          print("kill me");
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: new NetworkImage(snapshot.data[index]['imageUrl']),

                            radius: 25,
                          ),
                          title: Text(snapshot.data[index]['name']),
                          subtitle: Text(snapshot.data[index]['labeler']),
                          trailing: Text(
                              snapshot.data[index]['quantity'].toString(),
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : new Center(
                  child: CircularProgressIndicator(),
                );
        },
      ),
    );
  }
}
