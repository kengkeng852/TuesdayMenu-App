import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterproject/models/restaurant_firestore.dart';
import 'package:flutterproject/models/restaurant_distance.dart';
import 'package:flutterproject/models/user.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/models/app_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class FirestoreDatabase extends ChangeNotifier{
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Restaurant>> fetchAllRestaurants() async {
    QuerySnapshot querySnapshot = await _db.collection('restaurants').get();
    return querySnapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
  }

  Future<List<Restaurant>> searchRestaurants(String query) async {
  final results = await FirebaseFirestore.instance
      .collection('restaurants')
      .where('name', isGreaterThanOrEqualTo: query) 
      .where('name', isLessThan: query + 'z') 
      .get();
  return results.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
  } 

  Future<List<Restaurant>> fetchRestaurantsByHighestReview() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .orderBy('rating', descending: true) 
        .get();
    return querySnapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();
  }

  Future<List<Restaurant>> fetchCheapestRestaurants() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .get(); 

    final restaurants = querySnapshot.docs.map((doc) => Restaurant.fromFirestore(doc)).toList();

    restaurants.sort((a, b) {
      final priceA = getPriceOrder(a.price); 
      final priceB = getPriceOrder(b.price); 
      return priceA.compareTo(priceB); 
    });
    return restaurants;
  }

  Future<List<Restaurant>> fetchNearestRestaurants(userLocation) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('restaurants')
        .get();  
    final restaurants = querySnapshot.docs
      .map((doc) => Restaurant.fromFirestore(doc))
      .where((restaurant) => restaurant.location != null) 
      .toList();

    final restaurantsWithDistance = restaurants.map((restaurant) {
      final locationParts = restaurant.location!.split(', '); 
      final restaurantLocation = GeoPoint(
       double.parse(locationParts[0]),
       double.parse(locationParts[1]),
    );

    final distance = Geolocator.distanceBetween(
       userLocation.latitude, userLocation.longitude,
       restaurantLocation.latitude, restaurantLocation.longitude,
    );

    return RestaurantWithDistance(restaurant: restaurant, distance: distance);
  }).toList();

  restaurantsWithDistance.sort((a, b) => a.distance.compareTo(b.distance)); 
  
  final sortedRestaurants = restaurantsWithDistance.map((rwd) => rwd.restaurant).toList(); 

  return sortedRestaurants;
  }

  Future<Restaurant?> fetchRestaurantDetail(String id) async {  
    try {
      final documentSnapshot = await FirebaseFirestore.instance
         .collection('restaurants')
         .doc(id)
         .get();

      if (documentSnapshot.exists) {
        return Restaurant.fromFirestore(documentSnapshot);
      } else {
        return null; 
      }
    } catch (error) {
      print("Error fetching restaurant details: $error");
      return null;  
    }
  }


  Future<void> addUser(User user) async {
    await _db.collection('users').doc(user.uid).set(user.toMap());
  }

  Future<User?> getUser(String uid) async {
    final docSnapshot = await _db.collection('users').doc(uid).get();
    if (docSnapshot.exists) {
      return User.fromFirestore(docSnapshot);
    } else {
      return null;
    }
  }
  
  Future<void> updateSavedRestaurants(String uid, String restaurantId, bool isSaved) async {
    final userDoc = _db.collection('users').doc(uid);
    if (isSaved) {
      await userDoc.update({
        'savedRestaurants': FieldValue.arrayUnion([restaurantId])
      });
    } else {
      await userDoc.update({
        'savedRestaurants': FieldValue.arrayRemove([restaurantId]),
      });
    }
  }

  Future<bool> checkSavedStatus(String uid, String restaurantId) async {
    final userDoc = await _db.collection('users').doc(uid).get();
    if (userDoc.exists) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final likedRestaurants = userData['savedRestaurants']?.cast<String>() ?? [];
      return likedRestaurants.contains(restaurantId);
    } else {
      return false; 
    }
  }
  
  Future<void> addReview(String restaurantId, String name, String review, String uid) async {
    final restaurantRef = _db.collection('restaurants').doc(restaurantId); 

     await restaurantRef.update({
      'review': FieldValue.arrayUnion([
        {
          '0': '$name',
          '1': review,
          '2': uid 
        }
      ])
    });
    
    notifyListeners(); 
  }

  
  Future<List<Restaurant>> fetchRestaurantsByIds(List<String> ids) async {
    List<Restaurant> restaurants = [];
    for (String id in ids) {
      final doc = await _db.collection('restaurants').doc(id).get();
      restaurants.add(Restaurant.fromFirestore(doc));
    }
    return restaurants;
  }



  int getPriceOrder(String priceSymbol) {
    switch (priceSymbol) {
      case '฿':
        return 1;
      case '฿฿':
        return 2;
      case '฿฿฿':
        return 3;
      default:
        return 0; 
    }
  }



}

