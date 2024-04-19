import 'package:flutter/material.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:flutterproject/pages/global.dart';
import 'package:flutterproject/models/app_state.dart';
import 'package:flutterproject/models/user.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/pages/screen/save.dart';
import 'package:flutterproject/pages/screen/profile.dart';



class BottomNavBar extends StatefulWidget {
  int selectedIndex;

  BottomNavBar({required this.selectedIndex});

  @override
  _BottomNavBarState createState() => _BottomNavBarState(); 
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _onItemTapped(int index)  { 
    setState(() {
    widget.selectedIndex = index; 
  });
    final user = Provider.of<AppState>(context, listen: false).currentUser;
    switch (index) {
      case 0:
        Navigator.push( 
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user ?? User.empty())),
        );
        break;
      case 1:
         Navigator.push( 
          context,
          MaterialPageRoute(builder: (context) => SavedPage(user: user!)), 
        );
        break;
      case 2:
        Navigator.push( 
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppState>(context).currentUser;
    return BottomNavigationBar(
      backgroundColor: Color(0xFFAAB07E),
      currentIndex: widget.selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Saved',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Me',
        ),
      ],
    );
  }
}