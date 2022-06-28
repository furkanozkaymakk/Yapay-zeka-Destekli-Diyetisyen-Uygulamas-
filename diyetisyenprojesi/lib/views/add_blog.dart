import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:diyetisyenprojesi/services/dizayn.dart';
import 'package:diyetisyenprojesi/services/drawer.dart';
import 'package:diyetisyenprojesi/views/ana_sayfa.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddBlog extends StatefulWidget {
  const AddBlog({Key? key}) : super(key: key);

  @override
  _AddBlogState createState() => _AddBlogState();
}

class _AddBlogState extends State<AddBlog> {
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController konubaslik = TextEditingController();
  TextEditingController icerik = TextEditingController();
  UploadTask? uploadTask;
  late String urlAdresi;

  Future uploadFile() async {
    final path = 'files/${image!}';
    final file = File(image!.path);
    final ref = FirebaseStorage.instance.ref().child(path);

    setState(() {
      uploadTask = ref.putFile(file);
    });
    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print('İndirme Adresi : $urlDownload');
    setState(() {
      uploadTask = null;
      urlAdresi = urlDownload.toString();
    });
  }

  File? image;
  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() => this.image = imageTemporary);
    } on PlatformException catch (e) {
      print('Failed to pick Image');
    }
  }

  blogEkle() {
    print('blog eklendi');
    FirebaseFirestore.instance
        .collection('blog_yazilari')
        .doc(konubaslik.text)
        .set({
      'baslik': konubaslik.text,
      'icerik': icerik.text,
      'resim-adresi': urlAdresi,
      'editor': auth.currentUser?.email,
      'yayim_zamani': DateTime.now()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              if (konubaslik.text.length < 6 || icerik.text.length < 10) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Başlık ve İçeriği Detaylandırın'),
                        backgroundColor: Colors.amberAccent,
                        content: const Text(
                            'Başlığınız veya içeriğiniz kısa oldu. Biraz Detaylandırın'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('TAMAM'))
                        ],
                      );
                    });
              } else if (image == null) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Resim Yükleyiniz'),
                        backgroundColor: Colors.amberAccent,
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
                print('Resmin Adresi: $urlAdresi');
                blogEkle();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Anasayfa()),
                    (route) => false);
              }
            },
            child: const Text(
              'Kaydet',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: buildBoxDecorationArkaPlan(),
        //margin: const EdgeInsets.only(left: 15, right: 15),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () => pickImage(),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: image != null
                                ? Image.file(
                                    image!,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.add_a_photo),
                          ),
                        ),
                      ),
                      image != null
                          ? TextButton(
                              onPressed: uploadFile,
                              child: Text('Resmi Yükle'),
                            )
                          : SizedBox(height: 10),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: "Konu Başlığı",
                        ),
                        controller: konubaslik,
                        validator: (value) =>
                            (value ?? '').length > 6 ? null : 'Çok Kısa oldu',
                      ),
                      TextFormField(
                        maxLines: 15,
                        decoration: const InputDecoration(hintText: "İçerik"),
                        controller: icerik,
                        validator: (value) => (value ?? '').length > 10
                            ? null
                            : 'Biraz Uzun yazın',
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: YanMenu(),
    );
  }

  Widget buildProgress() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data!;
          double progress = data.bytesTransferred / data.totalBytes;

          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                  child: Text(
                    '${(100 * progress).roundToDouble()}%',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          );
        } else {
          return SizedBox(height: 50);
        }
      });
}
