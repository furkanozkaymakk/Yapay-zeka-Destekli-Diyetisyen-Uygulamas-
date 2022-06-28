import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/diyet_listesi.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/yemekler_aksam.dart';

class AksamYemek extends StatefulWidget {
  double toplam;
  int fark;
  AksamYemek(this.toplam, this.fark, {Key? key}) : super(key: key);

  @override
  State<AksamYemek> createState() => _AksamYemekState();
}

class _AksamYemekState extends State<AksamYemek> {
  int seciliSayfa = 0;
  int toplam_kalori = 0;

  SayfaDegistir(int index) {
    setState(() {
      seciliSayfa = index;
    });
  }

  ///       Seçilen besinlerin kalorilerini veritabanına iletme
  Future<void> toplamKalori() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var kisi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      toplam_kalori = map['aksam'];
    });
  }

  Widget sayfaGoster(int seciliSayfa) {
    switch (seciliSayfa) {
      case 0:
        return const Corba();
      case 1:
        return const AnaYemek();
      case 2:
        return const Salata();
      default:
        return const Tatli();
    }
  }

  ///       Kullanıcının Doğru Kalori Seçimi Girişini Kontrol
  Dogruluk() {
    if (toplam_kalori > (widget.toplam * 0.375 + 50) ||
        toplam_kalori < widget.toplam * 0.375 - 50) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Eksik Kalori Seçimi')),
              backgroundColor: Colors.lightGreen,
              content: const Text(
                  "Almanız Gereken Kalorinin +50 üstü ve -50 altı olarak doğru seçiniz."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('TAMAM'),
                )
              ],
            );
          });
    } else {
      kayitTamam();
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const DiyetListesi()));
    }
  }

  ///       İşlem Doğru Tamamlandıysa Kullanıcının Veritabanına İşlemin Tamamlandığını bildirme
  Future<void> kayitTamam() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'kayit_islem': true});
  }

  @override
  Widget build(BuildContext context) {
    toplamKalori();
    return Scaffold(
      drawer: YanMenu(),
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowLeft),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              Text(
                "Alınması Gereken: " +
                    (widget.toplam * 0.375 + widget.fark).round().toString() +
                    " Alınan Kalori: " +
                    (toplam_kalori + widget.fark).toString(),
                style: const TextStyle(fontSize: 14),
              ),
              IconButton(
                icon: const Icon(FontAwesomeIcons.arrowRight),
                onPressed: () {
                  Dogruluk();
                },
              )
            ],
          )),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: Colors.redAccent),
        child: BottomNavigationBar(
          currentIndex: seciliSayfa,
          onTap: SayfaDegistir,
          type: BottomNavigationBarType.fixed,
          fixedColor: Colors.white,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.soup_kitchen),
              label: 'Çorbalar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu),
              label: 'Ana Yemek',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.spa),
              label: 'Salata',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.local_cafe),
              label: 'İçecek',
            ),
          ],
        ),
      ),
      body: Center(
        child: sayfaGoster(seciliSayfa),
      ),
    );
  }
}
