import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:bbbbbbbbbbbb/src/screens/notifications/notification_service.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/chat.dart';
import 'package:bbbbbbbbbbbb/src/screens/notifications/notification.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/home.dart';
import 'package:bbbbbbbbbbbb/src/screens/profile/calendar.dart';
import 'package:bbbbbbbbbbbb/src/screens/profile/profile.dart';
import 'package:bbbbbbbbbbbb/src/screens/store/store.dart';
import 'package:bbbbbbbbbbbb/src/screens/settings/settings.dart';

void main() {
  runApp(const Start());
}

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    Store(),
    Home(),
    Profile(),
    Settings(),
    Calendar(),
  ];

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((message) {
      LocalNotificationService.display(message);
    });

    LocalNotificationService.storeToken();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniLink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottomOpacity: 0.5,
            elevation: 0.5,
            leading: Container(
              margin: const EdgeInsets.only(
                left: 20.0,
              ),
              child: IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  iconSize: 25,
                  color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                      0xFF000000),
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const Notifications(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  }),
            ),
            toolbarHeight: 90,
            actions: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                  right: 20.0,
                ),
                child: IconButton(
                    icon: const Icon(Icons.message_outlined),
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    iconSize: 25,
                    color: Colors.black,
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const Chat(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }),
              ),
            ],
            title: const Text(
              'UniLink',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: Colors.black),
            ),
            centerTitle: true,
          ),
          body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
          bottomNavigationBar: Container(
            margin:
                const EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
            decoration: BoxDecoration(
                color: Colors.white,
                border:
                    Border.all(color: const Color.fromARGB(255, 212, 212, 212)),
                borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: GNav(
                gap: 3,
                activeColor: Color(
                    int.parse("#0097b2".substring(1, 7), radix: 16) +
                        0xFF000000),
                color: Colors.black,
                selectedIndex: 1,
                iconSize: 25,
                backgroundColor: Colors.transparent,
                padding: const EdgeInsets.all(10),
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                },
                tabs: const [
                  GButton(
                    icon: Icons.local_mall,
                  ),
                  GButton(
                    icon: Icons.home,
                  ),
                  GButton(
                    icon: Icons.account_circle,
                  ),
                  GButton(
                    icon: Icons.settings,
                  ),
                ],
              ),
            ),
          ),
          extendBody: true),
    );
  }
}
