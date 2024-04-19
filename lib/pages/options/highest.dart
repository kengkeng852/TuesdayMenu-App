import 'package:flutter/material.dart';
import 'package:flutterproject/pages/options/highest.dart';
import 'package:flutterproject/pages/options/worldwide.dart';
import 'package:flutterproject/pages/options/highest.dart';
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
import 'package:flutterproject/widgets/appbar.dart';

class highest extends StatefulWidget {
  const highest({Key? key});
  @override 
  State<highest> createState() => _highest();
}

class _highest extends State<highest> {
  final _textController = TextEditingController();
  int selectedIndex = 0;

  List<Restaurant> _restaurants = []; 
  final _firestoreDatabase = FirestoreDatabase();
  bool _isLoading = false; 

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
    final restaurants = await _firestoreDatabase.fetchRestaurantsByHighestReview();
    setState(() {
      _restaurants = restaurants;
      _isLoading = false; 
    });
  } catch (error) {
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
                    const Text('Suggest highest review restaurants for you: '),
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
                                child: RestaurantCard(restaurant: restaurant),
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




