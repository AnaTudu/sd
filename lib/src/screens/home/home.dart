import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/map/destination.dart';
import 'package:bbbbbbbbbbbb/src/models/home_choose.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/event/events.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/forum/forums.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/info/info.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHome();
  }
}

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userData = await userRef.get();
    return userData;
  }

  String? mtoken = '';

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(auth.currentUser!.uid)
        .set({'fcmToken': token});
  }

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.instance.subscribeToTopic('all');
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still fetching data
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error occurred while fetching data
            return const Center(
                child: Text('A apărut o eroare la preluarea datelor'));
          } else {
            // Data retrieved successfully
            final userData = snapshot.data!;

            if (!userData.exists) {
              // Document does not exist, handle this case accordingly
              return const Center(child: Text('User data does not exist'));
            }

            String name1 = userData.get('name');

            int hour = DateTime.now().hour;
            String hourToPresent;

            if (hour >= 6 && hour <= 12) {
              hourToPresent = 'Buna dimineata, ';
            } else if (hour > 12 && hour <= 19) {
              hourToPresent = 'Buna ziua, ';
            } else {
              hourToPresent = 'Buna seara, ';
            }

            return Center(
              child:
                  ListView(physics: const ClampingScrollPhysics(), children: [
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(top: 60.0),
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontFamily: 'Popppins',
                            ),
                            children: <TextSpan>[
                              TextSpan(text: hourToPresent),
                              TextSpan(
                                text: name1,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Color(int.parse(
                                          "#0097b2".substring(1, 7),
                                          radix: 16) +
                                      0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 50.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 15.0,
                            ),
                            child: HomeChooseOptionBtn(
                              text: 'Info',
                              icon: Icons.info,
                              function: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const Info(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          ),
                          HomeChooseOptionBtn(
                            text: 'Forum',
                            icon: Icons.people_alt_outlined,
                            function: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const Forums(),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                        top: 15.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                              right: 15.0,
                            ),
                            child: HomeChooseOptionBtn(
                              text: 'Mapa',
                              icon: Icons.map_outlined,
                              function: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const Destination(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                          ),
                          HomeChooseOptionBtn(
                              text: 'Evenimente',
                              icon: Icons.event,
                              function: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const Events(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
            );
          }
        });
  }
}
