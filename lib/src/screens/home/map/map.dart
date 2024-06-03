import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' show cos, sqrt, asin;

import '../../../models/room_location.dart';

class HomeMap extends StatefulWidget {
  const HomeMap(this.room, {super.key});

  final RoomLocation room;

  @override
  State<HomeMap> createState() => _HomeMapState();
}

class _HomeMapState extends State<HomeMap> {
  final Completer<GoogleMapController> controllerCompleter =
      Completer<GoogleMapController>();
  MapType _mapType = MapType.hybrid;
  // ignore: unused_field
  LatLng? _lastMapPosition;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  void _changeMapType() {
    setState(() {
      _mapType = _mapType == MapType.hybrid ? MapType.normal : MapType.hybrid;
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  late Position position2;

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    position2 = position;
  }

  bool _isPermissionRequestInProgress = false;

  Future<void> _requestPermission() async {
    if (_isPermissionRequestInProgress) {
      return;
    }

    _isPermissionRequestInProgress = true;

    var permissionStatus = await Permission.location.request();

    if (permissionStatus.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      position2 = position;
    }

    _isPermissionRequestInProgress = false;
  }

  Future<void> _goToLocation(double lat, double long) async {
    double zoom = 18;
    GoogleMapController controller = await controllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, long), zoom),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: getLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          String errorMessage = 'Eroare la colectarea datelor';
          if (snapshot.error is PermissionDeniedException) {
            errorMessage = 'Accesul la locație a fost interzis de utilizator.';
          }
          return Scaffold(
            body: Center(
              child: Text(errorMessage),
            ),
          );
        } else {
          CameraPosition initialCameraPosition = CameraPosition(
            target: LatLng(widget.room.latitude, widget.room.longitude),
            zoom: 18,
          );
          late String distanceTxt;
          late String timeTxt;

          // ignore: unnecessary_null_comparison
          if (position2 != null) {
            var p2 = 0.017453292519943295; // Math.PI / 180
            var c2 = cos;
            var a2 = 0.5 -
                c2((position2.latitude - widget.room.latitude) * p2) / 2 +
                c2(widget.room.latitude * p2) *
                    c2(position2.latitude * p2) *
                    (1 -
                        c2((position2.longitude - widget.room.longitude) *
                            p2)) /
                    2;

            var distance = 12742 * asin(sqrt(a2));

            timeTxt = '${(distance * 12).toStringAsFixed(0)} minuto(s)';

            if (distance < 1) {
              distanceTxt = '${(distance * 1000).toStringAsFixed(2)} metros';
            } else {
              distanceTxt = '${(distance).toStringAsFixed(2)} km';
            }
          } else {
            distanceTxt = 'Fără acces la locație';
            timeTxt = 'Fără acces la locație';
          }

          return Scaffold(
            body: Stack(
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 40),
                      alignment: Alignment.topCenter,
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'inapoi',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Mapa',
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${widget.room.school}: Bloco ${widget.room.room[0]}, Piso ${widget.room.room[1]}, Sala ${widget.room.room}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                Container(
                  margin: const EdgeInsets.only(top: 225),
                  child: GoogleMap(
                    myLocationEnabled: true,
                    markers: <Marker>{
                      Marker(
                        markerId: MarkerId(widget.room.room),
                        position:
                            LatLng(widget.room.latitude, widget.room.longitude),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueRed),
                        infoWindow: InfoWindow(
                          title: widget.room.room,
                          snippet: widget.room.snippet,
                        ),
                      ),
                    },
                    myLocationButtonEnabled: true,
                    mapToolbarEnabled: true,
                    onCameraMove: _onCameraMove,
                    trafficEnabled: true,
                    mapType: _mapType,
                    onMapCreated: (GoogleMapController controller) {
                      try {
                        controllerCompleter.complete(controller);
                        // ignore: empty_catches
                      } catch (ex) {}
                    },
                    initialCameraPosition: initialCameraPosition,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 300, right: 10),
                  alignment: Alignment.centerRight,
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: FloatingActionButton(
                          backgroundColor: Colors.blue.withOpacity(0.75),
                          onPressed: () {
                            _changeMapType();
                          },
                          child: const Icon(Icons.map),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: FloatingActionButton(
                          backgroundColor: Colors.pink.withOpacity(0.75),
                          onPressed: () {
                            _goToLocation(
                                widget.room.latitude, widget.room.longitude);
                          },
                          child: const Icon(Icons.location_pin),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: FloatingActionButton(
                          backgroundColor: Colors.green.withOpacity(0.75),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Padding(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Icon(
                                    Icons.nordic_walking,
                                    size: 50,
                                    color: Colors.blue,
                                  ),
                                ),
                                content: Container(
                                  width: 100,
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: Text(
                                    '\nDistância: \t\t\t$distanceTxt\nTempo: \t\t\t\t\t\t\t\t$timeTxt',
                                    style: const TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Icon(Icons.directions),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
