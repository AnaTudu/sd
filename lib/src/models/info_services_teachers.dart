import 'package:flutter/material.dart';

class InfoTeacher extends StatelessWidget {
  const InfoTeacher({
    super.key,
    required this.role,
    required this.email,
    required this.name,
    required this.area,
    required this.code,
    required this.status,
    required this.room,
  });

  final String role, email, code, status, room;
  final String? name, area;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        Container(
            margin: const EdgeInsets.only(top: 60, bottom: 35),
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
            width: 350,
            height: 500,
            padding: EdgeInsets.zero,
            margin: EdgeInsets.zero,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.blue, spreadRadius: 0.5),
              ],
            ),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 40, top: 60),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            role,
                            style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 18,
                                fontWeight: FontWeight.w700),
                          ),
                          const Padding(
                              padding: EdgeInsets.only(left: 150),
                              child: Icon(Icons.message)),
                        ],
                      ),
                      Text(email,
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.blue),
                          textAlign: TextAlign.end),
                      const SizedBox(
                        height: 60,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Nome: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: name!,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Materie: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: area!,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Cod: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: code,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18)),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Status: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: status,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18)),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 90,
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                          ),
                          children: <TextSpan>[
                            const TextSpan(
                                text: 'Cabinet: ',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: room,
                                style: const TextStyle(
                                    fontFamily: 'Poppins', fontSize: 18)),
                          ],
                        ),
                      ),
                      const Text('acces cu harta',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              color: Colors.blue),
                          textAlign: TextAlign.end),
                    ],
                  ),
                )))
      ]),
    ));
  }
}
