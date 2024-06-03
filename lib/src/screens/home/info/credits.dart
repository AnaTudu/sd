import 'package:flutter/material.dart';

class Credits extends StatefulWidget {
  const Credits({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreditsState createState() => _CreditsState();
}

class _CreditsState extends State<Credits> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 60),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'inapoi',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 50, bottom: 10),
              child: const Text(
                'Credite',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 40,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
              child: const Text(
                'Aceasta aplicatie este relizata de Anamaria Tuduce',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.7,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 60),
              child: const Image(
                image: AssetImage("assets/images/aboutUni.png"),
                width: 400,
                height: 400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
