import 'package:flutter/material.dart';
import '../../../data/dataset.dart';
import '../../../models/destination_choose_box.dart';
import 'map.dart';

List<String> filter = [];
List<String> copy = [];
List<String> rooms = [];

class Destination extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Destination({Key? key});

  @override
  Widget build(BuildContext context) {
    return const StatefulDestination();
  }
}

class StatefulDestination extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const StatefulDestination({Key? key});

  @override
  State<StatefulWidget> createState() => _DestinationState();
}

class _DestinationState extends State<StatefulDestination> {
  String? school;
  String? block;
  String? floor;
  String? room;
  bool notDone = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Center(
                child: ListView(children: [
              Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: TextButton(
                      onPressed: () {
                        filter.clear();
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'inapoi',
                        style: TextStyle(
                          color: Color(0xFF0097b2),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                        ),
                      ))),
              Container(
                  margin: const EdgeInsets.only(top: 50, bottom: 40),
                  child: const Text(
                    'Destinatie',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 40),
                  )),
              DestinationChooseBox('Selectati cladirea', school, schools,
                  (String? value) {
                setState(() {
                  debugPrint(rooms.toString());
                  school = value!;
                  block = null;
                  floor = null;
                  room = null;
                  filter.clear();
                });
              }),
              DestinationChooseBox('Selecione o etajul', block, blocks,
                  (String? value) {
                setState(() {
                  block = value!;
                  floor = null;
                  room = null;

                  filter.clear();
                  filter.addAll(rooms);
                  filter.retainWhere((room) {
                    return room[0] == block?[6];
                  });
                  copy.clear();
                  copy.addAll(filter);
                });
              }),
              DestinationChooseBox('Selecione ', floor, floors,
                  (String? value) {
                setState(() {
                  floor = value!;
                  room = null;

                  filter.clear();
                  filter.addAll(copy);
                  filter.retainWhere((room) {
                    return room[1] == floor?[5];
                  });

                  if (filter.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                          title: Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Icon(
                                Icons.warning,
                                size: 50,
                                color: Colors.blue,
                              )),
                          content: Text('\nNici un rezultat gasit!\n\n')),
                    );
                  } else {
                    notDone = false;
                  }
                });
              }),
              IgnorePointer(
                ignoring: notDone,
                child: DestinationChooseBox('Selectati sala', room, filter,
                    (String? value) {
                  setState(() {
                    room = value!;
                  });
                }),
              ),
              Container(
                height: 60,
                margin: const EdgeInsets.only(left: 60, right: 60, top: 40),
                child: TextButton(
                  onPressed: () {
                    if (school == null ||
                        block == null ||
                        floor == null ||
                        room == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                            title: Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Icon(
                                  Icons.warning,
                                  size: 50,
                                  color: Colors.blue,
                                )),
                            content:
                                Text('\nCompletați câmpurile necesare!\n\n')),
                      );
                    } else {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              HomeMap(roomsDataset.firstWhere(
                                  (element) => element.room == room!)),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      );
                    }
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(const Color(0xFF0097b2)),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ))),
                  child: const Text('Continua',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 15)),
                ),
              ),
            ]))));
  }
}
