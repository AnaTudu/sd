import 'package:flutter/material.dart';

class SettingsListItem extends StatelessWidget {
  const SettingsListItem(
      {super.key, required this.icon, required this.name, required this.page});

  final IconData icon;
  final String name;
  final StatelessWidget page;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 100,
        child: ListTile(
          leading: Icon(
            icon,
            size: 30,
          ),
          splashColor: Colors.transparent,
          title: Text(name,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 20)),
          iconColor: Color(
              int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          onTap: () {
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    Scaffold(body: page),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
        ));
  }
}
