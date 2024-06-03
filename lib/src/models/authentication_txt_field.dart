import 'package:flutter/material.dart';

class AuthenticationTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const AuthenticationTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AuthenticationTextFieldState createState() =>
      _AuthenticationTextFieldState();
}

class _AuthenticationTextFieldState extends State<AuthenticationTextField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        width: 300,
        child: TextField(
          controller: widget.controller,
          obscureText: !showPassword && widget.isPassword,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.grey,
            ),
            filled: true,
            fillColor: Colors.white,
            suffixIcon: widget.isPassword
                ? GestureDetector(
                    onLongPress: () => setState(() => showPassword = true),
                    onLongPressUp: () => setState(() => showPassword = false),
                    child: Icon(
                      showPassword ? Icons.visibility : Icons.visibility_off,
                      color: Color(
                          int.parse("#0097b2".substring(1, 7), radix: 16) +
                              0xFF000000),
                    ),
                  )
                : null,
          ),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
            fontFamily: 'Poppins',
          ),
        ),
      ),
    );
  }
}
