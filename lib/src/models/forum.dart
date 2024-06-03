import 'package:flutter/cupertino.dart';

class Comment {
  const Comment({
    required this.creator,
    required this.content,
  });

  final String creator;
  final String content;
}

class Forum {
  Forum({
    required this.id,
    required this.tag,
    required this.creator,
    required this.creatorImg,
    required this.title,
    required this.description,
    required this.comments,
    required this.icon,
    required this.nlikes,
    required this.ncomments,
  });

  final String id;
  String tag;
  final String creator;
  final String title;
  final String creatorImg;
  final String description;
  List<Comment> comments;
  final IconData icon;
  int nlikes;
  int ncomments;
}
