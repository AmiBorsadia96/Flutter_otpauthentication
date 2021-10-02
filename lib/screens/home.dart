import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login.dart';
class home extends StatefulWidget {
  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('Home Screen'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          await _auth.signOut();
          Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => login()));
      },
        child: Icon(Icons.logout),
      ),
    );
  }
}
