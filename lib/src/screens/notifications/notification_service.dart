import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class LocalNotificationService {
  static String serverKey =
      'AAAAzB32xCU:APA91bH7dwjNTbRiwZ-JU4p_rOoRmv1rrhNkBA5Vh49DSRe6MTGqZX0GxGELXjjA6x4nHzc79sH2KkEmqxDqlfa_QCc9G-ZzRMSTXHLMUttch9cW8Q7qi5S9okUKhCY_aqqf3YVjnGT2';

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static void initialize() {
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: AndroidInitializationSettings("@mipmap/ic_launcher"));
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void display(RemoteMessage message) async {
    try {
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
          "mychanel",
          "my chanel",
          importance: Importance.max,
          priority: Priority.high,
        ),
      );

      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationDetails,
      );

      ///

      // ignore: unnecessary_null_comparison
      if (message.data != null && message.data['type'] != 'messages') {
        /*
        await FirebaseFirestore.instance.collection('notifications_all').add({
          'title': message.notification!.title,
          'body': message.notification!.body,
          'timestamp': FieldValue.serverTimestamp(),
          'type': message.data['type']
        });*/
      } else {
        await FirebaseFirestore.instance.collection('notifications_user').add({
          'title': message.notification!.title,
          'body': message.notification!.body,
          'timestamp': FieldValue.serverTimestamp(),
          'uid': message.data['uid'],
        });
      }
      // ignore: empty_catches, unused_catch_clause
    } on Exception catch (e) {}
  }

  static Future<void> sendNotificationToUser(
      {String? title, String? message, String? uid, String? type}) async {
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'message': message
    };

    try {
      String token = await getUserToken(uid!);
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": token,
          },
        ),
      );

      if (r.statusCode == 200) {
        await FirebaseFirestore.instance
            .collection('notifications_user')
            .doc()
            .set({
          'title': title,
          'body': message,
          'timestamp': FieldValue.serverTimestamp(),
          'uid': uid,
          'type': type
        });
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future<String> getUserToken(String uid) async {
    final docSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final token = docSnapshot.data()?['fcmToken'];
    return token.toString();
  }

  static Future<List<Map<String, dynamic>>> getNotificationsForUser(
      String uid) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications_user')
          // .where('uid', isEqualTo: uid)
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      return [];
    }
  }

  static Future<void> storeToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({'fcmToken': token!}, SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future<void> sendNotificationToAll(
      {String? title, String? message, String? type}) async {
    final data = {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      'message': message
    };

    try {
      http.Response r = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': message, 'title': title},
            'priority': 'high',
            'data': data,
            "to": "/topics/all",
          },
        ),
      );

      if (r.statusCode == 200) {
        await FirebaseFirestore.instance.collection('notifications_all').add({
          'title': title,
          'body': message,
          'timestamp': FieldValue.serverTimestamp(),
          'type': type,
        });
      } else {}
      // ignore: empty_catches
    } catch (e) {}
  }

  static Future<List<Map<String, dynamic>>> getNotificationsForAll() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('notifications_all')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (error) {
      return [];
    }
  }
}
