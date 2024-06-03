import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/data/dataset.dart';
import 'package:bbbbbbbbbbbb/src/models/room_location.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/map/destination.dart';
import '../../../../main.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<StatefulWidget> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  Future<List<DocumentSnapshot<Map<String, dynamic>>>> getRoomsList() async {
    final locationsRef = FirebaseFirestore.instance.collection('locations');
    final locations = await locationsRef.get();
    return locations.docs;
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(milliseconds: 2000), () {});
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const Main()));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DocumentSnapshot<Map<String, dynamic>>>>(
        future: getRoomsList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xff0f0e0e),
                ),
                child: Center(
                  child: SizedBox(
                    child: Image.asset(
                      height: 110,
                      width: 1000,
                      "assets/images/unitips.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Eroare la colectarea datelor'));
          } else {
            final roomsData = snapshot.data!;

            roomsDataset.clear();

            for (var roomData in roomsData) {
              double latitude = roomData.data()!['latitude'];
              double longitude = roomData.data()!['longitude'];
              String room = roomData.data()!['room'];
              String school = roomData.data()!['school'];
              String snippet = roomData.data()!['snippet'];

              roomsDataset.add(RoomLocation(
                  latitude: latitude,
                  longitude: longitude,
                  room: room,
                  school: school,
                  snippet: snippet));
            }

            for (RoomLocation roomDataset in roomsDataset) {
              rooms.add(roomDataset.room);
            }

            debugPrint(rooms.toString());

            return Scaffold(
              body: Container(
                padding: const EdgeInsets.all(10),
                width: double.infinity,
                height: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Center(
                  child: SizedBox(
                    child: Image.asset(
                      height: double.infinity,
                      width: double.infinity,
                      "assets/images/splash.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            );
          }
        });
  }
}
