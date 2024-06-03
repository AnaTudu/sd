import 'package:flutter/material.dart';

class ECabinet extends StatelessWidget {
  const ECabinet({super.key});

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
              'Cabinet E+',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 40),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 50, bottom: 40, left: 40, right: 40),
            child: const Text(
              'Biroul de asistență pentru studenți E+ oferă asistență față în față studenților pentru a-i ajuta să rezolve îndoielile și să îi direcționeze către serviciile relevante.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
            )),
        const Text(
          'A 2-a până la a 6-a dimineață: 9:30-12:30 (Sala A263, EST)\nA 2-a-6 după-amiază: 14:30-16:30 (Sala D203, EST)',
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
        ),
        Container(
            margin: const EdgeInsets.only(top: 50, bottom: 50),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                    image: AssetImage('assets/images/unitips2.png'),
                    width: 80,
                    height: 80),
                Image(
                    image: AssetImage('assets/images/ipslogo.png'),
                    width: 80,
                    height: 80)
              ],
            )),
      ],
    ));
  }
}
