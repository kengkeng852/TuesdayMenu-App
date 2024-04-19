import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutterproject/pages/screen/login.dart';
import 'package:flutterproject/firebase_auth/firebase_auth_service.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:flutterproject/models/user.dart' as AppUser;
import 'package:flutterproject/data/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/models/app_state.dart';


class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _authService = FirebaseAuthService();
  final FirestoreDatabase _firestoreService = FirestoreDatabase();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameController = TextEditingController();

  @override
  void dispose(){
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAB07E),
      appBar: AppBar(
        title: Text("Register Page"),
        backgroundColor: Color(0xFFAAB07E),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("username", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: _usernameController,
                    validator:
                        RequiredValidator(errorText: "please enter a name"),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("email", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: _emailController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "please enter username"),
                      EmailValidator(errorText: "incorect email format")
                    ]),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Password", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: _passwordController,
                    validator: MultiValidator([
                      RequiredValidator(errorText: "please enter password"),
                      MinLengthValidator(6, errorText: "password must be at least 6 characters long")
                      ]),
                    obscureText: true,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      child: Text(
                        "Register",
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () async {  
                        if (formKey.currentState!.validate()) {
                          formKey.currentState?.save(); 
                          _register(); 
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

    void _register() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    String username = _usernameController.text; 

    try {
      User? firebaseUser = await _authService.signUpWithEmailAndPassword(email, password);
      if (firebaseUser != null) {
        print('Registration Successful');
        AppUser .User user = AppUser.User(
          uid: firebaseUser.uid,
          username: username, 
          savedRestaurants: [], 
        );
        await FirestoreDatabase().addUser(user);
        Provider.of<AppState>(context, listen: false).setCurrentUser(user); 
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage(user: user)),
        );
      } else {
        print('Registration Failed');
      }
    } on FirebaseAuthException catch (e) {
      print('Firebase Auth Error: ${e.code} - ${e.message}'); 
    } catch (e) {
      print('Registration Error: $e'); 
    }
  }

}