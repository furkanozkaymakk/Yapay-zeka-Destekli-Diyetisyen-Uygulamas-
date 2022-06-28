import 'package:flutter/material.dart';

InputDecoration buildInputDecoration(String yazi, Icon ikon) {
  return InputDecoration(
    filled: true,
    fillColor: Colors.white,
    hintStyle: const TextStyle(color: Colors.black),
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple),
    ),
    labelText: yazi,
    labelStyle: const TextStyle(color: Colors.black),
    prefixIcon: ikon,
    border:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
  );
}

InputDecoration besinEklemeDecoration(String yazi, Icon ikon) {
  return InputDecoration(
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.purple),
    ),
    filled: true,
    fillColor: Colors.grey,
    labelText: yazi,
    labelStyle: const TextStyle(color: Colors.black),
    prefixIcon: ikon,
    border:
        const OutlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
  );
}

BoxDecoration buildBoxDecorationArkaPlan() {
  return const BoxDecoration(
      // gradient: LinearGradient(
      //     begin: Alignment.topRight,
      //     end: Alignment.bottomLeft,
      //     colors: [Colors.purple, Colors.indigo]),
      );
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
      padding: const EdgeInsets.all(12),
      child: Center(child: Text(cell, style: style)),
    );
  }).toList(),
);


class ContainerListe extends StatelessWidget {
  const ContainerListe({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: MediaQuery.of(context).size.width * 0.7,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
    );
  }
}
