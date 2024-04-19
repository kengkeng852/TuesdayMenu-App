import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:flutterproject/pages/start.dart';
import 'package:flutterproject/firebase_auth/firebase_auth_service.dart';
import 'package:flutterproject/data/firestore_service.dart'; 
import 'package:flutterproject/models/app_state.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); 
  runApp(MyApp());
} 

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider( 
      providers: [
        ChangeNotifierProvider<AppState>(create: (_) => AppState()),
        ChangeNotifierProvider<FirestoreDatabase>(create: (_) => FirestoreDatabase()), 
      ],
      child: MaterialApp(
        title: 'Tuesedaymenu',
        debugShowCheckedModeBanner: false,
        home: startScreen(), 
      ),
    );
  }
}
