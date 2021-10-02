import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_otpfirebase/screens/home.dart';

enum MobileVerificationState{
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class login extends StatefulWidget {
  @override
  _loginState createState() => _loginState();
}

class _loginState extends State<login> {
  MobileVerificationState currentState= MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  final phoneController =TextEditingController();
  final otpController=TextEditingController();

  FirebaseAuth _auth=FirebaseAuth.instance;

  String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(PhoneAuthCredential phoneAuthCredential) async{
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
        await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading=false;
      });

      if(authCredential?.user != null){
        Navigator.push(context,MaterialPageRoute(builder: (context)=> home()));
      }

    } on FirebaseAuthException catch(e){
      setState(() {
        showLoading = false;
      });
      _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  getMobileFormWidget(context){
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: "Phone Number",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed:() async{

           setState(() {
             showLoading = true;
           });

           await  _auth.verifyPhoneNumber(
             phoneNumber: phoneController.text,
             verificationCompleted: (phoneAuthCredential) async{
              setState(() {
                showLoading = false;
              });
              //signInWithPhoneAuthCredential(phoneAuthCredential);
             },
             verificationFailed: (verificationFailed) async{
               setState(() {
                 showLoading = false;
               });
                _scaffoldkey.currentState.showSnackBar(SnackBar(content: Text(verificationFailed.message)));
             },
             codeSent: (verificationId, resendingToken) async{
               setState(() {
                 showLoading = false;
                 currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                 this.verificationId =verificationId;
               });
             },
             codeAutoRetrievalTimeout: (verificationId) async{
             },
           );
          },
          child: Text("CONTINUE"),
          color: Colors.blue[900],
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context){
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: "Enter otp",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed:() async {
            PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: otpController.text);
            signInWithPhoneAuthCredential(phoneAuthCredential);
            },
          child: Text("CONTINUE AND VERIFY"),
          color: Colors .blue[900],
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }
final GlobalKey<ScaffoldState> _scaffoldkey=GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldkey,
      body: Container(
          child: showLoading ? Center(child: CircularProgressIndicator(),) : currentState==MobileVerificationState.SHOW_MOBILE_FORM_STATE
          ?getMobileFormWidget(context) 
          :getOtpFormWidget(context),
              padding: const EdgeInsets.all(16),
      )
    );
  }
}

