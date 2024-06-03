import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../start.dart';

class Registration extends StatelessWidget {
  Registration({super.key});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _studentNumberController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.black,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50.5),
            Image.asset(
              "assets/images/unitips.png",
              height: 70,
              width: 1000,
              fit: BoxFit.fitHeight,
            ),
            const SizedBox(height: 35),
            AuthenticationTextField(
              controller: _nameController,
              hintText: 'Nome',
            ),
            AuthenticationTextField(
              controller: _emailController,
              hintText: 'E-mail',
            ),
            AuthenticationTextField(
              controller: _passwordController,
              hintText: 'Password',
              isPassword: true,
            ),
            AuthenticationTextField(
              controller: _confirmPasswordController,
              hintText: 'Confirmare password',
              isPassword: true,
            ),
            AuthenticationTextField(
              controller: _studentNumberController,
              hintText: 'Numarul elevului',
            ),
            const SizedBox(height: 30),
            AuthenticationBtn(
                text: 'Creati cont',
                backgroundColor: Color(
                    int.parse("#0097b2".substring(1, 7), radix: 16) +
                        0xFF000000),
                foregroundColor: Colors.white,
                function: () {
                  if (_passwordController.text.length < 6) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.warning,
                                size: 50,
                                color: Color(int.parse(
                                        "#0097b2".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                              )),
                          content: const Text(
                              '\nParola trebuie să aibă 6 lungime!\n\n')),
                    );
                  } else if (_nameController.text.length > 15) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.warning,
                                size: 50,
                                color: Color(int.parse(
                                        "#0097b2".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                              )),
                          content: const Text('\nNome max 15 length!\n\n')),
                    );
                  } else if (_nameController.text != '' &&
                      _emailController.text != '' &&
                      _passwordController.text != '' &&
                      _confirmPasswordController.text != '' &&
                      _studentNumberController.text != '') {
                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: _emailController.text,
                            password: _passwordController.text)
                        .then((value) {
                      FirebaseFirestore.instance
                          .collection('users')
                          .doc(value.user?.uid)
                          .set({
                        'name': _nameController.text,
                        'number': _studentNumberController.text,
                        'photo': 'default.png',
                        'money': 0,
                        'id': value.user?.uid,
                        'type': 'normal'
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Start()));
                    });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                          title: Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.warning,
                                size: 50,
                                color: Color(int.parse(
                                        "#0097b2".substring(1, 7),
                                        radix: 16) +
                                    0xFF000000),
                              )),
                          content: const Text(
                              '\nCompletați câmpurile necesare!\n\n')),
                    );
                  }
                })
          ],
        ));
  }
}
