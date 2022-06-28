import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/ogle_yemek.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Kahvalti extends StatefulWidget {
  double toplam;
  Kahvalti(this.toplam, {Key? key}) : super(key: key);

  @override
  _KahvaltiState createState() => _KahvaltiState();
}

class _KahvaltiState extends State<Kahvalti> {
  Query kahvalti = FirebaseFirestore.instance
      .collection('kahvalti')
      .orderBy('isim', descending: false);
  List<String> secili = [];
  int toplam_kalori = 0;
  int _selectedIndex = 0;
  double kalori = 0;

  Future<void> toplamKalori() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    var kisi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      toplam_kalori = map['ogle'];
    });
  }

  Future<void> kaloriYolla() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .update({'kahvalti': toplam_kalori});
  }

  Dogruluk(index) {
    if (index == 1) {
      print(index);
      if (toplam_kalori > (kalori + 50) || toplam_kalori < kalori - 50) {
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
        kaloriYolla();

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => OgleYemek(widget.toplam,
                    (widget.toplam * 0.25 - toplam_kalori).round())));
      }
    }
  }

  ///       Seçilen Besinlerin Veritabanına iletilmesi
  Future<void> veriEkle(String yiyecek) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('kahvalti')
        .doc(yiyecek)
        .set({'isim': yiyecek});
  }

  ///       İptal Edilen Besinlerin Veritabanına İletilmesi
  Future<void> veriSil(String yiyecek) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('kahvalti')
        .doc(yiyecek)
        .delete()
        .then((value) => null);
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Dogruluk(_selectedIndex);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    kalori = widget.toplam * 0.25;
    // Listeleme();
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(
            child: Text(
              "Almanız gereken kalori: " + kalori.round().toString(),
              style: const TextStyle(fontSize: 15),
            ),
          )),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu,
                  color: toplam_kalori > (kalori + 50) ||
                          toplam_kalori < (kalori - 50)
                      ? Colors.red
                      : Colors.green),
              label: toplam_kalori.toString()),
          const BottomNavigationBarItem(
              icon: Icon(Icons.arrow_forward_rounded), label: "")
        ],
      ),
      drawer: YanMenu(),
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: kahvalti.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                            child: Text('Birşeyler Ters Gitti'));
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot document) {
                            Map<String, dynamic> data =
                                document.data()! as Map<String, dynamic>;
                            return GestureDetector(
                              onTap: () {
                                if (secili.contains(data['isim'])) {
                                  setState(() {
                                    toplam_kalori = toplam_kalori -
                                        int.parse(data['kalori']);
                                    secili.remove(data['isim']);
                                    veriSil(data['isim']);
                                  });
                                  print(secili);
                                } else {
                                  veriEkle(data['isim']);
                                  setState(() {
                                    secili.add(data['isim']);
                                    toplam_kalori += int.parse(data['kalori']);
                                  });
                                  print(secili);
                                }
                              },
                              child: SingleChildScrollView(
                                child: Container(
                                  height: 50,
                                  child: Card(
                                    color: secili.contains(data['isim'])
                                        ? Colors.green
                                        : Colors.grey,
                                    margin: const EdgeInsets.all(7),
                                    child: Center(
                                      child: Text(
                                        data['isim'],
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList());
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
