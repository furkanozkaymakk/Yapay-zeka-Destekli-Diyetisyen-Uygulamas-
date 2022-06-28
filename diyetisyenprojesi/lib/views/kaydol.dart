import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class YeniKayit extends StatefulWidget {
  const YeniKayit({Key? key}) : super(key: key);

  @override
  _YeniKayitState createState() => _YeniKayitState();
}

class _YeniKayitState extends State<YeniKayit> {
  TextEditingController k_name = TextEditingController();
  TextEditingController k_soyad = TextEditingController();
  TextEditingController k_email = TextEditingController();
  TextEditingController k_sifre = TextEditingController();
  TextEditingController k_sifre2 = TextEditingController();
  TextEditingController k_yas = TextEditingController();
  TextEditingController k_boy = TextEditingController();
  TextEditingController k_kilo = TextEditingController();
  String? k_cinsiyet;

  Future<void> kayitol() async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: k_email.text, password: k_sifre.text)
        .then((kullanici) {
      FirebaseFirestore.instance.collection('Users').doc(k_email.text).set({
        'ad': k_name.text,
        'soyad': k_soyad.text,
        'email': k_email.text,
        'sifre': k_sifre.text,
        'cinsiyet': k_cinsiyet,
        'boy': k_boy.text,
        'kilo': k_kilo.text,
        'yas': k_yas.text,
        'pozisyon': 'kullanıcı',
        'kayit_islem': false
      });
      print('Ekleme Başarılı');
    });
  }

  ///       Girilen Boy,Kilo,Yaş Bilgilerin Doğruluğunu Denetleme
  void Dogrulama() {
    if (int.parse(k_boy.text) < 250 &&
        80 < int.parse(k_boy.text) &&
        int.parse(k_kilo.text) < 200 &&
        10 < int.parse(k_kilo.text) &&
        int.parse(k_yas.text) < 120 &&
        5 < int.parse(k_yas.text)) {
      kayitol();
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
    return Scaffold(
      drawer: YanMenu(),
      body: Form(
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
                      style: TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'İsminiz:', const Icon(FontAwesomeIcons.user)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextFormField(
                      /// Soyad
                      controller: k_soyad,
                      style: TextStyle(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
                  decoration: buildInputDecoration(
                      'Mail Adresiniz:', const Icon(FontAwesomeIcons.envelope)),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      ///Şifre
                      controller: k_sifre,
                      style: TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Şifreniz:', const Icon(FontAwesomeIcons.key)),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    child: TextFormField(
                      /// Yeniden Şifre
                      controller: k_sifre2,
                      style: TextStyle(color: Colors.black),
                      decoration: buildInputDecoration(
                          'Şifrenizi Yeniden Giriniz:',
                          const Icon(FontAwesomeIcons.key)),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10),
              ToggleSwitch(
                minWidth: 90.0,
                initialLabelIndex: 1,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const ['Erkek', 'Kadın'],
                icons: const [(FontAwesomeIcons.mars), FontAwesomeIcons.venus],
                activeBgColors: const [
                  [Colors.blue],
                  [Colors.pink]
                ],
                onToggle: (index) {
                  print(
                      'switched to: ${index == 0 ? k_cinsiyet = 'Erkek' : k_cinsiyet = 'Kadın'}');
                },
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      /// Boy
                      controller: k_boy,
                      style: TextStyle(color: Colors.black),
                      keyboardType: const TextInputType.numberWithOptions(),
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
                      style: TextStyle(color: Colors.black),
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: buildInputDecoration(
                        'Kilo',
                        const Icon(FontAwesomeIcons.weightScale),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: TextFormField(
                      ///Yaş
                      controller: k_yas,
                      style: TextStyle(color: Colors.black),
                      keyboardType: const TextInputType.numberWithOptions(),
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
                          kayitol();
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const Login(),
                            ),
                          );
                        },
                        child: const Text('Kayıt Ol'))
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
