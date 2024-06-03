import 'package:flutter/material.dart';

class HomeChooseOptionBtn extends StatelessWidget {
  const HomeChooseOptionBtn({
    super.key,
    required this.text,
    required this.icon,
    required this.function,
  });

  final String text;
  final IconData icon;
  final Function()? function;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: ButtonStyle(
            fixedSize: WidgetStateProperty.all<Size>(const Size(140, 140)),
            foregroundColor: WidgetStateProperty.all<Color>(Color(
                int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000)),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: const BorderSide(color: Colors.grey, width: 0.25)))),
        onPressed: function,
        child: Container(
            margin: const EdgeInsets.only(
              top: 22.0,
            ),
            child: Column(
              children: [
                Icon(icon, size: 45),
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                ),
                Text(text,
                    style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        color: Color.fromARGB(255, 119, 119, 119))),
              ],
            )));
  }
}
