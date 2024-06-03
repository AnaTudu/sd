import 'package:flutter/material.dart';

class Termos extends StatelessWidget {
  const Termos({super.key});

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
            margin: const EdgeInsets.only(
              top: 50,
              bottom: 10,
            ),
            child: const Text(
              'Termeni',
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
                'Actualizat: 23 mai 2024\n\nAceastă Politică de notificare descrie politicile și procedurile noastre privind colectarea, utilizarea și dezvăluirea informațiilor dvs. atunci când utilizați Serviciul și vă informează despre drepturile dumneavoastră de confidențialitate și despre modul în care legea vă protejează datele dumneavoastră cu caracter personal pentru a furniza și îmbunătăți Serviciul. Prin utilizarea Serviciului, sunteți de acord cu colectarea și utilizarea informațiilor în conformitate cu această Politică de confidențialitate. Această politică de confidențialitate a fost creată cu ajutorul Generatorului gratuit de politici de confidențialitate.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.7))),
        Container(
            margin: const EdgeInsets.only(left: 50, right: 50, bottom: 10),
            child: const Text(
              'Servicii',
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
                'Actualizat: 23 mai 2024\n\nAceastă Politică de notificare descrie politicile și procedurile noastre privind colectarea, utilizarea și dezvăluirea informațiilor dvs. atunci când utilizați Serviciul și vă informează despre drepturile dumneavoastră de confidențialitate și despre modul în care legea vă protejează datele dumneavoastră cu caracter personal pentru a furniza și îmbunătăți Serviciul. Prin utilizarea Serviciului, sunteți de acord cu colectarea și utilizarea informațiilor în conformitate cu această Politică de confidențialitate. Această politică de confidențialitate a fost creată cu ajutorul Generatorului gratuit de politici de confidențialitate.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.7))),
      ],
    ));
  }
}
