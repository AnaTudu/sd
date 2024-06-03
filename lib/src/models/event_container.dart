import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'event.dart';
import 'event_detail_page.dart';

// ignore: must_be_immutable
class EventsContainer extends StatefulWidget {
  EventsContainer(this.event, this.color, {super.key});

  final Event event;
  Color color;

  @override
  State<EventsContainer> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<EventsContainer> {
  late Color color;

  @override
  void initState() {
    super.initState();
    color = widget.color;
  }

  Future<void> enroll() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (color == Colors.white) {
      FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
        'enrolled': FieldValue.arrayUnion([uid]),
      });
    } else {
      FirebaseFirestore.instance
          .collection('events')
          .doc(widget.event.id)
          .update({
        'enrolled': FieldValue.arrayRemove([uid]),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
              color: Color.fromARGB(255, 226, 226, 226), spreadRadius: 1.5)
        ],
      ),
      margin: const EdgeInsets.only(bottom: 20),
      height: 200,
      width: 400,
      child: Row(
        children: [
          Expanded(
            // Wrap Row with Expanded
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2) =>
                        EventDetailPage(widget.event),
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                  ),
                );
              },
              child: Image.network(
                widget.event.picture,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Text(widget.event.date,
                    style: const TextStyle(
                        color: Colors.grey, fontFamily: 'Poppins')),
                Text(widget.event.title,
                    style: TextStyle(
                        color: Color(
                            int.parse("#0097b2".substring(1, 7), radix: 16) +
                                0xFF000000),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Poppins')),
                Text(widget.event.description,
                    style:
                        const TextStyle(fontSize: 12, fontFamily: 'Poppins')),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () {
                    enroll();
                    setState(() {
                      color =
                          color == Colors.white ? Colors.yellow : Colors.white;
                    });
                  },
                  style: ButtonStyle(
                      fixedSize:
                          WidgetStateProperty.all<Size>(const Size(170, 50)),
                      foregroundColor:
                          WidgetStateProperty.all<Color>(Colors.white),
                      backgroundColor: WidgetStateProperty.all<Color>(Color(
                          int.parse("#0097b2".substring(1, 7), radix: 16) +
                              0xFF000000)),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                              side: const BorderSide(
                                  color: Colors.grey, width: 0.5)))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.star,
                          size: 20,
                          color: color,
                        ),
                      ),
                      const Text('Tenho interesse',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w700,
                              fontSize: 13)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
