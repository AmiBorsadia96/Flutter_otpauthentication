import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_otpfirebase/screens/home.dart';
import 'package:flutter_app_otpfirebase/screens/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: InitializerWidget()
    );
  }
}

class InitializerWidget  extends StatefulWidget {
  @override
  _InitializerWidgetState createState() => _InitializerWidgetState();
}

class _InitializerWidgetState extends State<InitializerWidget > {

 FirebaseAuth _auth;
 User _user;
 bool isloading = true;
  @override
  void initState(){
    super.initState();
    _auth = FirebaseAuth.instance;
    _user = _auth.currentUser;
    isloading = false;
  }
 @override
 Widget build(BuildContext context) {
   return isloading ? Scaffold(
     body: Center(
       child: CircularProgressIndicator(),
     ),
   ) : _user == null ? login() : home();
 }
}
