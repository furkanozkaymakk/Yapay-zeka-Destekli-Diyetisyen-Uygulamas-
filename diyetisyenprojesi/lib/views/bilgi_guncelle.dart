import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/services/state_data.dart';
import 'package:diyetisyenprojesi/views/ana_sayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../services/dizayn.dart';

class BilgileriGuncelle extends StatefulWidget {
  const BilgileriGuncelle({Key? key}) : super(key: key);

  @override
  State<BilgileriGuncelle> createState() => _BilgileriGuncelleState();
}

class _BilgileriGuncelleState extends State<BilgileriGuncelle> {
  TextEditingController k_name = TextEditingController();
  TextEditingController k_soyad = TextEditingController();
  TextEditingController k_email = TextEditingController();
  TextEditingController k_sifre = TextEditingController();
  TextEditingController k_sifre2 = TextEditingController();
  TextEditingController k_sifre_eski = TextEditingController();
  TextEditingController k_yas = TextEditingController();
  TextEditingController k_boy = TextEditingController();
  TextEditingController k_kilo = TextEditingController();
  String? k_cinsiyet;

  Future<void> kayitol() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
        email: k_email.text, password: k_sifre.text)
        .then((kullanici) {
      FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.email).update({
        'ad': k_name.text,
        'soyad': k_soyad.text,
        'sifre': k_sifre.text,
        'boy': k_boy.text,
        'kilo': k_kilo.text,
        'yas': k_yas.text,
      });
      print('Güncelleme Başarılı');
    });
  }

  void Dogrulama(String sifre) {
    if (int.parse(k_boy.text) < 250 &&
        80 < int.parse(k_boy.text) &&
        int.parse(k_kilo.text) < 200 &&
        10 < int.parse(k_kilo.text) &&
        int.parse(k_yas.text) < 120 &&
        5 < int.parse(k_yas.text)) {
      kayitol();
    } else if (k_sifre_eski != sifre) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Eski Şifre Yanlış Girildi')),
              backgroundColor: Colors.lightGreen,
              content: const Text("Eski Şifrenizi Doğru Giriniz"),
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Center(child: Text('Yanlış Değer Girildi')),
              backgroundColor: Colors.lightGreen,
              content:
                  const Text("Yaş, Kilo, Boy değerlerinizi kontrol ediniz!"),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context).durumSorgula();
    var isim = Provider.of<StateData>(context).ad;
    var soyisim = Provider.of<StateData>(context).soyad;
    var yas = Provider.of<StateData>(context).yas;
    var boy = Provider.of<StateData>(context).boy;
    var kilo = Provider.of<StateData>(context).kilo;
    var sifre = Provider.of<StateData>(context).sifre;

    return Scaffold(
      drawer: YanMenu(),
      body: Form(
        autovalidateMode: AutovalidateMode.always,
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Flexible(
                    child: TextFormField(

                        /// İsim
                        controller: k_name,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: isim,
                          hintStyle: const TextStyle(color: Colors.black),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.purple),
                          ),
                          labelStyle: const TextStyle(color: Colors.black),
                          prefixIcon: const Icon(FontAwesomeIcons.user),
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.purple)),
                        )),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextFormField(
                      /// Soyad
                      controller: k_soyad,
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Soyadınız:', const Icon(FontAwesomeIcons.user)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Flexible(
                child: TextFormField(
                  /// email
                  controller: k_email,
                  style: const TextStyle(color: Colors.black),
                  decoration: buildInputDecoration(
                      'Mail Adresiniz:', const Icon(FontAwesomeIcons.envelope)),
                ),
              ),
              const SizedBox(height: 10),
              Flexible(
                child: TextFormField(
                  ///Şifre
                  controller: k_sifre_eski,
                  style: const TextStyle(color: Colors.black),
                  decoration: buildInputDecoration(
                      'Eski Şifreniz:', const Icon(FontAwesomeIcons.key)),
                ),
              ),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      ///Şifre
                      controller: k_sifre,
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Şifreniz:', const Icon(FontAwesomeIcons.key)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextFormField(
                      /// Yeniden Şifre
                      controller: k_sifre2,
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Şifrenizi Yeniden Giriniz:',
                          const Icon(FontAwesomeIcons.key)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      /// Boy
                      controller: k_boy,
                      keyboardType: const TextInputType.numberWithOptions(),
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                        'Boy',
                        const Icon(FontAwesomeIcons.rulerHorizontal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      ///Kilo
                      controller: k_kilo,
                      keyboardType: const TextInputType.numberWithOptions(),
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                        'Kilo',
                        const Icon(FontAwesomeIcons.weightScale),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      keyboardType: const TextInputType.numberWithOptions(),

                      ///Yaş
                      controller: k_yas,
                      style: const TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Yaş', const Icon(Icons.numbers)),
                    ),
                  ),
                ],
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonTheme(
                      buttonColor: Colors.white,
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('İptal'),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Dogrulama(sifre);
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Anasayfa(),
                            ),
                          );
                        },
                        child: const Text('Güncelle'))
                  ],
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }
}
