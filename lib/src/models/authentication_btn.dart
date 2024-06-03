import 'package:flutter/material.dart';

class AuthenticationBtn extends StatelessWidget {
  const AuthenticationBtn({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.function,
  });

  final String text;
  final Color backgroundColor;
  final Color foregroundColor;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 60,
          width: 300,
          child: TextButton(
            onPressed: function,
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0))),
              backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
              foregroundColor: WidgetStateProperty.all<Color>(foregroundColor),
            ),
            child: Text(text,
                style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 16)),
          ),
        ));
  }
}
