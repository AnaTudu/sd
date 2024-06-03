import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../../../../models/authentication_btn.dart';

class AddForum extends StatelessWidget {
  const AddForum({super.key});

  @override
  Widget build(BuildContext context) {
    return const StatefulDestination();
  }
}

class StatefulDestination extends StatefulWidget {
  const StatefulDestination({super.key});

  @override
  State<StatefulDestination> createState() => _DestinationState();
}

class _DestinationState extends State<StatefulDestination> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _emailController2 = TextEditingController();

  // Initial Selected Value
  String dropdownvalue = 'Fără etichetă';

  // List of items in our dropdown menu
  var items = [
    'Fără etichetă',
    'Q&A',
    'Pierdute/Gasite',
    'Examene',
  ];

  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userData = await userRef.get();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Ir buscar os dados
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            // Ocorreu um erro ao tentar ir buscar os dados
            return const Scaffold(
                body: Center(child: Text('Eroare la colecatrea datelor')));
          } else {
            // Os dados foram obtidos com sucesso
            final userData = snapshot.data!;
            final name = userData.get('name');
            final photo = userData.get('photo');

            Future<String?> getImageUrl(String imagePath) async {
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('ProfileImages/$imagePath');
              final url = await ref.getDownloadURL();
              return url;
            }

            return FutureBuilder<String?>(
                future: getImageUrl(photo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Encontrar o URL da imagem
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Ocorreu um erro ao obter a URL da imagem
                    return const Center(
                        child: Text('Eroare la obtinerea URL a imaginii'));
                  } else {
                    // A URL da imagem foi obtido com sucesso
                    final imageUrl = snapshot.data;
                    return Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: Center(
                            child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(top: 80),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'inapoi',
                                  style: TextStyle(
                                    color: Color(int.parse(
                                            "#0097b2".substring(1, 7),
                                            radix: 16) +
                                        0xFF000000),
                                    fontSize: 20,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              )),
                          const Text(
                            'Forum',
                            style: TextStyle(
                                fontSize: 40,
                                fontFamily: 'Poppins',
                                color: Colors.black,
                                fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(
                            height: 50,
                          ),

                          Container(
                              width: 280,
                              margin: const EdgeInsets.only(
                                  bottom: 15, right: 65, left: 65),
                              child: DropdownButton(
                                value: dropdownvalue,
                                icon: const Icon(Icons.arrow_downward,
                                    size: 15, color: Colors.grey),
                                style: TextStyle(
                                  color: Color(int.parse(
                                          "#0097b2".substring(1, 7),
                                          radix: 16) +
                                      0xFF000000),
                                  fontFamily: 'Poppins',
                                ),
                                underline: Container(
                                  height: 1.5,
                                  color:
                                      const Color.fromARGB(255, 209, 209, 209),
                                ),
                                isExpanded: true,
                                items: items.map((String items) {
                                  return DropdownMenuItem(
                                    value: items,
                                    child: Text(items),
                                  );
                                }).toList(),
                                // After selecting the desired option,it will
                                // change button value to selected value
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownvalue = newValue!;
                                  });
                                },
                              )),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            child: TextField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: 'Titlu',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          // ignore: sized_box_for_whitespace
                          Container(
                            width: 300,
                            child: TextField(
                              keyboardType: TextInputType.multiline,
                              maxLines: 6,
                              controller: _emailController2,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                hintText: 'Descriere',
                                hintStyle: const TextStyle(
                                  color: Colors.grey,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          AuthenticationBtn(
                              text: 'Adauga',
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              function: () {
                                var myData = {
                                  'likes': [],
                                  'comments': [],
                                  'description': _emailController2.text,
                                  'title': _emailController.text,
                                  'tag': dropdownvalue,
                                  'user': name,
                                  'img': imageUrl
                                };

                                var collection = FirebaseFirestore.instance
                                    .collection('forums');
                                collection.add(myData);
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                      title: const Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Icon(
                                            Icons.add,
                                            size: 50,
                                            color: Colors.blue,
                                          )),
                                      content: Container(
                                          width: 100,
                                          height: 100,
                                          alignment: Alignment.center,
                                          child: const Text(
                                              '\nForum adaugat cu succes!\n'))),
                                );
                                //.catchError((error) => print('Add failed: $error'));
                              }),
                        ])));
                  }
                });
          }
        });
  }
}
