import 'dart:async';
import 'package:appbabyshophub/Constants/Colors.dart';
import 'package:flutter/material.dart';
import 'package:appbabyshophub/UserScreens/Home.dart';
import 'package:appbabyshophub/Authentication/Login.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  Future getUser() async {
    //   Using Shared Prefrenes
    SharedPreferences userCred = await SharedPreferences.getInstance();
    var userEmail = userCred.getString("email");
    debugPrint('user Email: $userEmail');
    return userEmail;
  }

  @override
  void initState() {
    getUser().then((value) => {
      if (value != null)
        {
          // Mean  3_Second
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => home()));
          })
        }
      else
        {
          Timer(const Duration(milliseconds: 3000), () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginScreen()));
          })
        }
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorThree,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: 300,
                width: 400,
                child: Lottie.asset('assets/animations/baby.json',repeat: true,reverse: true),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Text("BabyShopHub",style: TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.bold,
              fontSize: 33,
            ),),
          ],
        ),
      ),
    );
  }
}
