import 'package:flutter/material.dart';
import 'package:pharmacy/Pages/MedicineDetailPage.dart';
import 'package:pharmacy/util/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  final List<String> favs;

  Settings({@required this.favs});

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    List<String> favs = widget.favs;
    final TextEditingController _searchControl = new TextEditingController();
    print("favs $favs");
    return Card(
      elevation: 6.0,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          title: Text(
            "Settings",
            style: TextStyle(color: Colors.black),
            textAlign: TextAlign.center,
          ),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              height: 5,
            ),
            Container(
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
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: InkWell(
                onTap: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  setState(
                    () {
                      preferences.setStringList("fav", null);
                      preferences.commit();
                      favs = [];
                      print("bye $favs");
                    },
                  );
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Icon(Icons.delete_forever),
                      SizedBox(
                        width: 5,
                      ),
                      Text("Clear"),
                    ],
                  ),
                  subtitle: Text("Clear favorite cars list"),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "Favorite Cars",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                height: 275,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
