// ignore_for_file: unnecessary_null_comparison

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:bbbbbbbbbbbb/src/screens/notifications/notification_service.dart';
import 'package:bbbbbbbbbbbb/src/screens/home/home.dart';

class CreateEventPage extends StatefulWidget {
  const CreateEventPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateEventPageState createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  File? _selectedImage;

  DateTime? _selectedDate;
  String _selectedTime = '';
  String _selectedMinutes = '';

  String getFormattedDateTime() {
    if (_selectedDate != null &&
        _selectedTime.isNotEmpty &&
        _selectedMinutes.isNotEmpty) {
      final DateTime selectedDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        int.parse(_selectedTime),
        int.parse(_selectedMinutes),
      );
      final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm');
      return formatter.format(selectedDateTime);
    }
    return 'Select Date & Time';
  }

  Future<void> _createEvent() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final date = getFormattedDateTime();

    try {
      String pictureUrl = '';

      if (_selectedImage != null) {
        // Upload the selected image to Firebase Storage and get its URL
        final String fileName =
            '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg';

        final Reference storageRef =
            FirebaseStorage.instance.ref().child('event_images/$fileName');

        await storageRef.putFile(_selectedImage!);
        pictureUrl = await storageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('events').add({
        'userId': userId,
        'title': _titleController.text,
        'description': _descriptionController.text,
        'picture': pictureUrl,
        'date': date,
        'enrolled': [],
      });

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Event created successfully')),
      );

      // Clear the form fields after creating the event
      _titleController.clear();
      _descriptionController.clear();
      _selectedImage = null;
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create event')),
      );
    }
  }

  Future<void> _pickImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  void _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adauga un eveniment'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Titlu',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vă rugăm să alegeți un titlu';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descriere',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Adaugati descrierea evenimentului';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Selectati o imagine'),
                ),
                const SizedBox(height: 16.0),
                if (_selectedImage != null) ...[
                  Image.file(
                    _selectedImage!,
                    height: 200.0,
                    width: 200.0,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16.0),
                ],
                Row(
                  children: [
                    const Text('Date & Time: '),
                    Text(getFormattedDateTime()),
                    IconButton(
                      icon: const Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('Time: '),
                    SizedBox(
                      width: 80.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _selectedTime = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'HH',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Minutes: '),
                    SizedBox(
                      width: 80.0,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            _selectedMinutes = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: 'MM',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_titleController.text == null ||
                        _descriptionController == null ||
                        _selectedImage == null ||
                        _selectedDate == null ||
                        _selectedMinutes == null ||
                        _selectedTime == null) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.warning,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          content:
                              Text('\nCompletați câmpurile obligatorii!\n\n'),
                        ),
                      );
                    } else if (_titleController.text.length > 14) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.warning,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          content: Text('\nTitlu de max 14 caractere!\n\n'),
                        ),
                      );
                    } else if (_descriptionController.text.length > 17) {
                      showDialog(
                        context: context,
                        builder: (context) => const AlertDialog(
                          title: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Icon(
                              Icons.warning,
                              size: 50,
                              color: Colors.blue,
                            ),
                          ),
                          content: Text('\nDescriere de max 14 caractere!\n\n'),
                        ),
                      );
                    } else if (_formKey.currentState!.validate()) {
                      _createEvent();
                      LocalNotificationService.sendNotificationToAll(
                          title: 'Eveniment',
                          message: _titleController.text,
                          type: 'eveniment');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    }
                  },
                  child: const Text('Create Event'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
