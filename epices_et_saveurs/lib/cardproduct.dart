import 'detailproduct.dart';
import 'package:flutter/material.dart';

class CardProduct extends StatelessWidget {
  String nom;
  String description;
  String image;
  String prix;
  CardProduct(this.nom, this.description, this.image, this.prix);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () async {
          Navigator.push(context,
              MaterialPageRoute(builder: (BuildContext context) {
            return Detail(this.nom, this.description, this.prix, this.image);
          }));
        },
        child: Center(
          child: Column(
            children: [
              Image.network("http://192.168.1.13:3002/" + this.image),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(
                  this.nom,
                  textScaleFactor: 2,
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: Text(this.description + "DT"),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(this.prix),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
