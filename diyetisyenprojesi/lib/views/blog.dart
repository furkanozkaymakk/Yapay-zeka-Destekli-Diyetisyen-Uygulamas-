import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:flutter/material.dart';

class Blog extends StatelessWidget {
  late String baslik, icerik, resim_adresi;
  Blog(
      {required this.baslik, required this.icerik, required this.resim_adresi});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: YanMenu(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: buildBoxDecorationArkaPlan(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(right: 10, left: 10, bottom: 20),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                    child: Image.network(resim_adresi),
                  ),
                  Center(
                    child: Text(
                      baslik,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    icerik,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
