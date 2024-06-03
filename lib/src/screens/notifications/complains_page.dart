import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/forum/forums.dart';

class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Color(int.parse("#0097b2".substring(1, 7), radix: 16) + 0xFF000000),
        title:
            const Text('Reclamatii', style: TextStyle(fontFamily: 'Poppins')),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('complains').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final complaints = snapshot.data?.docs;

          if (complaints == null || complaints.isEmpty) {
            return const Center(child: Text('Fara reclamatii'));
          }

          return ListView.builder(
            itemCount: complaints.length,
            padding: const EdgeInsets.all(10),
            itemBuilder: (context, index) {
              final complaint = complaints[index];

              final title = complaint['title'] ?? 'No Title';
              final description = complaint['description'] +
                      '\n' +
                      'Titlul postarii: ' +
                      complaint['post title'] +
                      '\n' +
                      'descrierea postarii: ' +
                      complaint['post description'] ??
                  'No Description';

              return ListTile(
                title: Text(title),
                subtitle: Text(description),
                onTap: () {
                  // ignore: unused_local_variable
                  final postId = complaint['postId'];

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Forums(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
