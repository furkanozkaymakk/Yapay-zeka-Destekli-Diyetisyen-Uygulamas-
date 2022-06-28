import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class StateData with ChangeNotifier {
  late String ad, soyad, boy, cinsiyet, email, kilo, sifre, yas;
  bool islem = false;
  String corba_isim = "",
      corba_resim = "",
      ana_yemek_isim = "",
      ana_yemek_resim = "",
      salata_isim = "",
      salata_resim = "",
      tatli_isim = "",
      tatli_resim = "";
  String corba_aksam_isim = "",
      corba_aksam_resim = "",
      ana_yemek_aksam_isim = "",
      ana_yemek_aksam_resim = "",
      salata_aksam_isim = "",
      salata_aksam_resim = "",
      tatli_aksam_isim = "",
      tatli_aksam_resim = "";
  String rol = 'kullanıcı';
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> durumSorgula() async {
    if (auth.currentUser != null) {
      var _firestore = FirebaseFirestore.instance.collection('Users');
      var kisi = _firestore.doc(auth.currentUser!.email);
      var veri = await kisi.get();
      dynamic map = veri.data();
      ad = map['ad'];
      soyad = map['pozisyon'];
      boy = map['boy'];
      cinsiyet = map['cinsiyet'];
      email = map['email'];
      kilo = map['kilo'];
      sifre = map['sifre'];
      yas = map['yas'];
      rol = map['pozisyon'];
      islem = map['kayit_islem'];
      notifyListeners();
    } else {
      rol = 'kullanıcı';
    }
  }

  Future<void> yemekSorgula(String ogun) async {
    if (auth.currentUser != null) {
      var _firestore = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection(ogun)
          .doc(ogun)
          .get();
      dynamic map = _firestore.data();
      switch (ogun) {
        case 'corba':
          corba_isim = map['corba_isim'];
          corba_resim = map['corba_resim'];
          break;
        case 'ana_yemek':
          ana_yemek_isim = map['ana_yemek_isim'];
          ana_yemek_resim = map['ana_yemek_resim'];
          break;
        case 'salata':
          salata_isim = map['salata_isim'];
          salata_resim = map['salata_resim'];
          break;
        default:
          tatli_isim = map['tatli_isim'];
          tatli_resim = map['tatli_resim'];
      }
      notifyListeners();
    }
  }

  Future<void> yemekSorgulaAksam(String ogun) async {
    if (auth.currentUser != null) {
      var _firestore = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection(ogun)
          .doc(ogun + '_aksam')
          .get();
      dynamic map = _firestore.data();
      switch (ogun) {
        case 'corba':
          corba_aksam_isim = map['corba_isim'];
          corba_aksam_resim = map['corba_resim'];
          break;
        case 'ana_yemek':
          ana_yemek_aksam_isim = map['ana_yemek_isim'];
          ana_yemek_aksam_resim = map['ana_yemek_resim'];
          break;
        case 'salata':
          salata_aksam_isim = map['salata_isim'];
          salata_aksam_resim = map['salata_resim'];
          break;
        default:
          tatli_aksam_isim = map['tatli_isim'];
          tatli_aksam_resim = map['tatli_resim'];
      }
      notifyListeners();
    }
  }
}
