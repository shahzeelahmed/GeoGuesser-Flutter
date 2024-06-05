import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geo_guessr/views/game_page.dart';
import 'package:geo_guessr/views/home_page.dart';

Future<void> navigateToGamePage(
    BuildContext context, String roomId, String username) async {
  QuerySnapshot<Map<String, dynamic>> roomSnapshot = await FirebaseFirestore
      .instance
      .collection('rooms')
      .where('room_name', isEqualTo: roomId)
      .get();
  final addname = await FirebaseFirestore.instance
      .collection('rooms')
      .doc(roomId).set(
          {
            "players": FieldValue.arrayUnion(
              [username],
            ),
          },
          SetOptions(merge: true),
        );
  if (roomSnapshot.docs.isNotEmpty) {
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  WebViewPage(userName: username,roomId: roomId, )),
    );
  } else {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text("The entered room ID is incorrect."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
