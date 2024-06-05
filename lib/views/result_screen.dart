


import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreListView extends StatelessWidget {
  final String roomId;

  const ScoreListView({super.key, required this.roomId});
  
    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Player Scores'),
      ),
      body: StreamBuilder(
        stream: 
 
        FirebaseFirestore.instance.collection('rooms').doc(roomId).snapshots()
        
        ,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
     
          Map<String, dynamic>? scores = snapshot.data!.get('scores');

          if (scores == null || scores.isEmpty) {
            return Center(
              child: Text('No scores available for this room'),
            );
          }

          List<MapEntry<String, int>> sortedScores = scores.entries
              .map((entry) => MapEntry(entry.key, entry.value as int)) // Cast value to int
              .toList();

   
         sortedScores.sort((a, b) => b.value.compareTo(a.value)); // 

         
          return ListView.builder(
            itemCount: sortedScores.length,
            itemBuilder: (context, index) {
            
              String playerName = sortedScores[index].key;
              int playerScore = sortedScores[index].value;
              
             
              return ListTile(
                title: Text(playerName),
                subtitle: Text('Score: $playerScore'),
              );
            },
          );
        },
      ),
    );
  }
}

