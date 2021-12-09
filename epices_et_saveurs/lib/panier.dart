import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Panier extends StatefulWidget {
  late int total;
  @override
  _PanierState createState() => _PanierState();
}

class _PanierState extends State<Panier> {
  late List<Panie> prod;
  late Future<bool> futurp;
  Future<bool> getpro() async {
    Database db =
        await openDatabase(join(await getDatabasesPath(), "product.db"),
            onCreate: (Database db, int version) {
      return db.execute(
          "CREATE TABLE product(nom TEXT PRIMERY KEY,image TEXT,prix TEXT) ");
    }, version: 2);

    List<Map<String, dynamic>> maps = await db.query("product");
    prod = List.generate(maps.length, (index) {
      return Panie(
          maps[index]["nom"], maps[index]["image"], maps[index]["prix"]);
    });
    return true;
  }

  void initState() {
    super.initState();
    futurp = getpro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          RaisedButton(
            child: Text("total a payer"),
            onPressed: () {
              var total = 0.0;
              for (int i = 0; i < prod.length; i++) {
                total = total + double.parse(prod[i].price);
              }
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("panier"),
                      content:
                          Text("total a payer :" + total.toString() + " DT"),
                    );
                  });
            },
          ),
          Center(
            child: SizedBox(
              height: 400,
              width: 350,
              child: FutureBuilder(
                  future: futurp,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            child: Center(
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    child: Text(prod[index].label),
                                  ),
                                  Image.network("http://192.168.1.13:3002/" +
                                      prod[index].image),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(prod[index].price),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        itemCount: prod.length,
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class Panie {
  String label;
  String image;
  String price;
  Panie(
    this.label,
    this.image,
    this.price,
  );
}
