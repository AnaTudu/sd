import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/info/credits.dart';
import 'package:bbbbbbbbbbbb/src/screens/notifications/notification_service.dart';
import 'package:bbbbbbbbbbbb/src/screens/others/splash/splash.dart';
import 'package:bbbbbbbbbbbb/src/screens/others/authentication/registration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'src/screens/start.dart';
import 'src/models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:location/location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Location().requestPermission();
  LocalNotificationService.initialize();
  runApp(const MaterialApp(
    home: Splash(),
    debugShowCheckedModeBanner: false,
  ));
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    await messaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    Location location = Location();
    await location.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const SizedBox(
            height: 25,
          ),
          Image.asset(
            "assets/images/unitips.png",
            height: 70,
            width: 1000,
            fit: BoxFit.fitHeight,
          ),
          const SizedBox(
            height: 50,
          ),
          AuthenticationTextField(
            controller: _emailController,
            hintText: 'Email',
          ),
          AuthenticationTextField(
            controller: _passwordController,
            hintText: 'Password',
            isPassword: true,
          ),
          const SizedBox(height: 10),
          AuthenticationBtn(
            text: 'Login',
            backgroundColor: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
            foregroundColor: Colors.white,
            function: () {
              if (_emailController.text.isNotEmpty &&
                  _passwordController.text.isNotEmpty) {
                FirebaseAuth.instance
                    .signInWithEmailAndPassword(
                        email: _emailController.text,
                        password: _passwordController.text)
                    .then((value) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Start()));
                }).catchError((error) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Icon(
                          Icons.warning,
                          size: 50,
                          color: Color(
                              int.parse("#0097b2".substring(1, 7), radix: 16) +
                                  0xFF000000),
                        ),
                      ),
                      content: const Text('\nParola sau Email incorecte.\n\n'),
                      actions: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                });
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Icon(
                        Icons.warning,
                        size: 50,
                        color: Color(
                            int.parse("#0097b2".substring(1, 7), radix: 16) +
                                0xFF000000),
                      ),
                    ),
                    content: const Text('\nCompletați câmpurile necesare!\n\n'),
                  ),
                );
              }
            },
          ),
          const SizedBox(height: 15),
          // ignore: prefer_const_constructors
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Expanded(
                child: Divider(
                  color: Colors.white,
                  thickness: 0.25,
                  indent: 60,
                  endIndent: 0,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  'SAU',
                  style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
                ),
              ),
              Expanded(
                child: Divider(
                  color: Colors.white,
                  thickness: 0.25,
                  endIndent: 60,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          AuthenticationBtn(
            text: 'Înregistrare',
            backgroundColor: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
            foregroundColor: Colors.white,
            function: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      Registration(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
          ),
          AuthenticationBtn(
            text: 'Credite',
            backgroundColor: Colors.white,
            foregroundColor: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
            function: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Credits()),
              );
            },
          ),
        ]),
      ),
    );
  }
}
