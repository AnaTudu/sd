import 'package:flutter/material.dart';
import '../../../data/dataset.dart';
import 'package:bbbbbbbbbbbb/src/models/info_pdf.dart';

class Calendars extends StatelessWidget {
  const Calendars({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: ListView(children: [
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
                      'Calendare',
                      style: TextStyle(
                          fontSize: 40,
                          fontFamily: 'Poppins',
                          color: Colors.black,
                          fontWeight: FontWeight.w700),
                    ),
                  ]))),
              const Divider(
                color: Colors.grey,
                height: 1,
              ),
              const SizedBox(
                height: 25,
              ),
              Column(
                  children: calendars
                      .map((doc) => ListTile(
                          contentPadding: const EdgeInsets.only(
                              right: 50, bottom: 20, top: 20, left: 35),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        ReaderScreen(doc),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          title: Text(
                            doc.title!,
                            style: const TextStyle(
                                fontFamily: 'Poppins', fontSize: 20),
                          ),
                          trailing: Text(
                            '${doc.detail}',
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.grey,
                                fontSize: 20),
                          ),
                          leading: const Icon(Icons.picture_as_pdf_outlined,
                              color: Colors.red, size: 50)))
                      .toList()),
              const SizedBox(
                height: 25,
              ),
            ])));
  }
}
