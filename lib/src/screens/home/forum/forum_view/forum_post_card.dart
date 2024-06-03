import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:bbbbbbbbbbbb/src/models/forum.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/forum/forum_view/forum_page.dart';

class ForumPostCard extends StatefulWidget {
  const ForumPostCard(this.forumPost, this.iconNow, {super.key});

  final Forum forumPost;
  final IconData iconNow;

  @override
  State<ForumPostCard> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ForumPostCard> {
  late IconData iconYa;

  @override
  void initState() {
    super.initState();
    iconYa = widget.iconNow;
  }

  Future<void> enroll() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (iconYa == Icons.thumb_up_off_alt) {
      widget.forumPost.nlikes = widget.forumPost.nlikes + 1;
      FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.forumPost.id)
          .update({
        'likes': FieldValue.arrayUnion([uid]),
      });
    } else {
      widget.forumPost.nlikes = widget.forumPost.nlikes - 1;
      FirebaseFirestore.instance
          .collection('forums')
          .doc(widget.forumPost.id)
          .update({
        'likes': FieldValue.arrayRemove([uid]),
      });
    }
  }

  void complainPost(Forum forum) {
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final complainsRef = FirebaseFirestore.instance.collection('complains');

    complainsRef.add({
      'postId': forum.id,
      'userId': currentUserUid,
      'timestamp': DateTime.now(),
      'title': 'Postare pe forum',
      'description': 'Există o problemă cu această postare',
      'post title': forum.title,
      'post description': forum.description
    }).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post complained'),
          duration: Duration(seconds: 2),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to complain'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue,
                  radius: 20,
                  backgroundImage: NetworkImage(widget.forumPost.creatorImg),
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'creat de ${widget.forumPost.creator}',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                widget.forumPost.tag,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                widget.forumPost.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              margin: const EdgeInsets.only(left: 5),
              child: Text(
                widget.forumPost.description,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontFamily: 'Poppins',
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    enroll();
                    setState(() {
                      iconYa = iconYa == Icons.thumb_up_off_alt
                          ? Icons.thumb_up_alt
                          : Icons.thumb_up_off_alt;
                    });
                  },
                  icon: Icon(iconYa, size: 23),
                  label: Text('${widget.forumPost.nlikes}'),
                ),
                TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            ForumPostCardComments(widget.forumPost),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    ).then((value) => setState(() {}));
                  },
                  icon: const Icon(Icons.comment_outlined, size: 23),
                  label: Text('${widget.forumPost.ncomments}'),
                ),
                TextButton.icon(
                  onPressed: () async {
                    const url = 'www.unilink.com';
                    await Share.share(
                      '${widget.forumPost.title} by ${widget.forumPost.creator}\n\n$url',
                    );
                  },
                  icon: const Icon(Icons.share_outlined, size: 23),
                  label: const Text('Share'),
                ),
                TextButton.icon(
                  onPressed: () {
                    complainPost(widget.forumPost);
                  },
                  icon: const Icon(
                    Icons.report,
                    size: 23,
                    color: Colors.red,
                  ),
                  label: const Text(''),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
