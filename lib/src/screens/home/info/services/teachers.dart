import 'package:flutter/material.dart';

import '../../../../models/info_services_teachers.dart';

const List<String> schools = <String>['ESTS', 'ESCE', 'ESE', 'ESTB'];
const List<String> areas = <String>['Matematica', 'Informatica', 'Fizica'];
const List<String> teachers = <String>['Ana Tuduce', 'Pop Ion', 'Oana Popa'];

class Teachers extends StatelessWidget {
  const Teachers({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyWidget();
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

// MUDAR A CENA DA IMAGEM DO FIREBASE NO PROFILE

class _MyWidgetState extends State<MyWidget> {
  String? dropdownValue;
  String? dropdownValue2;
  String? dropdownValue3;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ListView(children: [
      Container(
          margin: const EdgeInsets.only(top: 60),
          child: TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'inapoi',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                      0xFF000000),
                ),
              ))),
      Container(
          margin: const EdgeInsets.only(top: 50, bottom: 40),
          child: const Text(
            'Profesori',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 40),
          )),
      Container(
        margin: const EdgeInsets.only(right: 65, left: 65),
        child: DropdownButton<String>(
          value: dropdownValue,
          hint: const Text('Selectati scoala'),
          isExpanded: true,
          icon: const Icon(Icons.arrow_downward, size: 15),
          style: TextStyle(
            color: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          ),
          underline: Container(
            height: 1.5,
            color: Colors.grey,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue = value!;
            });
          },
          items: schools.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 25, right: 65, left: 65),
        child: DropdownButton<String>(
          value: dropdownValue2,
          hint: const Text('Selectati materia'),
          isExpanded: true,
          icon: const Icon(
            Icons.arrow_downward,
            size: 15,
          ),
          style: TextStyle(
            color: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          ),
          underline: Container(height: 1.5, color: Colors.grey),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue2 = value!;
            });
          },
          items: areas.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 25, right: 65, left: 65),
        child: DropdownButton<String>(
          value: dropdownValue3,
          hint: const Text('Selectati profesor'),
          icon: const Icon(
            Icons.arrow_downward,
            size: 15,
          ),
          isExpanded: true,
          style: TextStyle(
            color: Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          ),
          underline: Container(
            height: 1.5,
            color: Colors.grey,
          ),
          onChanged: (String? value) {
            // This is called when the user selects an item.
            setState(() {
              dropdownValue3 = value!;
            });
          },
          items: teachers.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
      Container(
        height: 60,
        margin: const EdgeInsets.only(left: 60, right: 60, top: 60),
        child: TextButton(
          onPressed: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) => InfoTeacher(
                    role: 'Professor',
                    email: 'ana@student.upt.ro',
                    name: dropdownValue3,
                    area: dropdownValue2,
                    code: '21346',
                    status: 'Activ',
                    room: 'F200'),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Color(
                  int.parse("#0097b2".substring(1, 7), radix: 16) +
                      0xFF000000)),
              foregroundColor: WidgetStateProperty.all(Colors.white),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
              ))),
          child: const Text('Cautare',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15)),
        ),
      ),
    ]));
  }
}
