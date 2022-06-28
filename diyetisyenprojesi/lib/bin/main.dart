import 'package:diyetisyenprojesi/services/state_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../views/ana_sayfa.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
      create: (BuildContext context) {
        return StateData();
      },
      child: const Diyetisyen()));
}

class Diyetisyen extends StatelessWidget {
  const Diyetisyen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: Anasayfa(),
    );
  }
}
