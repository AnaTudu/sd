import 'dart:ui';

class Event {
  const Event({
    required this.id,
    required this.date,
    required this.title,
    required this.description,
    required this.picture,
    required this.color,
  });

  final String id;
  final String date;
  final String title;
  final String description;
  final String picture;
  final Color color;
}
