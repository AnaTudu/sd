import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart' show QrImageView, QrVersions;

class Academic extends StatefulWidget {
  const Academic({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AcademicState createState() => _AcademicState();
}

class _AcademicState extends State<Academic> {
  var rng = Random().nextInt(1000000);
  late int currentMoney = 0;

  @override
  void initState() {
    super.initState();
    getUserMoney();
  }

  Future<void> getUserMoney() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final Map<String, dynamic>? userData =
          userSnapshot.data() as Map<String, dynamic>?;
      currentMoney = userData?['money'] ?? 0;
      setState(() {});
    }
  }

  void buyItem() {
    if (currentMoney >= 200) {
      setState(() {
        currentMoney -= 200;
        rng = Random().nextInt(1000000);
        saveItemToFirestore();
        updateMoneyInFirestore();
      });
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Padding(
            padding: EdgeInsets.only(top: 10),
            child: Icon(
              Icons.warning,
              size: 50,
              color: Colors.blue,
            ),
          ),
          content: const Text('\nNão tem saldo suficiente.\n\n'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> saveItemToFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final Map<String, dynamic> itemData = {
        'codigo': rng.toString(),
        'data': DateTime.now(),
        'user': user.uid,
        'type': 'Traje'
      };
      await FirebaseFirestore.instance.collection('tickets').add(itemData);
    }
  }

  Future<void> updateMoneyInFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'money': currentMoney});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Trajes',
          style: TextStyle(
              fontSize: 35, fontFamily: 'Poppins', fontWeight: FontWeight.w700),
        ),
        Text(
          'Saldo: $currentMoney€',
          style: const TextStyle(
            fontSize: 20,
            fontFamily: 'Poppins',
          ),
        ),
        const SizedBox(
          height: 40,
        ),
        Center(
          child: QrImageView(
            data: '$rng',
            version: QrVersions.auto,
            size: 200,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.only(right: 60),
              child:
                  const Text('200€', style: TextStyle(fontFamily: 'Poppins')),
            ),
            TextButton(
              onPressed: buyItem,
              child: Text(
                'Comprar',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                      0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
