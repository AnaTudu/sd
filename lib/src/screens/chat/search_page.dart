import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:bbbbbbbbbbbb/src/screens/chat/chat_screen.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _searchResults = [];

  Future<void> _searchUsers(String query) async {
    final usersSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('number', isEqualTo: query)
        .get();

    final nameSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: query)
        .get();

    setState(() {
      _searchResults = [...usersSnapshot.docs, ...nameSnapshot.docs];
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text('Căutați utilizatorul',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black,
                  fontWeight: FontWeight.w700)),
          bottomOpacity: 0.5,
          elevation: 0.5,
          centerTitle: true,
          leading: Container(
            margin: const EdgeInsets.only(
              left: 20,
            ),
            child: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                iconSize: 25,
                color: Color(int.parse("#0097b2".substring(1, 7), radix: 16) +
                    0xFF000000),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          toolbarHeight: 90),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Căutați după numărul sau numele studentului',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                    int.parse("#0097b2".substring(1, 7), radix: 16) +
                        0xFF000000)),
            onPressed: () async {
              final query = _searchController.text.trim();
              if (query.isNotEmpty) {
                await _searchUsers(query);
              }
            },
            child:
                const Text('Search', style: TextStyle(fontFamily: 'Poppins')),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final userData = _searchResults[index].data();
                final userId = userData['id'] as String?;
                final userName = userData['name'] as String?;

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userData['photo']),
                  ),
                  title: Text(userName ?? ''),
                  onTap: () {
                    if (userId != null && userName != null) {
                      final currentUser = FirebaseAuth.instance.currentUser;
                      final currentUserUid = currentUser?.uid ?? '';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            currentUserId: currentUserUid,
                            friendId: userId,
                            friendImage: userData['photo'] as String,
                            friendName: userName,
                          ),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ignore: unused_element
  void _navigateToChat(BuildContext context,
      List<QueryDocumentSnapshot<Map<String, dynamic>>> searchResults) {
    if (searchResults.isEmpty) {
      // Display a message indicating no search results found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No users found with the given username.')),
      );
    } else {
      final userData = searchResults.first.data();
      final userId = userData['id'] as String?;
      final userName = userData['name'] as String?;
      final currentUser = FirebaseAuth.instance.currentUser;
      final currentUserUid = currentUser?.uid ?? '';
      if (userId != null && userName != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              currentUserId: currentUserUid,
              friendId: userId,
              friendImage: userData['photo'],
              friendName: userName,
            ),
          ),
        );
      }
    }
  }
}
