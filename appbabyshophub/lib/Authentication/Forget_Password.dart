import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbabyshophub/Authentication/Login.dart';

import '../Constants/Colors.dart';
class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColorThree,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                  radius: 50,
                  backgroundColor: txtColortwo,
                  child: Image.asset('assets/BabyShopHub1.png',height: 150,width: 150,)),
              Text('Forget Password',style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colorthree
              ),),
              SizedBox(height: 20,),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Email'),
                  hintText: 'Enter Your Email',
                  // floatingLabelBehavior: FloatingLabelBehavior.never
                ),
              ),
              SizedBox(height: 30,),
              SizedBox(
                height: 40,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colorthree
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
                    }, child: Text(
                  'Forget Password',style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 22
                ),
                )),
              ),
              TextButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
              }, child: Text('Click to Login',style: TextStyle(
                  color: txtColorone
              ),)),

              // SizedBox(height: 20,),

              // RatingBar.builder(
              //   initialRating: 0,
              //   minRating: 1,
              //   direction: Axis.horizontal,
              //   allowHalfRating: true,
              //   itemCount: 5,
              //   itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              //   itemBuilder: (context, _) => Icon(
              //     Icons.star,
              //     color: Colors.amber,
              //   ),
              //   onRatingUpdate: (rating) {
              //     print(rating);
              //   },
              // )
            ],
          ),
        ),
      ),
    );
  }
}
