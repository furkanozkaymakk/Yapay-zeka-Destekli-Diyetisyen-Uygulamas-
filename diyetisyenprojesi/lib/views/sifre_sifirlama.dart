import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SifreReset extends StatefulWidget {
  const SifreReset({Key? key}) : super(key: key);

  @override
  State<SifreReset> createState() => _SifreResetState();
}

class _SifreResetState extends State<SifreReset> {
  FirebaseAuth auth = FirebaseAuth.instance;

  ///       Kullanıcı Şifre Sıfırlama Emaili yollama
  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  final TextEditingController _k_email = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: YanMenu(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.2),
              TextFormField(
                controller: _k_email,
                style: TextStyle(color: Colors.black),
                decoration: buildInputDecoration(
                    'email adresi', const Icon(Icons.lock)),
              ),
              ElevatedButton(
                  onPressed: () {
                    resetPassword(_k_email.text);
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text('Gönder'))
            ],
          ),
        ),
      ),
    );
  }
}
