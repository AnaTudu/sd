import 'package:flutter/material.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
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
                ))),
        Container(
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: const Text(
              'Obiective',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 40),
            )),
        Container(
            margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
            child: const Text(
                'O aplicație academică care își propune să ajute întreaga comunitate.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.7))),
        Container(
            margin: const EdgeInsets.only(bottom: 60),
            child: const Image(
              image: AssetImage("assets/images/aboutUni.png"),
              width: 400,
              height: 400,
            )),
      ],
    ));
  }
}
