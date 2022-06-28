import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:flutter/material.dart';

import '../models/diyet_tablosu.dart';

class DiyetListesi extends StatefulWidget {
  const DiyetListesi({Key? key}) : super(key: key);

  @override
  State<DiyetListesi> createState() => _DiyetListesiState();
}

class _DiyetListesiState extends State<DiyetListesi> {
  int seciliSayfa = 0;

  Widget sayfaGoster(seciliSayfa) {
    switch (seciliSayfa) {
      case 0:
        return KahvaltiTablo();
      case 1:
        return OgleTablo();
      default:
        return AksamTablo();
    }
  }

  SayfaDegistir(index) {
    setState(() {
      seciliSayfa = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: YanMenu(),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.redAccent),
        child: BottomNavigationBar(
          currentIndex: seciliSayfa,
          onTap: SayfaDegistir,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.free_breakfast),
              label: 'Kahvaltı',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sunny),
              label: 'Öğle Yemeği',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shield_moon),
              label: 'Akşam Yemeği',
            ),
          ],
        ),
      ),
      body: sayfaGoster(seciliSayfa),
    );
  }
}
