import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Iletisim extends StatefulWidget {
  @override
  State<Iletisim> createState() => _IletisimState();
}

class _IletisimState extends State<Iletisim> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    CollectionReference moviesRef = _firestore.collection('movies');
    var babaRef = moviesRef.doc('Baba');
    return Scaffold(
      drawer: YanMenu(),
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: const Text(
      //     'İletişim Bilgileri',
      //     style: TextStyle(color: Colors.black),
      //   ),
      //   backgroundColor: Colors.green,
      // ),
      body: Container(
        decoration: buildBoxDecorationArkaPlan(),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('İletişim Bilgileri',
                    style: TextStyle(color: Colors.white, fontSize: 20.0)),
                SizedBox(height: MediaQuery.of(context).size.height * 0.08),
                const Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text('ozkaymakfurk@gmail.com',
                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
                    leading: Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const Card(
                  margin: EdgeInsets.only(left: 20, right: 20),
                  child: ListTile(
                    tileColor: Colors.grey,
                    title: Text('instagram/diyetisyen',
                        style: TextStyle(color: Colors.black, fontSize: 20.0)),
                    leading: Icon(
                      FontAwesomeIcons.instagram,
                      color: Colors.purple,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
