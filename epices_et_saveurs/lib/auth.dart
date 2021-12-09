import 'dart:convert';
import 'dart:core';

import 'home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  late String username;
  late String pwd;
  bool _obscureText = true;
  late Future<List<User>> user;
  GlobalKey<FormState> myKey = new GlobalKey();
  Future<Null> getSharedPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString("username") != null) {
      username = prefs.getString("username")!;
      pwd = prefs.getString("pwd")!;
      Map<String, dynamic> user = {"username": username, "password": pwd};
      Map<String, String> headers = {
        "Content-Type": "application/json; charset=UTF-8"
      };
      var url = Uri.parse('http://192.168.1.13:3002/api/login');

      http.Response response =
          await http.post(url, headers: headers, body: json.encode(user));

      if (response.statusCode == 200) {
        print(response.body);

        final signUp = User.fromJson(response.body);
        /* print(signUp.avatar); */

        print(prefs.getString("username"));
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return Home(signUp.username, signUp.password);
        }));
      }
      if (response.statusCode == 401) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("info"),
                content: Text("nom utilisateur ou pwd incorrect"),
              );
            });
      }
    }
  }

  void initState() {
    super.initState();
    username = "";
    pwd = "";
    getSharedPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Esprit Shop"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: myKey,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
                  child: Image(
                    image: Image.asset('images/logo.jpg').image,
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 150, 20, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nom d'utilisateur"),
                    onSaved: (value) {
                      username = value!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.fromLTRB(20, 5, 20, 0),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Mote de passe"),
                    onSaved: (value) {
                      pwd = value!;
                    },
                    obscureText: _obscureText,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "required";
                      }
                      if (value.length < 4) {
                        return "max 4";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              RaisedButton(
                child: Text("Se connecter"),
                onPressed: () async {
                  if (myKey.currentState!.validate()) {
                    myKey.currentState!.save();
                    Map<String, dynamic> user = {
                      "username": username,
                      "password": pwd
                    };
                    Map<String, String> headers = {
                      "Content-Type": "application/json; charset=UTF-8"
                    };
                    var url = Uri.parse('http://192.168.1.13:3002/api/login');

                    http.Response response = await http.post(url,
                        headers: headers, body: json.encode(user));

                    if (response.statusCode == 200) {
                      print(response.body);

                      final signUp = User.fromJson(response.body);
                      /* print(signUp.avatar); */
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString("username", username);
                      prefs.setString("pwd", pwd);
                      print(prefs.getString("username"));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return Home(signUp.username, signUp.password);
                      }));
                    }
                    if (response.statusCode == 401) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("info"),
                              content: Text("nom utilisateur ou pwd incorrect"),
                            );
                          });
                    }
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  String password;
  String username;

  User(
    this.password,
    this.username,
  );

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      map['username'],
      map['password'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
