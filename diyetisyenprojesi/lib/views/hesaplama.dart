import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/kahvalti.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../services/state_data.dart';

class Hesaplama extends StatefulWidget {
  const Hesaplama({Key? key}) : super(key: key);

  @override
  State<Hesaplama> createState() => _HesaplamaState();
}

class _HesaplamaState extends State<Hesaplama> {
  late String kullanici_email;
  late double indeks, kalori;
  late int yas;
  double spor = 0;
  double oran = 0;
  final items = ['Hafif Aktivite', 'Orta Düzey Aktivite', 'Ağır Aktivite'];
  String? value;
  var veri;

  ///       Kullanıcı Butona Tıkladığında önceden kayıtlı diyet listesini silme
  Future<void> koleksiyonsil(sinif, isim) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection(sinif);
    var snapshot = await collection.where(isim, isNotEqualTo: 'false').get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> veriEkle(sinif, isim) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var collection = FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection(sinif);
    collection.doc(isim).set({isim: 'ddd'});
  }

  ///       Kullanıcı Butona Tıkladığında önceden kayıtlı diyet listesini silme
  Future<void> sifirla() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    veriEkle('kahvalti', 'isim');
    koleksiyonsil('kahvalti', 'isim');

    ///
    veriEkle('corba', 'corba_isim');
    koleksiyonsil('corba', 'corba_isim');

    veriEkle('ana_yemek', 'ana_yemek_isim');
    koleksiyonsil('ana_yemek', 'ana_yemek_isim');

    veriEkle('salata', 'salata_isim');
    koleksiyonsil('salata', 'salata_isim');

    veriEkle('tatli', 'tatli_isim');
    koleksiyonsil('tatli', 'tatli_isim');

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({
      'corba': false,
      'ana_yemek': false,
      'salata': false,
      'tatli': false,
      'corba_aksam': false,
      'ana_yemek_aksam': false,
      'salata_aksam': false,
      'tatli_aksam': false
    });
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .set({'aksam': 0, 'ogle': 0, 'kahvalti': 0});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'kayit_islem': false});
  }

  Future getData(url) async {
    final response = await http.get(Uri.parse(url));

    print(response.statusCode);
    var data = await response.body;
    var decodedData = jsonDecode(data);
    return response.body;
  }

  ///       Sunucudan Kullanıcı bilgilerini yollayıp Diyet Oranını alma
  Future postData(url, index, yas) async {
    try {
      final sorgu = await http.post(Uri.parse(url), body: jsonEncode(index));
      final response =
          await http.post(Uri.parse(url), body: jsonEncode(yas)).then((cevap) {
        print(cevap.statusCode);
        setState(() {
          var data = cevap.body;
          veri = jsonDecode(data)['message'];
        });
      });
    } catch (er) {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
        );

    Provider.of<StateData>(context, listen: false).durumSorgula();
    int boy = int.parse(Provider.of<StateData>(context, listen: false).boy);
    int yas = int.parse(Provider.of<StateData>(context, listen: false).yas);
    int kilo = int.parse(Provider.of<StateData>(context, listen: false).kilo);
    String cinsiyet = Provider.of<StateData>(context, listen: false).cinsiyet;
    if (cinsiyet == 'Erkek') {
      kalori = 66 + 13.7 * kilo + 5 * boy - 6.8 * yas;
    } else if (cinsiyet == 'Kadın') {
      kalori = 655 + 9.6 * kilo + 1.8 * boy - 4.7 * yas;
    }
    indeks = kilo / (boy * boy / 10000);
    //String index = indeks.toStringAsFixed(2);
    return SafeArea(
      child: Scaffold(
        drawer: YanMenu(),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Günlük Spor Aktivitenizi Giriniz \n',
                  style: TextStyle(fontSize: 18),
                ),
                const Text('Masabaşı iş, Hareketsiz yaşam = Hafif Aktivite',
                    style: TextStyle(fontSize: 15)),
                const Text('Günlük Yürüyüş, Hareketli iş  =   Orta Aktivite',
                    style: TextStyle(fontSize: 15)),
                const Text(
                    'Hareketli iş, Spor yapma alışkanlığı = Ağır Aktivite',
                    style: TextStyle(fontSize: 15)),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                DropdownButton(
                  onTap: () {
                    postData('http://192.168.1.107:5000/', indeks, yas);
                  },
                  value: value,
                  isExpanded: true,
                  items: items.map(buildMenuItem).toList(),
                  onChanged: (value) => setState(() {
                    this.value = value as String?;
                    if (value == 'Hafif Aktivite') {
                      spor = kalori * 1.3;
                    } else if (value == 'Orta Düzey Aktivite') {
                      spor = kalori * 1.4;
                    } else {
                      spor = kalori * 1.5;
                    }
                  }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  spor.roundToDouble().toString(),
                  style: const TextStyle(fontSize: 30, color: Colors.white),
                ),
                TextButton(
                    onPressed: () {
                      if (spor == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(''),
                                backgroundColor: Colors.lightGreen,
                                content: const Text(
                                    "Spor Aktivite Değerini Seçiniz."),
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
                        postData('192.168.1.107/', indeks, yas);
                        oran = spor * veri / 100;
                        sifirla();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Kahvalti(oran)));
                      }
                    },
                    child: const Text('Listeyi Oluştur'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
