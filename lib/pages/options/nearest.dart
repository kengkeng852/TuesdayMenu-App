import 'package:flutter/material.dart';
import 'package:flutterproject/pages/options/nearest.dart';
import 'package:flutterproject/pages/options/worldwide.dart';
import 'package:flutterproject/pages/options/nearest.dart';
import 'package:flutterproject/pages/restaurantpage/res1.dart';
import 'package:flutterproject/pages/options/nearest.dart';
import 'package:flutterproject/widgets/restaurant_card.dart';
import 'package:flutterproject/pages/screen/search.dart';
import 'package:flutterproject/widgets/res_option.dart';
import 'package:flutterproject/pages/global.dart';
import 'package:flutterproject/widgets/nav.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterproject/models/restaurant_firestore.dart';
import 'package:flutterproject/data/firestore_service.dart';
import 'package:flutterproject/models/restaurant_distance.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutterproject/widgets/appbar.dart';
import 'package:flutterproject/map_service/map_service.dart';

class nearest extends StatefulWidget {
  const nearest({Key? key});
  @override 
  State<nearest> createState() => _nearest();
}

class _nearest extends State<nearest> {
  final _textController = TextEditingController();
  int selectedIndex = 0;
  final _firestoreDatabase = FirestoreDatabase();
  bool _isLoading = false; 
  List<Restaurant> _restaurants = [];
  final mapService _mapService = mapService();
  
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

   Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Position? _currentPosition; 
      _currentPosition = await _mapService.getCurrentLocation();
      print(_currentPosition);
      final restaurants = await _firestoreDatabase.fetchNearestRestaurants(_currentPosition); 
     
      setState(() {
        _restaurants = restaurants;
        _isLoading = false;
      });

    } catch (error) {
      print('Error fetching nearest restaurants: $error');
      setState(() {
        _isLoading = false;  
      });
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(),
    ),
    body: SingleChildScrollView(
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       OptionsBar(
          selectedIndex: selectedOptionIndex,
          onIndexChanged: (newIndex) => setState(() => selectedOptionIndex.value = newIndex),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Color(0xffD4CBBC),
              padding: const EdgeInsets.only(top:10, left:10),
                child: Row(   
                  children: [
                    const Text('Suggest nearest review restaurants for you: '),
                  ],
                ),
            ),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child :Container(
                color: Color(0xffD4CBBC),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Column( 
                    children: [
                       _isLoading
                         ? Center(child: CircularProgressIndicator())
                         : Column(children: [ 
                            for (final restaurant in _restaurants)
                              InkWell(
                                onTap: () { 
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => res1(id: restaurant.id), 
                                    ),
                                  );
                                },
                                child: RestaurantCard(restaurant: restaurant)
                            ),
                          ],
                      ),
                    ],
                  ),
                ),
              )
            )
          ],
        ),
      ],
    ),
  ),
    bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex), 
  );
}


}




