
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../UserScreens/Home.dart';

class SuccessfulScreen extends StatefulWidget {
  const SuccessfulScreen({super.key});

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
  void SwitchToHomePage() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => home()));
  }

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2), SwitchToHomePage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          padding: EdgeInsets.only(left: 15.0),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: Text(
          "Successfull Screen",
          style: TextStyle(color: Colors.white, fontSize: 29),
        ),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
            ),
            Center(
              child: RepaintBoundary(
                child: SizedBox(
                  height: 399,
                  width: double.infinity, // Adapt width to screen size
                  child: Lottie.asset(
                    'assets/animations/cart.json',
                    repeat: true,
                    reverse: true,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add spacing
            Center(
              child: Text(
                'Your order will be delivered soon',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(height: 7), // Add spacing
            Center(
              child: Text(
                'Thank you for choosing our app!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}