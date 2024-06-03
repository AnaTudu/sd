import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/chat_widgets.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/single_message.dart';

// ignore: must_be_immutable
class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String friendId;
  final String friendName;
  final String friendImage;
  String? fcmToken;

  ChatScreen({
    super.key,
    required this.currentUserId,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
    this.fcmToken,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late Future<String?> _friendImageUrl;

  @override
  void initState() {
    super.initState();
    _friendImageUrl = getImageUrl(widget.friendImage);
  }

  Future<String?> getImageUrl(String imagePath) async {
    final ref =
        FirebaseStorage.instance.ref().child('ProfileImages/$imagePath');
    final url = await ref.getDownloadURL();
    return url;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.5,
        elevation: 0.5,
        centerTitle: true,
        toolbarHeight: 90,
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
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(80),
              child: FutureBuilder<String?>(
                future: _friendImageUrl,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // ignore: sized_box_for_whitespace
                    return Container(
                      width: 45,
                      height: 45,
                      child: Image.network(
                        snapshot.data!,
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return Container(
                      width: 35,
                      height: 35,
                      color: Colors.grey, // Placeholder color
                    );
                  }
                },
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              widget.friendName,
              style: const TextStyle(
                  fontSize: 20, fontFamily: 'Poppings', color: Colors.black),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("users")
                    .doc(widget.currentUserId)
                    .collection('messages')
                    .doc(widget.friendId)
                    .collection('chats')
                    .orderBy("date", descending: true)
                    .snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length < 1) {
                      return const Center(
                        child: Text("Spune ceva!"),
                      );
                    }
                    return ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        bool isMe = snapshot.data.docs[index]['senderId'] ==
                            widget.currentUserId;
                        return SingleMessage(
                          message: snapshot.data.docs[index]['message'],
                          isMe: isMe,
                        );
                      },
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          MessageTextField(
              widget.currentUserId, widget.friendId, widget.fcmToken),
        ],
      ),
    );
  }
}
