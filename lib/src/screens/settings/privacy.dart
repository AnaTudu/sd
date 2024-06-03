import 'package:flutter/material.dart';

class Privacidade extends StatelessWidget {
  const Privacidade({super.key});

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
              'Confidențialitate',
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
                'Actualizat: 23 mai 2024 Această Politică de notificare descrie politicile și procedurile noastre privind colectarea, utilizarea și dezvăluirea informațiilor dvs. atunci când utilizați Serviciul și vă informează despre drepturile dumneavoastră de confidențialitate și despre modul în care legea vă protejează datele dumneavoastră cu caracter personal pentru a furniza și îmbunătăți Serviciul. Prin utilizarea Serviciului, sunteți de acord cu colectarea și utilizarea informațiilor în conformitate cu această Politică de confidențialitate. Această politică de confidențialitate a fost creată cu ajutorul Generatorului gratuit de politici de confidențialitate.',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.7))),
        Container(
            margin: const EdgeInsets.only(left: 50, right: 50, bottom: 50),
            child: const Text(
                'Aplicația va păstra datele dumneavoastră cu caracter personal doar atât timp cât este necesar pentru scopurile stabilite. Vom păstra și folosi datele dumneavoastră cu caracter personal în măsura în care este necesar pentru a ne conforma obligațiilor legale (de exemplu, dacă ni se cere să păstrăm datele dumneavoastră pentru a respecta legile aplicabile), a rezolva litigiile și a aplica acordurile și politicile legale.\nnVom păstra și datele de utilizare în scopuri de analiză internă. Datele de utilizare sunt, în general, păstrate pentru o perioadă mai scurtă de timp, cu excepția cazului în care aceste date sunt utilizate pentru a consolida securitatea',
                textAlign: TextAlign.center,
                style: TextStyle(fontFamily: 'Poppins', fontSize: 15.7))),
      ],
    ));
  }
}
