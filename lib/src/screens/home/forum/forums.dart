import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/forum.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/forum/forum_view/forum_post_card.dart';
import '../../../data/dataset.dart';
import 'forum_view/add_forum.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Forums extends StatefulWidget {
  const Forums({super.key});

  @override
  State<Forums> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<Forums> {
  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getForumList() async {
    final forumsRef = FirebaseFirestore.instance.collection('forums');
    final forums = await forumsRef.get();
    return forums.docs;
  }

  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = 'Press the button and start speaking';
  bool getFilter = false;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getForumList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(child: CircularProgressIndicator()));
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Eroare la încercarea de a colecta date'));
          } else {
            final forums = snapshot.data!;

            forumsDataset.clear();

            // ignore: unused_local_variable
            String? id = FirebaseAuth.instance.currentUser!.uid;

            for (var forum in forums) {
              final id = forum.id;
              final creator = forum.data()!['user'];
              int nlikes = forum['likes'].length;
              int ncomments = forum['comments'].length;
              final likes = forum.data()!['likes'];
              final title = forum.data()!['title'];
              final img = forum.data()!['img'];
              final tag = forum.data()!['tag'];
              final description = forum.data()!['description'];
              final commentsCollection =
                  forum.data()!['comments'] as List<dynamic>;

              List<Comment> comments = [];
              for (var comment in commentsCollection) {
                final creator = comment['user'].toString();
                final content = comment['comentario'].toString();
                comments.add(Comment(creator: creator, content: content));
              }

              IconData icon = Icons.thumb_up_off_alt;
              for (var a in likes) {
                if (a == FirebaseAuth.instance.currentUser?.uid) {
                  icon = Icons.thumb_up_alt;
                }
              }

              forumsDataset.add(Forum(
                  id: id,
                  tag: tag,
                  creator: creator,
                  creatorImg: img,
                  title: title,
                  description: description,
                  icon: icon,
                  nlikes: nlikes,
                  ncomments: ncomments,
                  comments: comments));
            }

            if (getFilter == true) {
              forumsDataset.retainWhere((element) => element.title == _text);
            }

            return Scaffold(
                appBar: AppBar(
                    title: const Text('Forum',
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    backgroundColor: Colors.white,
                    bottomOpacity: 0.5,
                    elevation: 0.5,
                    centerTitle: true,
                    leading: Container(
                      margin: const EdgeInsets.only(
                        left: 20.0,
                      ),
                      child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          iconSize: 25,
                          color: Color(
                              int.parse("#0097b2".substring(1, 7), radix: 16) +
                                  0xFF000000),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                    ),
                    toolbarHeight: 90,
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  const AddForum(),
                              transitionDuration: Duration.zero,
                              reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add_box_outlined,
                          color: Color(
                              int.parse("#0097b2".substring(1, 7), radix: 16) +
                                  0xFF000000),
                        ),
                      )
                    ]),
                body: NotificationListener<OverscrollIndicatorNotification>(
                    onNotification:
                        (OverscrollIndicatorNotification overscroll) {
                      overscroll.disallowIndicator();
                      return true;
                    },
                    child: Column(children: [
                      TextField(
                        decoration: InputDecoration(
                          hintText: _text,
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: _listen,
                        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
                      ),
                      TextButton(
                          onPressed: () {
                            setState(() {
                              getFilter = true;
                            });
                          },
                          child: const Text('Cautare')),
                      Expanded(
                        child: ListView.builder(
                          itemCount: forumsDataset.length,
                          padding: const EdgeInsets.only(bottom: 25, top: 25),
                          itemBuilder: (BuildContext context, int index) {
                            return ForumPostCard(forumsDataset[index],
                                forumsDataset[index].icon);
                          },
                        ),
                      )
                    ])));
          }
        });
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();

      if (available) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
            onResult: (val) => setState(() {
                  _text = val.recognizedWords;
                }));
      }
    } else {
      setState(() {
        _isListening = false;
      });
      _speech.stop();
    }
  }
}
