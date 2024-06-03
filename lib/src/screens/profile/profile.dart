import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:local_auth/local_auth.dart';
import 'package:bbbbbbbbbbbb/src/models/profile_choose_option_btn.dart';
import 'package:bbbbbbbbbbbb/src/screens/profile/purchases.dart';
import '../../../main.dart';
import 'edit.dart';
import 'calendar.dart';
import 'grades.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;
  // ignore: prefer_typing_uninitialized_variables
  var finalUrl;
  // ignore: unused_field
  bool _authenticated = false;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final userRef = FirebaseFirestore.instance.collection('users').doc(uid);
    final userData = await userRef.get();
    return userData;
  }

  Future<void> _authenticateFingerprint() async {
    final localAuth = LocalAuthentication();
    final isFingerprintAvailable = await localAuth.canCheckBiometrics;

    if (isFingerprintAvailable) {
      try {
        final isFingerprintVerified = await localAuth.authenticate(
          localizedReason: 'Verificați-vă amprenta pentru a accesa note.',
        );

        if (isFingerprintVerified) {
          setState(() {
            _authenticated = true;
          });
          // ignore: use_build_context_synchronously
          Navigator.push(
            // ignore: use_build_context_synchronously
            context,
            MaterialPageRoute(
                builder: (context) => const NotasDisciplinasPage()),
          );
        } else {
          _showFingerprintErrorDialog('Amprenta digitală nevalidă.');
        }
      } catch (e) {
        _showFingerprintErrorDialog(
            'Setați autentificarea cu amprentă digitală sau PIN pe dispozitiv pentru a accesa această funcție.');
      }
    } else {
      _showFingerprintUnavailableDialog();
    }
  }

  void _showFingerprintErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.warning,
              size: 50,
              color: Colors.blue,
            ),
          ),
          content: Text('\n$errorMessage\n\n'),
        );
      },
    );
  }

  void _showFingerprintUnavailableDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Padding(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.warning,
              size: 50,
              color: Colors.blue,
            ),
          ),
          content: Text(
              'Vă rugăm să activați autentificarea cu amprentă digitală în setările dispozitivului dvs.'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: getUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Ir buscar os dados
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Ocorreu um erro ao tentar ir buscar os dados
          return const Center(child: Text('Eroare la colectarea datelor'));
        } else {
          // Os dados foram obtidos com sucesso
          final userData = snapshot.data!;
          final name = userData.get('name');
          final number = userData.get('number');
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
                    child: Text('Eroare la obtinearea adresei imaginii'));
              } else {
                // A URL da imagem foi obtida com sucesso
                final imageUrl = snapshot.data;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 35.0,
                        left: 20.0,
                        right: 40.0,
                        bottom: 5.0,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(width: 35),
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: NetworkImage(imageUrl!),
                          ),
                          const SizedBox(width: 25),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                number,
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileChooseOptionBtn(
                              text: 'Editare',
                              textColor: Colors.white,
                              backgroundColor: Color(int.parse(
                                      "#0097b2".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              function: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              const EditProfilePage(),
                                      transitionDuration: Duration.zero,
                                      reverseTransitionDuration: Duration.zero,
                                    ));
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ), //substituir por padding/margin todos estes sizedbox
                            ProfileChooseOptionBtn(
                              text: 'Note',
                              textColor: Color(int.parse(
                                      "#0097b2".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              backgroundColor: Colors.white,
                              function: () {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  _authenticateFingerprint();
                                } else {
                                  _showFingerprintUnavailableDialog();
                                }
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ProfileChooseOptionBtn(
                              text: 'Orar',
                              textColor: Color(int.parse(
                                      "#0097b2".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              backgroundColor: Colors.white,
                              function: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Calendar()),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ProfileChooseOptionBtn(
                              text: 'Cumpraturi',
                              textColor: Color(int.parse(
                                      "#0097b2".substring(1, 7),
                                      radix: 16) +
                                  0xFF000000),
                              backgroundColor: Colors.white,
                              function: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (context, animation1, animation2) =>
                                            const Purchases(),
                                    transitionDuration: Duration.zero,
                                    reverseTransitionDuration: Duration.zero,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            ProfileChooseOptionBtn(
                              text: 'Logout',
                              textColor: Colors.white,
                              backgroundColor: Colors.red,
                              function: () async {
                                if (FirebaseAuth.instance.currentUser != null) {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(FirebaseAuth
                                          .instance.currentUser!.uid)
                                      .set({'fcmToken': ''},
                                          SetOptions(merge: true));
                                  FirebaseAuth.instance.signOut();
                                }
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Main()),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          );
        }
      },
    );
  }
}
