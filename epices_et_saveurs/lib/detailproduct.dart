import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class Detail extends StatelessWidget {
  String nom;
  String descrip;
  String prix;
  String image;
  Detail(this.nom, this.descrip, this.prix, this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
      ),
      body: Center(
        child: Column(
          children: [
            Image.network("http://192.168.1.13:3002/" + this.image),
            Text(
              this.nom,
              textScaleFactor: 2,
            ),
            Text(this.prix),
            Text(this.descrip + " DT"),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.shopping_basket),
        label: Text("Add to cart"),
        onPressed: () async {
          Database db =
              await openDatabase(join(await getDatabasesPath(), "product.db"),
                  onCreate: (Database db, int version) {
            return db.execute(
                "CREATE TABLE product(nom TEXT PRIMERY KEY,image TEXT,prix TEXT) ");
          }, version: 1);

          await db.transaction((txn) async {
            int id1 = await txn.rawInsert(
                'INSERT INTO product(nom, image,prix ) VALUES("$nom","$image", "$descrip")');
            print('inserted1: $id1');
          });
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Confirmation"),
                  content: Text(nom + " ajouté au panier"),
                );
              });
        },
      ),
    );
  }

  Map<String, dynamic> toMap1() => {
        'label': nom,
        'price': prix,
        'image': image,
        'description': descrip,
      };
}
