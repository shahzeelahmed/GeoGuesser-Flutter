

  import 'package:cloud_firestore/cloud_firestore.dart';


Future<void> updatePlayerScoreInRoom(
  String roomId, String playerId, int newScore) async {
  try {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
  
    DocumentReference roomRef = firestore.collection('rooms').doc(roomId);

  
    DocumentSnapshot roomSnapshot = await roomRef.get();
    if (!roomSnapshot.exists) {
      print('Room document does not exist.');
      return;
    }

    
    await roomRef.set({
      'scores': {playerId: newScore}
    }, SetOptions(merge: true));

    print('Player score updated successfully in the room!');
  } catch (error) {
    print('Error updating player score in the room: $error');
  }
}

