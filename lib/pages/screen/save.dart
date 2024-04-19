import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterproject/models/restaurant_firestore.dart'; 
import 'package:flutterproject/models/app_state.dart';
import 'package:flutterproject/data/firestore_service.dart'; 
import 'package:flutterproject/pages/restaurantpage/res1.dart';
import 'package:flutterproject/models/user.dart';
import 'package:flutterproject/widgets/restaurant_card.dart';
import 'package:flutterproject/widgets/nav.dart';

class SavedPage extends StatefulWidget {
  final User user;
  const SavedPage({Key? key, required this.user}) : super(key: key);

  @override
  _SavedPageState createState() => _SavedPageState();
}

class _SavedPageState extends State<SavedPage> {
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  List<Restaurant> _savedRestaurants = [];
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  int selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchSavedRestaurants();
  }

  Future<void> _fetchSavedRestaurants() async {
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    if (user != null) {
      final userDoc = await _db.collection('users').doc(user.uid).get();
      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        final savedIds = userData['savedRestaurants']?.cast<String>() ?? [];

        final restaurants = await _firestoreDatabase.fetchRestaurantsByIds(savedIds);
        setState(() {
          _savedRestaurants = restaurants;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD4CBBC), 
      appBar: AppBar(
        title: const Text('Saved Restaurants'),
        backgroundColor: Color(0xFF707C4F),
      ),
      body: _savedRestaurants.isEmpty
          ? const Center(child: Text('You have no saved restaurants.'))
          : ListView.builder(
        itemCount: _savedRestaurants.length,
        itemBuilder: (context, index) {
          final restaurant = _savedRestaurants[index];
          return InkWell( 
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => res1(id: restaurant.id)),
              );
            },
            child: RestaurantCard(restaurant: restaurant), 
          );
        },
      ),
       bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex), 
    );
  }
}
