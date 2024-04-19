import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/models/restaurant_firestore.dart'; 

class mapService {

  Future<Position> getCurrentLocation() async{
   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException('Location services are disabled');
    }
   LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.deniedForever){
        return Future.error('Location permissions are permanently denied, we cannot request permissions.');
      }
      if (permission == LocationPermission.denied) {
      throw LocationPermissionDeniedException('Location permissions are denied');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  Future<List<Restaurant>> fetchRestaurantLocations() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .get();
    return querySnapshot.docs
        .map((doc) => Restaurant.fromFirestore(doc))
        .where((restaurant) => restaurant.location != null) 
        .toList();
  }

}

class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException(this.message);
}

class LocationPermissionDeniedException implements Exception {
  final String message;
  LocationPermissionDeniedException(this.message);
}

class LocationPermissionDeniedForeverException implements Exception {
  final String message;
  LocationPermissionDeniedForeverException(this.message);
}