import 'package:flutter/material.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:flutterproject/pages/restaurantpage/res1.dart';
import 'package:flutterproject/widgets/restaurant_cardurl.dart';
import 'package:flutterproject/models/restaurant_api.dart';
import 'package:flutterproject/widgets/res_option.dart';
import 'package:flutterproject/pages/global.dart';
import 'package:flutterproject/widgets/nav.dart';
import 'package:flutterproject/widgets/appbar.dart';

class worldwide extends StatefulWidget {
   const worldwide({Key? key}) : super(key: key);
   
  @override 
  State<worldwide > createState() => _worldwide ();
}

class _worldwide extends State<worldwide > {
  int selectedIndex = 0;
  final _textController = TextEditingController();

  List<Restaurant> _restaurants = []; 
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
      final restaurants = await getRestaurants();
      setState(() {
        _restaurants = restaurants;
        _isLoading = false;
      });
    } catch (error) {
      print(error); 
      setState(() => _isLoading = false);
    }
  }
@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color (0xffD4CBBC),
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
                    const Text('Suggest your worldwide restaurants for you: '),                  ],
                ),
            ),
            if (_isLoading) const Center(child: CircularProgressIndicator())
            else Positioned( 
                    bottom: 0.0,
                    left: 0.0,
                    right: 0.0,
                    child: Container(
                      color: Color(0xffD4CBBC),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          children: _restaurants.map((restaurant) => RestaurantCardUrl(
                                title: restaurant.name,
                                rating: '${restaurant.ratingValue} (${restaurant.reviewCount} reviews)',
                                country: restaurant.countryname,
                                imageUrl: restaurant.mainPhotoSrc,
                              )).toList(),
                        ),
                      ),
                    ),
             ),
          ],
        ),
      ],
    ),
    ),
    bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex), 
    );
}
  
   
}



