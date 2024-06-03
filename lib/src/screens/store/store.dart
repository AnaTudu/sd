import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/store/dress.dart';
import 'package:bbbbbbbbbbbb/src/screens/store/tickets.dart';

class Store extends StatelessWidget {
  const Store({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyStore();
  }
}

class MyStore extends StatefulWidget {
  const MyStore({super.key});

  @override
  State<MyStore> createState() => _MyStoreState();
}

class _MyStoreState extends State<MyStore> {
  int _selectedIndex = 0;
  bool _imagesVisibility = true;
  bool _backVisibility = false;

  static const List<Widget> _widgetOptions = <Widget>[
    SizedBox.shrink(),
    Tickets(),
    Academic(),
  ];

  @override
  Widget build(BuildContext context) {
    return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowIndicator();
          return true;
        },
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Visibility(
                visible: _backVisibility,
                child: Container(
                    margin: const EdgeInsets.only(top: 40),
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedIndex = 0;
                            _imagesVisibility = true;
                            _backVisibility = false;
                          });
                        },
                        child: Text(
                          'voltar',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            color: Color(int.parse("#0097b2".substring(1, 7),
                                    radix: 16) +
                                0xFF000000),
                          ),
                        )))),
            _widgetOptions.elementAt(_selectedIndex),
            Visibility(
                visible: _imagesVisibility,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                      _imagesVisibility = false;
                      _backVisibility = true;
                    });
                  },
                  child: const Image(image: AssetImage('assets/images/qr.png')),
                )),
            Visibility(
                visible: _imagesVisibility,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 2;
                      _imagesVisibility = false;
                      _backVisibility = true;
                    });
                  },
                  child: const Image(
                      image: AssetImage('assets/images/trajes.png')),
                )),
          ],
        ));
  }
}
