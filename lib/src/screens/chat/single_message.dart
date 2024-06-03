import 'package:flutter/material.dart';

class SingleMessage extends StatelessWidget {
  final String message;
  final bool isMe;

  const SingleMessage({super.key, required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 15),
          margin:
              const EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          constraints: const BoxConstraints(maxWidth: 200),
          decoration: BoxDecoration(
              color: isMe
                  ? Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                      0xFF000000)
                  : Colors.black,
              borderRadius: const BorderRadius.all(Radius.circular(12))),
          child: Text(message,
              style: const TextStyle(
                  color: Colors.white, fontSize: 18, fontFamily: 'Poppins')),
        ),
      ],
    );
  }
}
