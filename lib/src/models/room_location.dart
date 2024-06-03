class RoomLocation {
  const RoomLocation({
    required this.latitude,
    required this.longitude,
    required this.room,
    required this.school,
    required this.snippet,
  });

  final double latitude;
  final double longitude;
  final String room;
  final String school;
  final String snippet;
}
