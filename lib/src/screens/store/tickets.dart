import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart' show QrImageView, QrVersions;

class Tickets extends StatelessWidget {
  const Tickets({super.key});

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

class _MyWidgetState extends State<MyWidget> {
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

  void buyTicket() {
    if (currentMoney >= 2) {
      setState(() {
        currentMoney -= 2;
        rng = Random().nextInt(1000000);
        saveTicketToFirestore();
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
                Navigator.pop(context); // Fechar o diálogo
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> saveTicketToFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final Map<String, dynamic> ticketData = {
        'codigo': rng.toString(),
        'data': DateTime.now(),
        'user': user.uid,
        'type': 'Senha',
      };
      await FirebaseFirestore.instance.collection('tickets').add(ticketData);
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
          'Senhas',
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
          height: 20,
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
              child: const Text(
                '2€',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
            ),
            TextButton(
              onPressed: buyTicket,
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
