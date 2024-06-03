import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/forum.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/forum/forum_view/forum_comment.dart';

import 'forum_page_card.dart';

class ForumPostCardComments extends StatefulWidget {
  const ForumPostCardComments(this.forumPost, {super.key});

  final Forum forumPost;

  @override
  State<ForumPostCardComments> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ForumPostCardComments> {
  final TextEditingController _emailController = TextEditingController();

  Future<void> enroll(String comment) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    var someData = {
      'comentariu': comment,
      'user': uid,
    };

    FirebaseFirestore.instance
        .collection('forums')
        .doc(widget.forumPost.id)
        .update({
      'comments': FieldValue.arrayUnion([someData]),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          title: Text(widget.forumPost.title,
              style: const TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
          backgroundColor: Colors.white,
          bottomOpacity: 0.5,
          centerTitle: true,
          toolbarHeight: 90,
          elevation: 0.5,
          leading: Container(
            margin: const EdgeInsets.only(
              left: 20.0,
            ),
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 25,
                color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                    0xFF000000),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
        ),
        body: Column(
          children: [
            ForumPostCard2(widget.forumPost, widget.forumPost.icon),
            const Divider(
              color: Colors.grey,
              height: 1,
            ),
            const Text(
              'Comentarii',
              style:
                  TextStyle(fontWeight: FontWeight.w700, fontFamily: 'Poppins'),
            ),
            Expanded(
              child: NotificationListener<OverscrollIndicatorNotification>(
                  onNotification: (OverscrollIndicatorNotification overscroll) {
                    overscroll.disallowIndicator();
                    return true;
                  },
                  child: ListView.builder(
                    itemCount: widget.forumPost.comments.length,
                    padding: const EdgeInsets.only(bottom: 25, top: 25),
                    itemBuilder: (BuildContext context, int index) {
                      return ForumCommentCard(
                          comment: widget.forumPost.comments[index]);
                    },
                  )),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // ignore: sized_box_for_whitespace
                Container(
                  width: 345,
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      hintText: 'Adauga comentariu',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontFamily: 'Poppins'),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    enroll(_emailController.text);
                    setState(() {
                      final uid = FirebaseAuth.instance.currentUser?.uid;
                      widget.forumPost.comments.add(Comment(
                          content: _emailController.text, creator: uid!));
                      widget.forumPost.ncomments++;
                    });
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ],
        ));
  }
}
