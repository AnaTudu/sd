import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/models/forum.dart';

class ForumPostCard2 extends StatefulWidget {
  const ForumPostCard2(this.forumPost, this.iconNow, {super.key});

  final Forum forumPost;
  final IconData iconNow;

  @override
  State<ForumPostCard2> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ForumPostCard2> {
  late IconData iconYa;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 5, left: 0, right: 15, bottom: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width,
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
                  Text('creat de ${widget.forumPost.creator}',
                      style:
                          const TextStyle(fontFamily: 'Poppins', fontSize: 12)),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.forumPost.title,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Colors.black),
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
                        color: Colors.black),
                  )),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ));
  }
}
