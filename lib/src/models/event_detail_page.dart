import 'package:flutter/material.dart';

import 'event.dart';

class EventDetailPage extends StatelessWidget {
  const EventDetailPage(this.event, {super.key});

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Column(
              children: [
                Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    child: Center(
                        child: Column(children: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            'Inapoi',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color(int.parse("#0097b2".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              fontFamily: 'Poppins',
                            ),
                          )),
                      Text(
                        event.title,
                        style: const TextStyle(
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
                Image.network(
                  event.picture,
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 60),
                Text(event.date,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 30,
                        color: Color(
                            int.parse("#0097b2".substring(1, 7), radix: 16) +
                                0xFF000000))),
                Text(event.description,
                    style:
                        const TextStyle(fontFamily: 'Poppins', fontSize: 25)),
              ],
            )));
  }
}
