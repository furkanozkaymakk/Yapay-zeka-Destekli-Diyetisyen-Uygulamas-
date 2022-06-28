import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import '../services/state_data.dart';

class Corba extends StatefulWidget {
  const Corba({Key? key}) : super(key: key);

  @override
  State<Corba> createState() => _CorbaState();
}

class _CorbaState extends State<Corba> {
  String isim = "", resim = "";
  bool? secim;
  FirebaseAuth auth = FirebaseAuth.instance;
  int toplam_kalori = 0;

  Future<void> secimBelirle() async {
    var kisi = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      secim = map['corba'];
    });
  }

  Query corba = FirebaseFirestore.instance
      .collection('corba')
      .orderBy('isim', descending: false);

  Future<void> sifirlama(bool sec) async {
    if (sec == false) {
      var corba = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('corba')
          .doc('corba')
          .get();
      dynamic corbaEksiltme = corba.data();
      var bilgi = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .get();
      dynamic map = bilgi.data();
      String eksilen = corbaEksiltme['corba_isim'];
      var yemek = await FirebaseFirestore.instance
          .collection('corba')
          .doc(eksilen)
          .get();
      dynamic corbaKalori = yemek.data();

      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .update({'ogle': (map['ogle'] - corbaKalori['kalori'])});
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('corba')
          .doc('corba')
          .delete();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.email)
          .update({'corba': sec});
      setState(() {
        secim = sec;
      });
    }
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'corba': sec});
    setState(() {
      secim = sec;
    });
  }

  Future tiklama(String Kisim, String Kresim) async {
    sifirlama(true);
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('corba')
        .doc('corba')
        .set({
      'corba_isim': Kisim,
      'corba_resim': Kresim,
    });
    var bilgi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = bilgi.data();
    var yemek =
        await FirebaseFirestore.instance.collection('corba').doc(Kisim).get();
    dynamic corbaKalori = yemek.data();

    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .update({'ogle': (map['ogle'] + corbaKalori['kalori'])});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimBelirle();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgula('corba');
    isim = Provider.of<StateData>(context, listen: false).corba_isim;
    resim = Provider.of<StateData>(context, listen: false).corba_resim;
    if (secim != true) {
      return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: corba.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<DocumentSnapshot> listofDocumentSnap = snapshot.data!.docs;
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listofDocumentSnap.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      listofDocumentSnap[index].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isim = data['isim'];
                          resim = data['resim'];
                        });
                        tiklama(data['isim'], data['resim']);
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(data['resim']),
                            ListTile(
                              tileColor: Colors.grey,
                              textColor: Colors.white,
                              onTap: () {},
                              title: Center(
                                child: Text(
                                  data['isim'],
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
                },
              );
            }),
      );
    } else {
      return Column(
        children: [
          Image.network(resim),
          ListTile(
            tileColor: Colors.grey,
            textColor: Colors.white,
            onTap: () {},
            title: Center(
              child: Text(
                isim,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isim = "";
                resim = "";
              });
              sifirlama(false);
            },
            child: const Text("Seçimi Sıfırla"),
          ),
        ],
      );
    }
  }
}

class AnaYemek extends StatefulWidget {
  const AnaYemek({Key? key}) : super(key: key);

  @override
  State<AnaYemek> createState() => _AnaYemekState();
}

class _AnaYemekState extends State<AnaYemek> {
  late String isim, resim;
  bool? secim;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> secimBelirle() async {
    var kisi = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      secim = map['ana_yemek'];
    });
  }

  Query ana_yemek = FirebaseFirestore.instance
      .collection('ana_yemek')
      .orderBy('isim', descending: false);

  Future<void> sifirlama(bool sec) async {
    if (sec == false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      var yemek = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('ana_yemek')
          .doc('ana_yemek')
          .get();
      dynamic yemekEksiltme = yemek.data();
      var bilgi = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .get();
      dynamic map = bilgi.data();
      String eksilen = yemekEksiltme['ana_yemek_isim'];
      var yiyecek = await FirebaseFirestore.instance
          .collection('ana_yemek')
          .doc(eksilen)
          .get();
      dynamic yemekKalori = yiyecek.data();

      print(map['ogle']);
      print(eksilen);
      print(yemekKalori['kalori']);
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .update({'ogle': (map['ogle'] - yemekKalori['kalori'])});
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('ana_yemek')
          .doc('ana_yemek')
          .delete();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.email)
          .update({'ana_yemek': sec});
      setState(() {
        secim = sec;
      });
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'ana_yemek': sec});
    setState(() {
      secim = sec;
    });
  }

  Future tiklama(String Kisim, String Kresim) async {
    sifirlama(true);
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('ana_yemek')
        .doc('ana_yemek')
        .set({
      'ana_yemek_isim': Kisim,
      'ana_yemek_resim': Kresim,
    });
    var bilgi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = bilgi.data();
    var yemek = await FirebaseFirestore.instance
        .collection('ana_yemek')
        .doc(Kisim)
        .get();
    dynamic yemekKalori = yemek.data();

    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .update({'ogle': (map['ogle'] + yemekKalori['kalori'])});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimBelirle();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgula('ana_yemek');
    isim = Provider.of<StateData>(context, listen: false).ana_yemek_isim;
    resim = Provider.of<StateData>(context, listen: false).ana_yemek_resim;
    if (secim != true) {
      return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: ana_yemek.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<DocumentSnapshot> listofDocumentSnap = snapshot.data!.docs;
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listofDocumentSnap.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      listofDocumentSnap[index].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isim = data['isim'];
                          resim = data['resim'];
                        });
                        tiklama(data['isim'], data['resim']);
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(data['resim']),
                            ListTile(
                              tileColor: Colors.grey,
                              textColor: Colors.white,
                              onTap: () {},
                              title: Center(
                                child: Text(
                                  data['isim'],
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
                },
              );
            }),
      );
    } else {
      return Column(
        children: [
          Image.network(resim),
          ListTile(
            tileColor: Colors.grey,
            textColor: Colors.white,
            onTap: () {},
            title: Center(
              child: Text(
                isim,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isim = "";
                resim = "";
              });
              sifirlama(false);
            },
            child: const Text("Seçimi Sıfırla"),
          ),
        ],
      );
    }
  }
}

class Salata extends StatefulWidget {
  const Salata({Key? key}) : super(key: key);

  @override
  State<Salata> createState() => _SalataState();
}

class _SalataState extends State<Salata> {
  String isim = "", resim = "";
  bool? secim;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> secimBelirle() async {
    var kisi = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      secim = map['salata'];
    });
  }

  Query salata = FirebaseFirestore.instance
      .collection('salata_makarna')
      .orderBy('isim', descending: false);

  Future<void> sifirlama(bool sec) async {
    if (sec == false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      var yemek = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('salata')
          .doc('salata')
          .get();
      dynamic yemekEksiltme = yemek.data();
      var bilgi = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .get();
      dynamic map = bilgi.data();
      String eksilen = yemekEksiltme['salata_isim'];
      var yiyecek = await FirebaseFirestore.instance
          .collection('salata_makarna')
          .doc(eksilen)
          .get();
      dynamic yemekKalori = yiyecek.data();

      print(map['ogle']);
      print(eksilen);
      print(yemekKalori['kalori']);
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .update({'ogle': (map['ogle'] - yemekKalori['kalori'])});
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('salata')
          .doc('salata')
          .delete();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.email)
          .update({'salata': sec});
      setState(() {
        secim = sec;
      });
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'salata': sec});
    setState(() {
      secim = sec;
    });
  }

  Future tiklama(String Kisim, String Kresim) async {
    sifirlama(true);
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('salata')
        .doc('salata')
        .set({
      'salata_isim': Kisim,
      'salata_resim': Kresim,
    });

    var bilgi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = bilgi.data();
    var yemek = await FirebaseFirestore.instance
        .collection('salata_makarna')
        .doc(Kisim)
        .get();
    dynamic yemekKalori = yemek.data();

    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .update({'ogle': (map['ogle'] + yemekKalori['kalori'])});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimBelirle();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgula('salata');
    isim = Provider.of<StateData>(context, listen: false).salata_isim;
    print(isim);
    resim = Provider.of<StateData>(context, listen: false).salata_resim;
    if (secim != true) {
      return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: salata.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<DocumentSnapshot> listofDocumentSnap = snapshot.data!.docs;
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listofDocumentSnap.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      listofDocumentSnap[index].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isim = data['isim'];
                          resim = data['resim'];
                        });
                        tiklama(data['isim'], data['resim']);
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(data['resim']),
                            ListTile(
                              tileColor: Colors.grey,
                              textColor: Colors.white,
                              onTap: () {},
                              title: Center(
                                child: Text(
                                  data['isim'],
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
                },
              );
            }),
      );
    } else {
      return Column(
        children: [
          Image.network(resim),
          ListTile(
            tileColor: Colors.grey,
            textColor: Colors.white,
            onTap: () {},
            title: Center(
              child: Text(
                isim,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isim = "";
                resim = "";
              });
              sifirlama(false);
            },
            child: const Text("Seçimi Sıfırla"),
          ),
        ],
      );
    }
  }
}

class Tatli extends StatefulWidget {
  const Tatli({Key? key}) : super(key: key);

  @override
  State<Tatli> createState() => _TatliState();
}

class _TatliState extends State<Tatli> {
  String isim = "", resim = "";
  bool? secim;
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> secimBelirle() async {
    var kisi = await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = kisi.data();
    setState(() {
      secim = map['tatli'];
    });
  }

  Query tatli = FirebaseFirestore.instance
      .collection('tatli_icecek')
      .orderBy('isim', descending: false);

  Future<void> sifirlama(bool sec) async {
    if (sec == false) {
      FirebaseAuth auth = FirebaseAuth.instance;
      var corba = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('tatli')
          .doc('tatli')
          .get();
      dynamic corbaEksiltme = corba.data();
      var bilgi = await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .get();
      dynamic map = bilgi.data();
      String eksilen = corbaEksiltme['tatli_isim'];
      var yemek = await FirebaseFirestore.instance
          .collection('tatli_icecek')
          .doc(eksilen)
          .get();
      dynamic corbaKalori = yemek.data();

      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .update({'ogle': (map['ogle'] - corbaKalori['kalori'])});
      await FirebaseFirestore.instance
          .collection('diyet_listesi')
          .doc(auth.currentUser!.email)
          .collection('tatli')
          .doc('tatli')
          .delete();
      await FirebaseFirestore.instance
          .collection('Users')
          .doc(auth.currentUser!.email)
          .update({'tatli': sec});
      setState(() {
        secim = sec;
      });
    }
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(auth.currentUser!.email)
        .update({'tatli': sec});
    setState(() {
      secim = sec;
    });
  }

  Future tiklama(String Kisim, String Kresim) async {
    sifirlama(true);
    FirebaseAuth auth = FirebaseAuth.instance;
    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .collection('tatli')
        .doc('tatli')
        .set({
      'tatli_isim': Kisim,
      'tatli_resim': Kresim,
    });
    var bilgi = await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .get();
    dynamic map = bilgi.data();
    var yemek = await FirebaseFirestore.instance
        .collection('tatli_icecek')
        .doc(Kisim)
        .get();
    dynamic corbaKalori = yemek.data();

    await FirebaseFirestore.instance
        .collection('diyet_listesi')
        .doc(auth.currentUser!.email)
        .update({'ogle': (map['ogle'] + corbaKalori['kalori'])});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    secimBelirle();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgula('tatli');
    isim = Provider.of<StateData>(context, listen: false).tatli_isim;
    print(isim);
    resim = Provider.of<StateData>(context, listen: false).tatli_resim;
    if (secim != true) {
      return SingleChildScrollView(
        child: StreamBuilder<QuerySnapshot>(
            stream: tatli.snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              List<DocumentSnapshot> listofDocumentSnap = snapshot.data!.docs;
              if (snapshot.hasError) {
                return const CircularProgressIndicator();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: listofDocumentSnap.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data =
                      listofDocumentSnap[index].data()! as Map<String, dynamic>;
                  return Container(
                    margin: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isim = data['isim'];
                          resim = data['resim'];
                        });
                        tiklama(data['isim'], data['resim']);
                      },
                      child: Card(
                        child: Column(
                          children: [
                            Image.network(data['resim']),
                            ListTile(
                              tileColor: Colors.grey,
                              textColor: Colors.white,
                              onTap: () {},
                              title: Center(
                                child: Text(
                                  data['isim'],
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
                },
              );
            }),
      );
    } else {
      return Column(
        children: [
          Image.network(resim),
          ListTile(
            tileColor: Colors.grey,
            textColor: Colors.white,
            onTap: () {},
            title: Center(
              child: Text(
                isim,
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                isim = "";
                resim = "";
              });
              sifirlama(false);
            },
            child: const Text("Seçimi Sıfırla"),
          ),
        ],
      );
    }
  }
}
