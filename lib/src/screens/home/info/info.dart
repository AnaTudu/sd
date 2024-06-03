import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/info/services.dart';
import '../../../data/dataset.dart';
import 'package:bbbbbbbbbbbb/src/models/pdf_document_model.dart';
import 'calendars.dart';
import 'menus.dart';

class Info extends StatelessWidget {
  const Info({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWidget();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void> getPDFS() async {
    final ref = FirebaseStorage.instance.ref().child('calendars');
    ref.listAll().then((result) {
      calendars.clear();
      // ignore: avoid_function_literals_in_foreach_calls
      result.items.forEach((item) async {
        final ref = FirebaseStorage.instance.ref().child(item.fullPath);
        final url = await ref.getDownloadURL();

        String delimiter = '.';
        String delimiter2 = '/';

        int lastIndex = item.fullPath.indexOf(delimiter);
        String title = item.fullPath.substring(0, lastIndex);
        int lastIndex2 = item.fullPath.indexOf(delimiter2);

        String delimiter3 = '(';
        String delimiter4 = ')';

        int lastIndex3 = item.fullPath.indexOf(delimiter3);
        int lastIndex4 = item.fullPath.indexOf(delimiter4);
        String detail = item.fullPath.substring(lastIndex3 + 1, lastIndex4);

        title = item.fullPath.substring(lastIndex2 + 1, lastIndex3);
        calendars.add(PDFDocument(title, url, detail));
      });
    });

    final ref2 = FirebaseStorage.instance.ref().child('menus');
    ref2.listAll().then((result) {
      menus.clear();
      // ignore: avoid_function_literals_in_foreach_calls
      result.items.forEach((item) async {
        final ref2 = FirebaseStorage.instance.ref().child(item.fullPath);
        final url = await ref2.getDownloadURL();

        String delimiter = '.';
        String delimiter2 = '/';

        int lastIndex = item.fullPath.indexOf(delimiter);
        String title = item.fullPath.substring(0, lastIndex);
        int lastIndex2 = item.fullPath.indexOf(delimiter2);

        String delimiter3 = '(';
        String delimiter4 = ')';

        int lastIndex3 = item.fullPath.indexOf(delimiter3);
        int lastIndex4 = item.fullPath.indexOf(delimiter4);
        String detail = item.fullPath.substring(lastIndex3 + 1, lastIndex4);

        title = item.fullPath.substring(lastIndex2 + 1, lastIndex3);
        menus.add(PDFDocument(title, url, detail));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: getPDFS(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // a espera ...
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Erro
            return const Center(child: Text('Eroare la colectarea datelor.'));
          } else {
            return Scaffold(
                body: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: ListView(
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 50, bottom: 30),
                            child: Center(
                                child: Column(children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('inapoi',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Poppins',
                                          color: Color(int.parse(
                                                  "#0097b2".substring(1, 7),
                                                  radix: 16) +
                                              0xFF000000)))),
                              const Text(
                                'Informatii',
                                style: TextStyle(
                                    fontSize: 40,
                                    fontFamily: 'Poppins',
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700),
                              ),
                            ]))),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const Menus(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }, // Image tapped
                                child: const Image(
                                    image: AssetImage(
                                        'assets/images/ementas.png')),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const Calendars(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }, // Image tapped
                                child: const Image(
                                  image: AssetImage(
                                      'assets/images/calendarios.png'),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const Services(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ),
                                  );
                                }, // Image tapped
                                child: const Image(
                                    image: AssetImage(
                                        'assets/images/servicos.png')),
                              )
                            ],
                          ),
                        )
                      ],
                    )));
          }
        });
  }
}
