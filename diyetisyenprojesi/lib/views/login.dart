import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/ana_sayfa.dart';
import 'package:diyetisyenprojesi/views/kaydol.dart';
import 'package:diyetisyenprojesi/views/sifre_sifirlama.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController sifre = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  final _firestore = FirebaseFirestore.instance;
  late String durum;

  ///       Bilgilerin Doğruluğunu Denetleme
  girisYap() {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: sifre.text)
        .then((kullanici) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Anasayfa(),
        ),
      );
      print('Giriş Başarılı');
    });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference kullaniciRef = _firestore.collection('Users');

    return Scaffold(
      drawer: YanMenu(),
      body: Container(
        decoration: buildBoxDecorationArkaPlan(),
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: email,
                  style: TextStyle(color: Colors.black),
                  decoration: buildInputDecoration('Mail Adresiniz',
                      const Icon(FontAwesomeIcons.envelopeOpen)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Mail adresini giriniz.';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                  controller: sifre,
                  style: TextStyle(color: Colors.black),
                  decoration: buildInputDecoration(
                      'Şifreniz', const Icon(FontAwesomeIcons.key)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Şifrenizi giriniz.';
                    } else {
                      return null;
                    }
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Kayıt butonu
                    TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => YeniKayit(),
                            ),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text('Üye Ol'),
                    ),

                    /// Şifre Unutma butonu
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SifreReset()));
                      },
                      child: const Text('Şifremi Unuttum'),
                    )
                  ],
                ),

                /// Kullanıcı giriş butonu
                TextButton(
                  onPressed: () {
                    girisYap();
                  },
                  child: const Text('GİRİŞ'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
