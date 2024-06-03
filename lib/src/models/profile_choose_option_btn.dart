import 'package:flutter/material.dart';

class ProfileChooseOptionBtn extends StatelessWidget {
  const ProfileChooseOptionBtn({
    super.key,
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.function,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: function,
      style: ButtonStyle(
          fixedSize: WidgetStateProperty.all<Size>(const Size(300, 52.5)),
          foregroundColor: WidgetStateProperty.all<Color>(textColor),
          backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: const BorderSide(color: Colors.grey, width: 0.5)))),
      child: Text(text,
          style: const TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 14)),
    );
  }
}
