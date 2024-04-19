import 'package:flutter/material.dart';
import 'package:flutterproject/pages/screen/register.dart';
import 'package:flutterproject/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutterproject/firebase_auth/firebase_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutterproject/data/firestore_service.dart';
import 'package:provider/provider.dart';
import 'package:flutterproject/models/app_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirestoreDatabase _firestoreService = FirestoreDatabase();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFAAB07E),
      appBar: AppBar(
        title: Text("Login Screen"),
        backgroundColor: Color(0xFFAAB07E),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(10, 50, 10, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Email", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text("Password", style: TextStyle(fontSize: 20)),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    keyboardType: TextInputType.visiblePassword,
                  ),
              SizedBox(
                    height: 15,
                  ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ),
              SizedBox(
                    height: 15,
                  ),
              RichText(text: TextSpan(
                text: "Don't have an account? ",
                style: TextStyle(color: Colors.black, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return RegisterScreen();
                          }),
                        );
                      },
                    text: "Register",
                    style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue, fontSize: 20),
                  ),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }


void _login() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      final user = await _firestoreService.getUser(userCredential.user!.uid); 
    if (user != null) {
      Provider.of<AppState>(context, listen: false).setCurrentUser(user); 
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return HomePage(user: user);
        }),
      );
      }
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Login Error"),
            content: Text("Invalid email or password."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}