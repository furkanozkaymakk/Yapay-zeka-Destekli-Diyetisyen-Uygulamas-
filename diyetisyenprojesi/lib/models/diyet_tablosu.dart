import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/dizayn.dart';
import '../services/state_data.dart';

///       Diyet Listesinde Gösterilen Sayfaların Tasarımları

class KahvaltiTablo extends StatefulWidget {
  const KahvaltiTablo({Key? key}) : super(key: key);

  @override
  State<KahvaltiTablo> createState() => _KahvaltiTabloState();
}

class _KahvaltiTabloState extends State<KahvaltiTablo> {
  String? besin_kalori;
  var arama = FirebaseFirestore.instance
      .collection('diyet_listesi')
      .doc(FirebaseAuth.instance.currentUser!.email)
      .collection('kahvalti')
      .where('isim', isNotEqualTo: 'dsa');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
      child: Container(
        child: Column(
          children: [
            Table(
              border: TableBorder.all(borderRadius: BorderRadius.circular(6)),
              columnWidths: const {
                0: FractionColumnWidth(1),
              },
              children: [
                buildRow([
                  'Yiyecek İsim',
                ], isHeader: true),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: arama.snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                return SingleChildScrollView(
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return Table(
                        border: TableBorder.all(
                            borderRadius: BorderRadius.circular(6)),
                        columnWidths: const {
                          0: FractionColumnWidth(1),
                        },
                        children: [
                          buildRow([
                            data['isim'],
                          ])
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            )
          ],
        ),
      ),
    ));
  }
}

class OgleTablo extends StatefulWidget {
  const OgleTablo({Key? key}) : super(key: key);

  @override
  State<OgleTablo> createState() => _OgleTabloState();
}

class _OgleTabloState extends State<OgleTablo> {
  int? corba, ana_yemek, salata, tatli;
  String corba_isim = "",
      ana_yemek_isim = "",
      salata_isim = "",
      tatli_isim = "";

  Future<void> besinKalori(yemek, isim) async {
    var yemekkalori =
        await FirebaseFirestore.instance.collection(yemek).doc(isim).get();
    dynamic map = yemekkalori.data();
    setState(() {
      switch (yemek) {
        case 'corba':
          corba = map['kalori'];
          break;
        case 'ana_yemek':
          ana_yemek = map['kalori'];
          break;
        case 'salata_makarna':
          salata = map['kalori'];
          break;
        default:
          tatli = map['kalori'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgula('corba');
    corba_isim = Provider.of<StateData>(context, listen: false).corba_isim;
    besinKalori('corba', corba_isim);

    Provider.of<StateData>(context, listen: false).yemekSorgula('ana_yemek');
    ana_yemek_isim =
        Provider.of<StateData>(context, listen: false).ana_yemek_isim;
    besinKalori('ana_yemek', ana_yemek_isim);

    Provider.of<StateData>(context, listen: false).yemekSorgula('salata');
    salata_isim = Provider.of<StateData>(context, listen: false).salata_isim;
    besinKalori('salata_makarna', salata_isim);

    Provider.of<StateData>(context, listen: false).yemekSorgula('tatli');
    tatli_isim = Provider.of<StateData>(context, listen: false).tatli_isim;
    besinKalori('tatli_icecek', tatli_isim);
    return SafeArea(
      child: Container(
        child: Column(children: [
          Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(6)),
            columnWidths: const {
              0: FractionColumnWidth(1),
            },
            children: [
              buildRow(['Yiyecek İsim'], isHeader: true),
              buildRow([
                corba_isim,
              ]),
              buildRow([
                ana_yemek_isim,
              ]),
              buildRow([
                salata_isim,
              ]),
              buildRow([
                tatli_isim,
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}

class AksamTablo extends StatefulWidget {
  const AksamTablo({Key? key}) : super(key: key);

  @override
  State<AksamTablo> createState() => _AksamTabloState();
}

class _AksamTabloState extends State<AksamTablo> {
  int? corba_aksam, anayemek_aksam, salata_aksam, tatli_aksam;
  String corba_aksam_isim = "",
      ana_yemek_aksam_isim = "",
      salata_aksam_isim = "",
      tatli_aksam_isim = "";

  Future<void> besinKalori(yemek, isim) async {
    var yemekkalori =
        await FirebaseFirestore.instance.collection(yemek).doc(isim).get();
    dynamic map = yemekkalori.data();
    setState(() {
      switch (yemek) {
        case 'corba':
          corba_aksam = map['kalori'];
          break;
        case 'ana_yemek':
          anayemek_aksam = map['kalori'];
          break;
        case 'salata_makarna':
          salata_aksam = map['kalori'];
          break;
        default:
          tatli_aksam = map['kalori'];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context, listen: false).yemekSorgulaAksam('corba');
    corba_aksam_isim =
        Provider.of<StateData>(context, listen: false).corba_aksam_isim;
    besinKalori('corba', corba_aksam_isim);

    Provider.of<StateData>(context, listen: false)
        .yemekSorgulaAksam('ana_yemek');
    ana_yemek_aksam_isim =
        Provider.of<StateData>(context, listen: false).ana_yemek_aksam_isim;
    besinKalori('ana_yemek', ana_yemek_aksam_isim);

    Provider.of<StateData>(context, listen: false).yemekSorgulaAksam('salata');
    salata_aksam_isim =
        Provider.of<StateData>(context, listen: false).salata_aksam_isim;
    besinKalori('salata_makarna', salata_aksam_isim);

    Provider.of<StateData>(context, listen: false).yemekSorgulaAksam('tatli');
    tatli_aksam_isim =
        Provider.of<StateData>(context, listen: false).tatli_aksam_isim;
    besinKalori('tatli_icecek', tatli_aksam_isim);
    return SafeArea(
      child: Container(
        child: Column(children: [
          Table(
            border: TableBorder.all(borderRadius: BorderRadius.circular(6)),
            columnWidths: const {
              0: FractionColumnWidth(1),
            },
            children: [
              buildRow([
                'Yiyecek İsim',
              ], isHeader: true),
              buildRow([
                corba_aksam_isim,
              ]),
              buildRow([ana_yemek_aksam_isim]),
              buildRow([
                salata_aksam_isim,
              ]),
              buildRow([
                tatli_aksam_isim,
              ]),
            ],
          ),
        ]),
      ),
    );
  }
}
