import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:basic_utils/basic_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:pharmacy/widgets/badge.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MedicineDetailPage extends StatefulWidget {
  final dynamic medicine;
  final dynamic medicines;

  MedicineDetailPage(
      {Key key, @required this.medicine, @required this.medicines})
      : super(key: key);

  @override
  _MedicineDetailPageState createState() => _MedicineDetailPageState();
}

class _MedicineDetailPageState extends State<MedicineDetailPage> {
  bool _showSpinner = false;
  final _formKey = GlobalKey<FormState>();

  var userData;

  var isLoading = false;

  @override
  initState() {
    super.initState();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        title: Text(
          StringUtils.capitalize(widget.medicine["name"]),
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
                        onTap: () async {
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
                                        onPressed: ()  {

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
                        child: Image.network(
                          "${widget.medicine['imageUrl']}",
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
                          print("favs ${widget.medicine['id']}");
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
                  StringUtils.capitalize(widget.medicine['name']),
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Center(
                child: Text(
                  StringUtils.capitalize(widget.medicine['labeler']),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                "AcqDate",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "${widget.medicine["acqDate"]}",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 15,
              ),

              Text(
                widget.medicine['attribution'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "attribution",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.medicine['attribution'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "deaSchedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.medicine['deaSchedule'] == null
                    ? "None"
                    : widget.medicine['deaSchedule'],
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "id",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.medicine['id'].toString(),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              Text(
                "Other Medicines",
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
                  itemCount: widget.medicines.length,
                  itemBuilder: (BuildContext context, int index) {
                    Map car = widget.medicines.toList()[index];
                    if (widget.medicine['id'] != car['id']) {
                      return Padding(
                        padding: EdgeInsets.only(right: 20),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              CupertinoPageRoute(
                                builder: (BuildContext context) {
                                  return MedicineDetailPage(
                                    medicine: widget.medicines[index],
                                    medicines: widget.medicines,
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
                                "${car["imageUrl"]}",
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
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: 25,
                    ),
                    onPressed: () {
                      _neverSatisfied();

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

  Future<void> _neverSatisfied() async {
    int quantity = 0;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Number of quantity'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('You added $quantity of this item.'),
                Card(
                  elevation: 6.0,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    validator: (e) {
                      if (e.isEmpty) {
                        return "Please Insert Number of this medicine";
                      }
                    },
                    onChanged: (e) { setState(() {
                      quantity = int.parse(e);
                    });},
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding:
                          EdgeInsets.only(left: 20, right: 15),
                          child: Icon(Icons.person,
                              color: Colors.black),
                        ),
                        contentPadding: EdgeInsets.all(18),
                        labelText: "Number of this item"),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Add'),
              onPressed: () async {
                var data = {
                  'userId' : userData['userId'],
                  'acqDate' : widget.medicine['acqDate'],
                  'name': widget.medicine['name'],
                  'labeler': widget.medicine['labeler'],
                  'deaSchedule': widget.medicine['deaSchedule'],
                  'attribution': widget.medicine['attribution'],
                  'id': widget.medicine['id'],
                  'imageUrl': widget.medicine['imageUrl'],
                  'quantity': quantity
                };
                print(userData);
                print(data);
                var res = await CallApi().postData(data, 'addMedicine');
                var body = json.decode(res.body);
                print(body);
                if(body['error']){
                  callToast("Error Occured: ");
                }
                else{
                  callToast("Added successfuly");
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
