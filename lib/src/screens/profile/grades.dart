import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotasDisciplinasPage extends StatefulWidget {
  const NotasDisciplinasPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotasDisciplinasPageState createState() => _NotasDisciplinasPageState();
}

class _NotasDisciplinasPageState extends State<NotasDisciplinasPage> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late double containerWidth;
  Map<String, bool> expandedYears = {};
  double mediaNotas = 0.0;

  @override
  void initState() {
    super.initState();
    fetchNotasData();
  }

  void fetchNotasData() async {
    QuerySnapshot snapshot = await firestore.collection('materii').get();

    // Organize data by year and semester
    Map<String, Map<String, List<Map<String, dynamic>>>> notasMap = {};

    for (DocumentSnapshot document in snapshot.docs) {
      String ano = document['An'];
      String semestre = document['Semestru'];
      String nome = document['Nume'];
      int nota = document['Nota'];

      if (!notasMap.containsKey(ano)) {
        notasMap[ano] = {};
      }

      if (!notasMap[ano]!.containsKey(semestre)) {
        notasMap[ano]![semestre] = [];
      }

      notasMap[ano]![semestre]!.add({
        'nume': nome,
        'nota': nota,
      });
    }

    // Calculate the average of the grades
    double totalNotas = 0.0;
    int disciplinasCount = 0;

    for (var entry in notasMap.entries) {
      for (var semester in entry.value.values) {
        for (var disciplina in semester) {
          totalNotas += disciplina['nota'];
          disciplinasCount++;
        }
      }
    }

    setState(() {
      mediaNotas = disciplinasCount > 0 ? (totalNotas / disciplinasCount) : 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    containerWidth = 0.9 * MediaQuery.of(context).size.width;

    return MaterialApp(
      title: 'Unilink',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          bottomOpacity: 0.6,
          elevation: 0.6,
          leading: Container(
            margin: const EdgeInsets.only(left: 20.0),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              iconSize: 25,
              color: Color(
                  int.parse("0097b2".substring(0, 6), radix: 16) + 0xFF000000),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          toolbarHeight: 90,
          title: const Text(
            'Unilink',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    "Notele mele",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Média Finala: ${mediaNotas.toStringAsFixed(2)}",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.only(left: 30),
                    width: containerWidth,
                    constraints: BoxConstraints(
                      minWidth: containerWidth,
                      maxWidth: MediaQuery.of(context).size.width,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(4, 124, 145, 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 1; i <= 3; i++)
                          FutureBuilder<QuerySnapshot>(
                            future: firestore.collection('materii').get(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }

                              if (snapshot.hasData) {
                                // Organize data by year and semester
                                Map<String,
                                        Map<String, List<Map<String, dynamic>>>>
                                    notasMap = {};

                                for (DocumentSnapshot document
                                    in snapshot.data!.docs) {
                                  String ano = document['An'];
                                  String semestre = document['Semestru'];
                                  String nome = document['Nume'];
                                  int nota = document['Nota'];

                                  if (!notasMap.containsKey(ano)) {
                                    notasMap[ano] = {};
                                  }

                                  if (!notasMap[ano]!.containsKey(semestre)) {
                                    notasMap[ano]![semestre] = [];
                                  }

                                  notasMap[ano]![semestre]!.add({
                                    'nume': nome,
                                    'nota': nota,
                                  });
                                }

                                // Calculate the average of the grades
                                double totalNotas = 0.0;
                                int disciplinasCount = 0;

                                for (var entry in notasMap.entries) {
                                  for (var semester in entry.value.values) {
                                    for (var disciplina in semester) {
                                      totalNotas += disciplina['nota'];
                                      disciplinasCount++;
                                    }
                                  }
                                }

                                // ignore: unused_local_variable
                                double mediaNotas = disciplinasCount > 0
                                    ? (totalNotas / disciplinasCount)
                                    : 0.0;

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          expandedYears['$i'] =
                                              !expandedYears.containsKey('$i')
                                                  ? true
                                                  : !expandedYears['$i']!;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Text(
                                          '$iº An',
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (expandedYears.containsKey('$i') &&
                                        expandedYears['$i']!)
                                      for (var entry in notasMap['$i']!.entries)
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                // Handle Semester clicked
                                                // You can fetch the corresponding data from the database or perform any action here
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0,
                                                ),
                                                child: Text(
                                                  '${entry.key}º Semestru',
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            for (var disciplina in entry.value)
                                              InkWell(
                                                onTap: () {
                                                  // Handle Discipline clicked
                                                  // You can fetch the corresponding data from the database or perform any action here
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    vertical: 8.0,
                                                    horizontal: 16.0,
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        disciplina['nume'],
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        'Nota: ${disciplina['nota']}',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                  ],
                                );
                              }

                              return const SizedBox.shrink();
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const NotasDisciplinasPage());
}
