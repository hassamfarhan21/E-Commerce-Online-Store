import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          "Support Screen",
          style: TextStyle(color: Colors.white, fontSize: 29),
        ),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: Column(
        children: [
          Center(
            child: Container(
              height: 500,
              width: 600,
              child: Lottie.asset('assets/animations/support.json',repeat: true,reverse: true),
            ),
          ),
          Center(
            child: Text('User Support',style: TextStyle(color: Colors.purple[400],fontSize: 30,),),
          ),Center(
            child: Text('Baby Shop App',style: TextStyle(color: Colors.orange,fontSize: 40,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    );
  }
}
