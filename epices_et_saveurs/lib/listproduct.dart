import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cardproduct.dart';

class Listproduct extends StatefulWidget {
  @override
  _ListproductState createState() => _ListproductState();
}

class _ListproductState extends State<Listproduct> {
  List<Product> product = [];
  var url = Uri.parse('http://192.168.1.13:3002/api/sandwish');
  late Future<bool> futurepro;
  Future<bool> fetchprod() async {
    http.Response response = await http.get(url);
    List<dynamic> listp = jsonDecode(response.body);
    for (int i = 0; i < listp.length; i++) {
      Map<String, dynamic> plist = listp[i];
      product.add(Product(plist["id"], plist["title"], plist["prix"],
          plist["image"], plist["description"]));
      print(plist["description"]);
    }
    return true;
  }

  void initState() {
    super.initState();
    futurepro = fetchprod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: futurepro,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return CardProduct(product[index].label, product[index].price,
                      product[index].image, product[index].description);
                },
                itemCount: product.length,
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}

class Product {
  String _id;
  String label;
  String description;
  String image;
  String price;
  Product(this._id, this.label, this.price, this.image, this.description);

  Map<String, dynamic> toMap() => {
        'id': _id,
        'title': label,
        'prix': price,
        'image': image,
        'description': description,
      };

  @override
  String toString() {
    return 'Product(id: $_id, title: $label, prix: $price, image: $image, description: $description)';
  }
}
