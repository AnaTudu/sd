import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/settings/privacy.dart';
import 'package:bbbbbbbbbbbb/src/screens/settings/terms.dart';
import '../../models/settings_list_item.dart';
import 'about.dart';
import 'notifications.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.only(top: 75, left: 40),
          children: const [
            SettingsListItem(
                icon: Icons.list_alt_outlined,
                name: 'Termeni si servicii',
                page: Termos()),
            SettingsListItem(
                icon: Icons.privacy_tip_outlined,
                name: 'Confidentialitate',
                page: Privacidade()),
            SettingsListItem(
                icon: Icons.notifications_none_rounded,
                name: 'Notificari',
                page: Notifications()),
            SettingsListItem(
                icon: Icons.info_outline, name: 'Despre', page: About()),
          ],
        ));
  }
}
