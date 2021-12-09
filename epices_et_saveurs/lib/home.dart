import 'auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'listproduct.dart';
import 'panier.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  String username;
  String email;

  Home(
    this.username,
    this.email,
  );

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _uiIndex = 0;

  List<Widget> interfaces = [Listproduct(), Panier()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: false,
              title: Row(
                children: [
                  Column(
                    children: [
                      Text("Welcome Mr. " + this.widget.username),
                    ],
                  )
                ],
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Icon(Icons.shopping_cart)),
                  Text("My Cart"),
                ],
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Auth();
                }));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
                      child: Icon(Icons.power_settings_new)),
                  Text("Se déconnecter"),
                ],
              ),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.clear();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (BuildContext context) {
                  return Auth();
                }));
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket), title: Text("shop")),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag), title: Text("Panier"))
        ],
        currentIndex: _uiIndex,
        onTap: (int value) {
          setState(() {
            _uiIndex = value;
          });
        },
      ),
      body: interfaces[_uiIndex],
    );
  }
}
