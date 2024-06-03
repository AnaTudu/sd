import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'complains_page.dart';
import 'notification_service.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<Notifications> {
  late Future<List<Map<String, dynamic>>> _notificationsFuture;
  late String currentUserUid;
  late Future<String> _userTypeFuture;

  @override
  void initState() {
    super.initState();
    currentUserUid = FirebaseAuth.instance.currentUser!.uid;

    _notificationsFuture = LocalNotificationService.getNotificationsForAll();
    _userTypeFuture = getType();
  }

  IconData getIconForType(String type) {
    switch (type) {
      case 'event':
        return Icons.event;
      case 'forum':
        return Icons.people_alt_outlined;
      default:
        return Icons.notification_important;
    }
  }

  Future<String> getType() async {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserUid)
        .get();
    return userSnapshot.data()?['type'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Notificari',
            style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.black,
                fontWeight: FontWeight.w700)),
        bottomOpacity: 0.5,
        elevation: 0.5,
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.only(
            left: 20,
          ),
          child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 25,
              color: Color(
                  int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        toolbarHeight: 90,
        actions: [
          FutureBuilder<String>(
            future: _userTypeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('');
              } else if (snapshot.hasError) {
                return const Icon(
                  Icons.report,
                  color: Color.fromARGB(255, 249, 52, 72),
                );
              } else {
                final userType = snapshot.data ?? '';

                if (userType == 'admin') {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ComplaintsPage()),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 25.0),
                      child: Icon(
                        Icons.warning,
                        color: Colors.red,
                      ),
                    ),
                  );
                } else {
                  return const SizedBox.shrink();
                }
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text(''));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final notifications = snapshot.data ?? [];

            if (notifications.isEmpty) {
              return const Center(
                child: Text('Fara notificari',
                    style: TextStyle(fontFamily: 'Poppins')),
              );
            }

            return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: ListView.builder(
                  padding: const EdgeInsets.only(
                      top: 25, bottom: 25, right: 22.5, left: 22.5),
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    final title = notification['title'] ?? 'No Title';
                    final message = notification['body'] ?? 'No Message';
                    final type = notification['type'] ?? '';
                    final timestamp = notification['timestamp'] as Timestamp;

                    final timeSent = timestamp.toDate();

                    final icon = getIconForType(type);

                    return Padding(
                        padding: const EdgeInsets.only(top: 25),
                        child: ListTile(
                          leading: Icon(
                            icon,
                            size: 40,
                            color: Color(int.parse("#0097b2".substring(1, 7),
                                    radix: 16) +
                                0xFF000000),
                          ),
                          title: Text(
                            title,
                            style: const TextStyle(fontFamily: 'Poppins'),
                          ),
                          subtitle: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  message,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                              Text(
                                DateFormat.Hm().format(timeSent),
                                style: const TextStyle(
                                    color: Colors.grey, fontFamily: 'Poppins'),
                              ),
                            ],
                          ),
                        ));
                  },
                ));
          }
        },
      ),
    );
  }
}
