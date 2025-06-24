
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stock_market/auth/login.dart';
import 'package:stock_market/auth/questions_screen.dart';

import '../main_screen/main_screen.dart';

class SplashScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() =>_splashScreen();

}

class _splashScreen extends State<SplashScreen>{


  @override
  void initState() {
    if(FirebaseAuth.instance.currentUser!=null){
      String userId = FirebaseAuth.instance.currentUser!.uid.toString();
      var ref = FirebaseDatabase.instance.ref("users").child(userId);
      ref.get().then((value) {
        if(value.exists){
          Map user = value.value as Map;
          int score = user["score"];
          if(score>0){
            if(mounted)
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
            => MainScreen(),)
              , (route) => false,);
          }else{
            if(mounted)
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)
              => QuestionsScreen(),)
                , (route) => false,);
          }
        }else{
          FirebaseAuth.instance.signOut();
          print("User");
        }
      },);
    }else{
       Future(() {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>
             Login(),));
       },);

    }

    // Timer(Duration(seconds: 5), () {
    //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
    // },);
    super.initState();
  }


  @override
  void dispose() {

    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body: Stack(
        children: [

          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Image.asset("assets/images/logo.png"),
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}