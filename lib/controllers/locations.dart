
import 'package:cloud_firestore/cloud_firestore.dart';

Future<String> getLocations() async {
  final locations = await FirebaseFirestore.instance
      .collection('Locations')
      .doc('Famous places')
      .get();

  return locations.data()?.values.first;
}
