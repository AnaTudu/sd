import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/forum.dart';

class ForumCommentCard extends StatefulWidget {
  const ForumCommentCard({
    super.key,
    required this.comment,
  });

  final Comment comment;

  @override
  State<ForumCommentCard> createState() => _ForumCommentCardState();
}

class _ForumCommentCardState extends State<ForumCommentCard> {
  // ignore: prefer_typing_uninitialized_variables
  var imageUrl;

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData() async {
    final userRef = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.comment.creator);
    final userData = await userRef.get();
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Ir buscar os dados
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Ocorreu um erro ao tentar ir buscar os dados
            return const Center(child: Text('Eroare la colectarea de date'));
          } else {
            // Os dados foram obtidos com sucesso
            final userData = snapshot.data!;
            final name = userData.get('name');
            final photo = userData.get('photo');

            Future<String?> getImageUrl(String imagePath) async {
              final ref = FirebaseStorage.instance
                  .ref()
                  .child('ProfileImages/$imagePath');
              final url = await ref.getDownloadURL();
              return url;
            }

            return FutureBuilder<String?>(
                future: getImageUrl(photo),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    // Encontrar o URL da imagem
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Ocorreu um erro ao obter a URL da imagem
                    return const Center(
                        child: Text('Eroare la obtinerea URL a imaginii'));
                  } else {
                    // A URL da imagem foi obtido com sucesso
                    final imageUrl = snapshot.data;
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 10, left: 25, right: 25, bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.blue,
                                backgroundImage: NetworkImage(imageUrl!),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(name,
                                  style: const TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w700)),
                              Container(
                                  margin: const EdgeInsets.only(left: 5),
                                  child: Flexible(
                                    child: Text(widget.comment.content,
                                        textAlign: TextAlign.justify,
                                        softWrap: true,
                                        style: const TextStyle(
                                            fontFamily: 'Poppins')),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                });
          }
        });
  }
}
