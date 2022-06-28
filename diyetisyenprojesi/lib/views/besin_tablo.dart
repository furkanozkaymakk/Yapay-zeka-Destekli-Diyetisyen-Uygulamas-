import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:flutter/material.dart';

class BesinTablo extends StatefulWidget {
  BesinTablo({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<BesinTablo> {
  static const int sortName = 0;
  bool isAscending = true;
  int sortType = sortName;

  Query etler = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Etler')
      .orderBy('besinler', descending: true);
  Query balik = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Balık')
      .orderBy('besinler', descending: true);
  Query baklagiller = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Baklagiller')
      .orderBy('besinler', descending: true);
  Query meyve = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Meyve')
      .orderBy('besinler', descending: true);
  Query sebze = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Sebze')
      .orderBy('besinler', descending: true);
  Query tavuk = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Tavuk')
      .orderBy('besinler', descending: true);
  Query yaglitohumlar = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Yağlı Tohumlar')
      .orderBy('besinler', descending: true);
  Query seker = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Şeker ve Tatlılar')
      .orderBy('besinler', descending: true);
  Query sut = FirebaseFirestore.instance
      .collection('besinler')
      .where('cins', isEqualTo: 'Süt ve Ürünleri')
      .orderBy('besinler', descending: true);

  Query corba = FirebaseFirestore.instance
      .collection('corba')
      .where('isim', isNotEqualTo: 'Süt ve Ürünleri')
      .orderBy('isim', descending: true);
  Query ana_yemek = FirebaseFirestore.instance
      .collection('ana_yemek')
      .where('isim', isNotEqualTo: 'Süt ve Ürünleri')
      .orderBy('isim', descending: true);
  Query salata = FirebaseFirestore.instance
      .collection('salata_makarna')
      .where('isim', isNotEqualTo: 'Süt ve Ürünleri')
      .orderBy('isim', descending: true);
  Query tatli = FirebaseFirestore.instance
      .collection('tatli_icecek')
      .where('isim', isNotEqualTo: 'Süt ve Ürünleri')
      .orderBy('isim', descending: true);


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: YanMenu(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Center(child: Text(widget.title)),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(left: 3, right: 3),
        decoration: buildBoxDecorationArkaPlan(),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                buildText('ETLER'),
                buildTableHeader(),
                buildStreamBuilder(etler),

                ///
                const SizedBox(height: 10),
                buildText('BALIKLAR'),
                buildTableHeader(),
                buildStreamBuilder(balik),

                ///
                const SizedBox(height: 10),
                buildText('BAKLAGİLLER'),
                buildTableHeader(),
                buildStreamBuilder(baklagiller),

                ///
                const SizedBox(height: 10),
                buildText('SEBZE'),
                buildTableHeader(),
                buildStreamBuilder(sebze),

                ///
                const SizedBox(height: 10),
                buildText('TAVUK'),
                buildTableHeader(),
                buildStreamBuilder(tavuk),

                ///
                const SizedBox(height: 10),
                buildText('YAĞLI TOHUMLAR'),
                buildTableHeader(),
                buildStreamBuilder(yaglitohumlar),

                ///
                const SizedBox(height: 10),
                buildText('ŞEKER VE TATLILAR'),
                buildTableHeader(),
                buildStreamBuilder(seker),

                ///
                const SizedBox(height: 10),
                buildText('SÜT VE ÜRÜNLERİ'),
                buildTableHeader(),
                buildStreamBuilder(sut),

                ///
                const SizedBox(height: 10),
                buildText('MEYVE'),
                buildTableHeader(),
                buildStreamBuilder(meyve),

                ///
                const SizedBox(height: 10),
                buildText('Çorba'),
                buildTableHeader4(),
                buildStreamBuilderr(corba),
                ///

                const SizedBox(height: 10),
                buildText('Ana Yemek'),
                buildTableHeader4(),
                buildStreamBuilderr(ana_yemek),
                ///

                const SizedBox(height: 10),
                buildText('Salata/Makarna'),
                buildTableHeader4(),
                buildStreamBuilderr(salata),
                ///

                const SizedBox(height: 10),
                buildText('Tatlı/ İçecek'),
                buildTableHeader4(),
                buildStreamBuilderr(tatli),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Table buildTableHeader() {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(6),
      ),
      columnWidths: const {
        0: FractionColumnWidth(0.29),
        1: FractionColumnWidth(0.17),
        2: FractionColumnWidth(0.19),
        3: FractionColumnWidth(0.14),
        4: FractionColumnWidth(0.21),
      },
      children: [
        buildRow(
            ['Besin İsimleri', 'Kalori', 'Protein', 'Yağ', 'Karbon hidrat'],
            isHeader: true)
      ],
    );
  }

  Table buildTableHeader4() {
    return Table(
      border: TableBorder.all(
        borderRadius: BorderRadius.circular(6),
      ),
      columnWidths: const {
        0: FractionColumnWidth(0.70),
        1: FractionColumnWidth(0.30),
      },
      children: [
        buildRow(
            ['Besin İsimleri', 'Kalori'],
            isHeader: true)
      ],
    );
  }

  Text buildText(String yazi) {
    return Text(
      yazi,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilder(Query arama) {
    return StreamBuilder<QuerySnapshot>(
        stream: arama.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;
                return Table(
                  border:
                      TableBorder.all(borderRadius: BorderRadius.circular(6)),
                  columnWidths: const {
                    0: FractionColumnWidth(0.29),
                    1: FractionColumnWidth(0.17),
                    2: FractionColumnWidth(0.19),
                    3: FractionColumnWidth(0.14),
                    4: FractionColumnWidth(0.21),
                  },
                  children: [
                    buildRow([
                      data['besinler'],
                      data['kalori'],
                      data['protein'],
                      data['yag'],
                      data['karbonhidrat']
                    ])
                  ],
                );
              }).toList(),
            ),
          );
        });
  }

  StreamBuilder<QuerySnapshot<Object?>> buildStreamBuilderr(Query arama) {
    return StreamBuilder<QuerySnapshot>(
        stream: arama.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }

          return SingleChildScrollView(
            child: Column(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
                return Table(
                  border:
                  TableBorder.all(borderRadius: BorderRadius.circular(6)),
                  columnWidths: const {
                    0: FractionColumnWidth(0.70),
                    1: FractionColumnWidth(0.30),
                  },
                  children: [
                    buildRow([
                      data['isim'],
                      data['kalori'].toString()
                    ])
                  ],
                );
              }).toList(),
            ),
          );
        });
  }


  TableRow buildRow(List<String> cells, {bool isHeader = false}) => TableRow(
        decoration: isHeader
            ? BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(6))
            : BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(6)),
        children: cells.map((cell) {
          final style = TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
              fontSize: 15);

          return Padding(
            padding: EdgeInsets.all(12),
            child: Center(child: Text(cell, style: style)),
          );
        }).toList(),
      );
}
