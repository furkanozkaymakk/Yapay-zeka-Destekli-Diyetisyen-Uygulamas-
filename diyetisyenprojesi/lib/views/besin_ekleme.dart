import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BesinEkleme extends StatefulWidget {
  const BesinEkleme({Key? key}) : super(key: key);

  @override
  _BesinEklemeState createState() => _BesinEklemeState();
}

class _BesinEklemeState extends State<BesinEkleme> {

  final items = ['Etler', 'Balıklar', 'Baklagiller','Sebze','Tavuk','Yağlı Tohumlar','Şeker ve Tatlılar','Süt ve Ürünleri'];
  String? value;

  TextEditingController besinler = TextEditingController();
  TextEditingController kalori = TextEditingController();
  TextEditingController protein = TextEditingController();
  TextEditingController yag = TextEditingController();
  TextEditingController karbonhidrat = TextEditingController();
  TextEditingController cins = TextEditingController();

  besinEkle() {
    FirebaseFirestore.instance.collection('besinler').doc(besinler.text).set({
      'cins': value,
      'besinler': besinler.text,
      'kalori': kalori.text,
      'protein': protein.text,
      'yag': yag.text,
      'karbonhidrat': karbonhidrat.text
    });
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

    return Scaffold(
      drawer: YanMenu(),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  DropdownButton(
                    value: value,
                    isExpanded: true,
                    items: items.map(buildMenuItem).toList(),
                    onChanged: (value) => setState(() {
                      this.value = value as String?;
                    }),),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: besinler,
                    decoration: besinEklemeDecoration(
                        'besinler', const Icon(Icons.restaurant)),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: kalori,
                    decoration: besinEklemeDecoration(
                      'kalori',
                      const Icon(Icons.fastfood),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: protein,
                    decoration: besinEklemeDecoration(
                      'protein',
                      const Icon(Icons.egg),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: yag,
                    decoration: besinEklemeDecoration(
                      'yag',
                      const Icon(FontAwesomeIcons.bottleDroplet),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: karbonhidrat,
                    decoration: besinEklemeDecoration(
                      'karbonhidrat',
                      const Icon(FontAwesomeIcons.breadSlice),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      besinEkle();
                      print('Kayıt Olma Başarılı');
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BesinEkleme()));
                    },
                    child: const Text('Kaydol'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
