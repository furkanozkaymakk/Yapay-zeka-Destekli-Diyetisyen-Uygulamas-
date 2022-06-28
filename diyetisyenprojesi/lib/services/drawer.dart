import 'package:diyetisyenprojesi/services/state_data.dart';
import 'package:diyetisyenprojesi/views/ana_sayfa.dart';
import 'package:diyetisyenprojesi/views/besin_ekleme.dart';
import 'package:diyetisyenprojesi/views/besin_tablo.dart';
import 'package:diyetisyenprojesi/views/bilgi_guncelle.dart';
import 'package:diyetisyenprojesi/views/diyet_listesi.dart';
import 'package:diyetisyenprojesi/views/hesaplama.dart';
import 'package:diyetisyenprojesi/views/ileti%C5%9Fim.dart';
import 'package:diyetisyenprojesi/views/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

///         Yan Menü Tasarımı

class YanMenu extends StatefulWidget {
  @override
  _YanMenuState createState() => _YanMenuState();
}

class _YanMenuState extends State<YanMenu> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    Provider.of<StateData>(context).durumSorgula();
    var islem = Provider.of<StateData>(context).islem;
    var rol = Provider.of<StateData>(context).rol;
    return SafeArea(
      child: Container(
        child: ListTileTheme(
          textColor: Colors.white,
          iconColor: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              auth.currentUser != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BilgileriGuncelle()));
                      },
                      child: Container(
                        child: const Icon(
                          FontAwesomeIcons.user,
                          size: 45,
                        ),
                        width: 128,
                        height: 128,
                        margin: const EdgeInsets.only(top: 24, bottom: 64),
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          color: Colors.black26,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : const SizedBox(height: 200),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text(
                  'Ana Sayfa',
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Anasayfa(),
                    ),
                  );
                },
              ),
              auth.currentUser != null && rol == 'yönetici'
                  ? ListTile(
                      leading: const Icon(Icons.calculate),
                      title: const Text(
                        'Besin Ekleme',
                        style: TextStyle(fontSize: 25),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BesinEkleme()),
                        );
                      },
                    )
                  : const SizedBox(),
              ListTile(
                leading: const Icon(Icons.fastfood),
                title: const Text(
                  'Besin Değerleri',
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BesinTablo(
                                title: 'Besin Tablosu',
                              )));
                },
              ),
              islem != false && auth.currentUser != null
                  ? ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: const Text(
                        'Diyet Listesi',
                        style: TextStyle(fontSize: 25),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DiyetListesi(),
                          ),
                        );
                      },
                    )
                  : const SizedBox(),
              auth.currentUser == null
                  ? const SizedBox()
                  : ListTile(
                      leading: const Icon(Icons.fastfood),
                      title: const Text(
                        'Diyet Listesi Oluşturma',
                        style: TextStyle(fontSize: 25),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Hesaplama()));
                      },
                    ),
              ListTile(
                leading: const Icon(Icons.forum_outlined),
                title: const Text(
                  'İletişim',
                  style: TextStyle(fontSize: 25),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Iletisim()));
                },
              ),
              const Spacer(),
              auth.currentUser == null
                  ? DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Login()),
                            );
                          },
                          child: const Text(
                            'Giriş',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    )
                  : DefaultTextStyle(
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white54,
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 16.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.white),
                          onPressed: () {
                            FirebaseAuth.instance.signOut().then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Anasayfa()),
                                  (route) => false);
                            });
                          },
                          child: const Text(
                            'Çıkış Yap',
                            style: TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
