import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/chat_screen.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/search_page.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserListPageState createState() => _UserListPageState();
}

class _UserListPageState extends State<Chat> {
  // ignore: unused_field
  late Future<QuerySnapshot<Map<String, dynamic>>> _usersFuture;

  @override
  void initState() {
    super.initState();
    _usersFuture = _fetchUsers();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _fetchUsers() async {
    final usersSnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    return usersSnapshot;
  }

  Future<String?> getImageUrl(String imagePath) async {
    final ref =
        FirebaseStorage.instance.ref().child('ProfileImages/$imagePath');
    final url = await ref.getDownloadURL();
    return url.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Chat',
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
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              icon: const Icon(Icons.search, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        const SearchPage(),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser?.uid ?? '')
            .collection('messages')
            .snapshots(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length < 1) {
              return const Center(
                  child: Text('Încă nu ai conversații',
                      style: TextStyle(fontFamily: 'Poppins')));
            }
            return NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowIndicator();
                  return true;
                },
                child: Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        // ignore: unused_local_variable
                        final userData = snapshot.data.docs[index].data();

                        final currentUser =
                            FirebaseAuth.instance.currentUser?.uid ?? '';

                        var friendId = snapshot.data.docs[index].id;
                        var lastMsg = snapshot.data.docs[index]['last_msg'];

                        return FutureBuilder(
                          future: FirebaseFirestore.instance
                              .collection('users')
                              .doc(friendId)
                              .get(),
                          builder: (context, AsyncSnapshot asyncSnapshot) {
                            if (asyncSnapshot.hasData) {
                              var friend = asyncSnapshot.data;
                              String fcmToken = '';
                              try {
                                fcmToken = friend['fcmToken'];
                              } catch (e) {
                                fcmToken = '';
                              }

                              return Column(
                                children: [
                                  ListTile(
                                    contentPadding: const EdgeInsets.only(
                                        top: 15,
                                        left: 25,
                                        right: 25,
                                        bottom: 15),
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: FutureBuilder(
                                        future: getImageUrl(friend['photo']),
                                        builder: (context,
                                            AsyncSnapshot<String?>
                                                asyncSnapshot) {
                                          if (asyncSnapshot.hasData) {
                                            return CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                  asyncSnapshot.data!),
                                              radius: 30,
                                            );
                                          }
                                          return const CircularProgressIndicator();
                                        },
                                      ),
                                    ),
                                    title: Text(
                                      friend['name'],
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                    // ignore: avoid_unnecessary_containers
                                    subtitle: Container(
                                      child: Text(
                                        "$lastMsg",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontFamily: 'Poppins',
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            currentUserId: currentUser,
                                            friendId: friend['id'],
                                            friendImage: friend['photo'],
                                            friendName: friend['name'],
                                            fcmToken: fcmToken,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            }
                            return const LinearProgressIndicator();
                          },
                        );
                      },
                    )));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
