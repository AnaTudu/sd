import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/event.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/event/create_event.dart';
import 'package:bbbbbbbbbbbb/src/models/event_container.dart';
import '../../../data/dataset.dart';

class Events extends StatelessWidget {
  const Events({super.key});

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getEvents() async {
    final eventsInstance = FirebaseFirestore.instance.collection('events');
    final events = await eventsInstance.get();

    return events.docs;
  }

  Future<String> getType() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    return userSnapshot.data()?['type'];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
      future: getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body:
                Center(child: Text('Eroare la încercarea de a colecta date.')),
          );
        } else {
          final events = snapshot.data;

          if (events == null) {
            return const Scaffold(
              body: Center(child: Text('Fisier negasit.')),
            );
          }

          eventsDataset.clear();

          for (var event in events) {
            final id = event.id;
            final date = event.data()!['date'];
            final description = event.data()!['description'];
            final title = event.data()!['title'];
            final picture = event.data()!['picture'];
            final array = event.data()!['enrolled'];

            Color color = Colors.white;

            for (var a in array) {
              if (a == FirebaseAuth.instance.currentUser?.uid) {
                color = Colors.yellow;
              }
            }

            eventsDataset.add(Event(
              id: id,
              date: date,
              title: title,
              description: description,
              picture: picture,
              color: color,
            ));
          }

          if (eventsDataset.isEmpty) {
            return Scaffold(
                body: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 50, bottom: 30),
                        child: Center(
                          child: Row(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 50),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    color: Color(int.parse(
                                            "#0097b2".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                                  ),
                                ),
                              ),
                              const Text(
                                'Evenimente',
                                style: TextStyle(
                                  fontSize: 40,
                                  fontFamily: 'Poppins',
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              FutureBuilder<String>(
                                future: getType(),
                                builder: (context, snapshot) {
                                  final userType = snapshot.data;
                                  if (userType == 'admin') {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 10),
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.add,
                                          color: Colors.blue,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const CreateEventPage(),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  } else {
                                    return const SizedBox(); // Return an empty container if not an admin
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Center(
                        child: Text('Fara eveniment',
                            style: TextStyle(fontFamily: 'Poppins')),
                      ),
                    ])));
          }

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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 50),
                            child: TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Color(int.parse(
                                        "#0097b2".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                              ),
                            ),
                          ),
                          const Text(
                            'Evenimente',
                            style: TextStyle(
                              fontSize: 40,
                              fontFamily: 'Poppins',
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          FutureBuilder<String>(
                            future: getType(),
                            builder: (context, snapshot) {
                              final userType = snapshot.data;
                              if (userType == 'admin') {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    icon: const Icon(
                                      Icons.add,
                                      color: Colors.blue,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CreateEventPage(),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              } else {
                                return const SizedBox(); // Return an empty container if not an admin
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: eventsDataset.length,
                      padding: const EdgeInsets.only(
                          top: 30, bottom: 10, left: 15, right: 15),
                      itemBuilder: (context, index) {
                        return EventsContainer(
                            eventsDataset[index], eventsDataset[index].color);
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
