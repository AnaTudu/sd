import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:qr_flutter/qr_flutter.dart' show QrImageView, QrVersions;

class QRCodePage extends StatefulWidget {
  final String label;
  final DateTime date;

  const QRCodePage({
    super.key,
    required this.label,
    required this.date,
  });

  @override
  // ignore: library_private_types_in_public_api
  _QRCodePageState createState() => _QRCodePageState();
}

class _QRCodePageState extends State<QRCodePage> {
  bool qrcodeActive = true;

  void deactivateQRCode(String label) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('cod', isEqualTo: label)
        .get();

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    deactivateQRCode(widget.label);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottomOpacity: 0.6,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          iconSize: 25,
          color: Color(
              int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
          onPressed: () async {
            deactivateQRCode(widget.label);
            Navigator.of(context).pop();
          },
        ),
        toolbarHeight: 90,
        title: const Text(
          'QR Code',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (qrcodeActive)
              QrImageView(
                data: widget.label,
                version: QrVersions.auto,
                size: 200,
              )
            else
              Container(),
            const SizedBox(height: 16),
            Text(
              DateFormat('dd/MM/yyyy').format(widget.date.toUtc()),
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class Purchases extends StatefulWidget {
  const Purchases({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PurchasesState createState() => _PurchasesState();
}

class _PurchasesState extends State<Purchases> {
  bool isExpanded = false;
  int expandedIndex = -1;

  void toggleExpand(int index) {
    setState(() {
      isExpanded = !isExpanded;
      expandedIndex = index;
    });
  }

  void viewQRCode(int index, List<QueryDocumentSnapshot> lunchPasswords) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QRCodePage(
          label: lunchPasswords[index]['cod'].toString(),
          date: lunchPasswords[index]['data'].toDate(),
        ),
      ),
    ).then((value) {
      setState(() {
        isExpanded = false;
        expandedIndex = -1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    final currentUserUID = currentUser != null ? currentUser.uid : '';

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            bottomOpacity: 0.6,
            elevation: 0.6,
            leading: Container(
              margin: const EdgeInsets.only(
                left: 20.0,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 25,
                color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                    0xFF000000),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
            toolbarHeight: 90,
            title: const Text(
              'Cumparaturi',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            centerTitle: true,
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (OverscrollIndicatorNotification overscroll) {
              overscroll.disallowIndicator();
              return true;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('tickets')
                        .where('user', isEqualTo: currentUserUID)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final lunchPasswords = snapshot.data!.docs;
                        if (lunchPasswords.isEmpty) {
                          return const Center(
                            child: Text(
                              'Nicio achizitie',
                              style: TextStyle(
                                  fontSize: 16, fontFamily: 'Poppins'),
                            ),
                          );
                        } else {
                          return GridView.count(
                            crossAxisCount: 2,
                            children: lunchPasswords
                                .asMap()
                                .entries
                                .map(
                                  (entry) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Card(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          if (isExpanded &&
                                              entry.key == expandedIndex)
                                            Expanded(
                                              child: InkWell(
                                                onTap: () => viewQRCode(
                                                    entry.key, lunchPasswords),
                                                child: QrImageView(
                                                  data: entry.value['cod']
                                                      .toString(),
                                                  version: QrVersions.auto,
                                                ),
                                              ),
                                            )
                                          else
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      title:
                                                          const Text('Ativati'),
                                                      content: const Text(
                                                          'Doriți să activați această parolă?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: const Text(
                                                              'Anulare'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                            viewQRCode(
                                                                entry.key,
                                                                lunchPasswords);
                                                          },
                                                          child: const Text(
                                                              'Ativare'),
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );
                                              },
                                              child: QrImageView(
                                                data: entry.value['cod']
                                                    .toString(),
                                                version: QrVersions.auto,
                                                size: 90,
                                              ),
                                            ),
                                          const SizedBox(height: 8),
                                          Text(
                                            DateFormat('dd/MM/yyyy').format(
                                                entry.value['data'].toDate()),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                          Text(
                                            entry.value['type'].toString(),
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          );
                        }
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
