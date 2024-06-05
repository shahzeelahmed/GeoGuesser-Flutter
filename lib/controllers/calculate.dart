import 'dart:math';


double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371; 
  double degToRad(double deg) {
    return deg * (pi / 180);
  }
  double dLat = degToRad(lat2 - lat1);
  double dLon = degToRad(lon2 - lon1);
  double a = sin(dLat / 2) * sin(dLat / 2) +
  cos(degToRad(lat1)) * cos(degToRad(lat2)) *
  sin(dLon / 2) * sin(dLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));
  double distance = earthRadius * c;
  return distance; 
}

