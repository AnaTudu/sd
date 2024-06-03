import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/notifications/notification_service.dart';

// ignore: must_be_immutable
class MessageTextField extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  String? fcmToken;
  MessageTextField(this.currentUserId, this.friendId, this.fcmToken,
      {super.key});

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  // ignore: prefer_final_fields
  TextEditingController _controller = TextEditingController();

  bool _isSendingNotification = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: "\t\t\tScrie mesajul tau",
              fillColor: Colors.grey[100],
              filled: true,
              border: OutlineInputBorder(
                borderSide: const BorderSide(width: 0, color: Colors.blue),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        GestureDetector(
          onTap: () async {
            if (!_isSendingNotification) {
              _isSendingNotification = true;

              String message = _controller.text;
              _controller.clear();
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.currentUserId)
                  .collection('messages')
                  .doc(widget.friendId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentUserId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .set({
                  'last_msg': message,
                });
              });

              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(widget.friendId)
                  .collection('messages')
                  .doc(widget.currentUserId)
                  .collection('chats')
                  .add({
                "senderId": widget.currentUserId,
                "receiverId": widget.friendId,
                "message": message,
                "type": "text",
                "date": DateTime.now(),
              }).then((value) {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.friendId)
                    .collection('messages')
                    .doc(widget.currentUserId)
                    .set({"last_msg": message});
              });

              // Check if the same message already exists in "notifications_user" collection
              final existingNotificationQuery = await FirebaseFirestore.instance
                  .collection('notifications_user')
                  .doc(widget.friendId)
                  .collection('notifications')
                  .where('message', isEqualTo: message)
                  .limit(1)
                  .get();

              if (existingNotificationQuery.docs.isEmpty) {
                String nameFriend = await getFriendName(widget.currentUserId);

                LocalNotificationService.sendNotificationToUser(
                    title: nameFriend,
                    message: message,
                    uid: widget.friendId,
                    type: 'message');
              }

              _isSendingNotification = false;
            }
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(
                  int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
            ),
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          ),
        )
      ]),
    );
  }
}

Future<String> getFriendName(String friendId) async {
  final friendSnapshot =
      await FirebaseFirestore.instance.collection('users').doc(friendId).get();
  return friendSnapshot['name'];
}
