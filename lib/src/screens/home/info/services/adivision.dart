import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ADivision extends StatelessWidget {
  const ADivision({super.key});

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
                  'Inapoi',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                  ),
                ))),
        Container(
            margin: const EdgeInsets.only(top: 50, bottom: 10),
            child: const Text(
              'Divizia\nAcademică',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 40),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 50, bottom: 10, left: 40, right: 40),
            child: const Text(
              'În cadrul Direcției Academice elevii efectuează toate actele legate de înscrierea și înscrierea lor în școlile Institutului.Politécnico de Setúbal. Os estudantes podem ainda obter informações relativas às Escolas, solicitar alterações que considerem necessárias, pedir comprovativos de matrícula, de frequência, entre outros. ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 50, bottom: 10, left: 40, right: 40),
            child: const Text(
              ' Cladirea A',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 10, left: 40, right: 40),
            child: const Text(
              'Luni: 9:30-11:30 și 14:00-16:00\nMarți: 11:00-12:30 și 15:00-18:30\nMiercuri: închis\nJoi: 11:00-12:30 și 15:00-18:30\nVineri: 9: 30:00-11:30 și 14:00-16:00',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 50, bottom: 10, left: 40, right: 40),
            child: const Text(
              'Cladirea B',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700),
            )),
        Container(
            margin:
                const EdgeInsets.only(top: 10, bottom: 60, left: 40, right: 40),
            child: const Text(
              'Luni: 9:30-11:30 și 14:00-16:00\nMarți: 11:00-12:30 și 15:00-18:30\nMiercuri: închis\nJoi: 11:00-12:30 și 15:00-18:30\nVineri: 9: 30:00-11:30 și 14:00-16:00',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontFamily: 'Poppins', fontSize: 15),
            )),
        GestureDetector(
            onTap: () {
              launchUrl(Uri.parse('https://www.suporte.ips.pt/helpdesk/'));
            },
            child: const Text(
              'https://www.suporte.ips.pt/helpdesk/',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blue, fontFamily: 'Poppins', fontSize: 15),
            )),
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
