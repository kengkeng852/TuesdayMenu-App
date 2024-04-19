import 'package:flutter/material.dart';
import 'package:flutterproject/firebase_auth/firebase_auth_service.dart'; 
import 'package:flutterproject/models/user.dart'; 
import 'package:flutterproject/data/firestore_service.dart';
import 'package:flutterproject/pages/screen/login.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/models/app_state.dart';
import 'package:flutterproject/widgets/nav.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _username = '';
  final FirestoreDatabase _firestoreDatabase = FirestoreDatabase();
  int selectedIndex = 2;
  final _profileImageUrl = 'https://mrwallpaper.com/images/thumbnail/dumb-ways-to-die-bear-cmnilnmmrxj235zo.webp';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = await Provider.of<AppState>(context, listen: false).currentUser; 
    if (user != null) {
      setState(() {
        _username = user.username;
      });
    }
  } 


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffD4CBBC), 
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Color(0xFF707C4F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            _buildProfileHeader(),
            const SizedBox(height: 20.0),
            Text('User Info', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 5.0),
            _buildUserInfo(),
          ],
        ),
      ),
      bottomSheet: _buildLogoutButton(),
      bottomNavigationBar: BottomNavBar(selectedIndex: selectedIndex), 
    );
  }

 Widget _buildProfileHeader() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, 
      children: [
             ClipRRect( 
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                _profileImageUrl,
                height: 200.0,
                width: 200.0,
                fit: BoxFit.cover, 
              ),
             ),
        const SizedBox(height: 10.0),
        Text(_username, style: const TextStyle(fontSize: 35)),
      ],
    );
  }


  Widget _buildUserInfo() {
    return Column( 
      children: [
        ListTile(
          title: const Text('Hobby'),
          trailing: Text("I like to eat delicious food",style: const TextStyle(fontSize: 14)),
          
        ),
      ],
    );
  }

  Widget _buildLogoutButton() {
    final FirebaseAuthService _auth = FirebaseAuthService();

    return GestureDetector(
        onTap: () async {
          await _auth.signOut(); 
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (Route<dynamic> route) => false);
        },
      child: Container(
        alignment: Alignment.center,
        height: 50.0,
        color: Colors.red,
        child: const Text('Log out', style: TextStyle(color: Colors.white, fontSize: 20.0)),
      ),
    );
  }

}
