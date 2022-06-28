import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/services/state_data.dart';
import 'package:diyetisyenprojesi/views/add_blog.dart';
import 'package:diyetisyenprojesi/views/blog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  late String durum;
  Query tumYazilar = FirebaseFirestore.instance
      .collection('blog_yazilari')
      .orderBy('yayim_zamani', descending: true);
  String? baslik, icerik, urlAdresi;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    ///       Kullanıcının bilgilerine ulaşma
    Provider.of<StateData>(context, listen: false).durumSorgula();
    durum = Provider.of<StateData>(context, listen: false).rol;
    print(durum);
    return Scaffold(
      drawer: YanMenu(),
      floatingActionButton: durum == 'yönetici'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddBlog()));
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            )
          : const SizedBox(),
      body: Container(
        decoration: buildBoxDecorationArkaPlan(),
        child: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
            stream: tumYazilar.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView(
                children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;
                  return SingleChildScrollView(
                    child: Card(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),

                      ///       Tıkladığında Blog okuma sayfasının açılması
                      child: GestureDetector(
                        onTap: () {
                          baslik = data['baslik'];
                          icerik = data['icerik'];
                          urlAdresi = data['resim-adresi'];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Blog(
                                baslik: baslik.toString(),
                                icerik: icerik.toString(),
                                resim_adresi: urlAdresi.toString(),
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(data['resim-adresi']),
                            ListTile(
                              tileColor: Colors.grey,
                              textColor: Colors.white,
                              onTap: () {
                                baslik = data['baslik'];
                                icerik = data['icerik'];
                                urlAdresi = data['resim-adresi'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Blog(
                                      baslik: baslik.toString(),
                                      icerik: icerik.toString(),
                                      resim_adresi: urlAdresi.toString(),
                                    ),
                                  ),
                                );
                              },
                              title: Center(
                                child: Text(
                                  data['baslik'],
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
