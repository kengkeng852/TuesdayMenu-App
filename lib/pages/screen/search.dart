import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterproject/data/firestore_service.dart';
import 'package:flutterproject/models/restaurant_firestore.dart';
import 'package:flutterproject/widgets/restaurant_card.dart';
import 'package:flutterproject/pages/restaurantpage/res1.dart';
import 'package:flutterproject/widgets/nav.dart';



class SearchPage extends StatefulWidget {
  final String query;

  SearchPage({required this.query});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Restaurant> _searchResults = [];
  final _firestoreDatabase = FirestoreDatabase();
  bool _isLoading = false;
  final selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _performSearch(widget.query);
  }

  void _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    final results = await _firestoreDatabase.searchRestaurants(query);
    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD4CBBC),
      appBar: AppBar(
        title: Text('Search results for "${widget.query}"'),
        backgroundColor: Color(0xffD4CBBC),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    final restaurant = _searchResults[index];
                    return 
                      InkWell(
                        onTap: () { 
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => res1(id: restaurant.id), 
                            ),
                          );
                        },
                        child: RestaurantCard(restaurant: restaurant),
                      );
                  },
                )
              : Center(
                  child: Text(
                    'No results found for "${widget.query}"',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
        bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex), 
    );
  }
}