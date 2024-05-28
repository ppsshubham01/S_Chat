import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:s_chat/screens/auth_screens/welcom_phone_auth.dart';
import 'package:s_chat/screens/home_screens/home_screens.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
 late StreamSubscription connsub;

 @override
  void initState() {
    super.initState();
    // connsub = Connectivity().onConnectivityChanged.listen(checkConnectivity);
  }

  void checkConnectivity(ConnectivityResult result){
   setState(() {

   });
   // switch(result){
   //   case ConnectivityResult.mobile:
   //     setState(() {
   //
   //     });
   // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          //user is logged in
          if(snapshot.hasData){ // snapshot will have different
            return const HomeScreen();
          }
          else{
            return const PhoneAuth();
          }

          //user is not logged in
        },
      ),
    );
  }
}
