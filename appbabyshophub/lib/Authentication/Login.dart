import 'package:achievement_view/achievement_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbabyshophub/UserScreens/Home.dart';
import 'package:appbabyshophub/Authentication/forget_password.dart';
import 'package:appbabyshophub/Authentication/signup.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../AdminScreen/UserManage.dart';
import '../Constants/Colors.dart';
import '../Widgets/Custom_TextField.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController=TextEditingController();
  final passwordController=TextEditingController();


  bool isLoading=false;
  bool _obsecureText  = true;

  void UserLogin() async
  {
    String email = emailController.text;
    String password = passwordController.text;



    if(email == "admin@gmail.com" && password =="admin123"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => users_manage(),));
    }else{
      try
      {
        setState(() {
          isLoading=true;
          // print(isLoading);
        });
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text.toString(),
            password: passwordController.text.toString());
        // Using Shared Preferences
        SharedPreferences userCred = await SharedPreferences.getInstance();
        var uemail = userCred.setString("email", emailController.text);
        debugPrint('user EMAIL: $uemail');
        print(emailController.text);
        AchievementView(
            title: 'User Login',
            icon: Icon(Icons.emoji_events_rounded,color: Colors.white,),
            color: Colors.green
        ).show(context);
        setState(() {
          isLoading=false;
          // print(isLoading);
        });

        Navigator.push(context, MaterialPageRoute(builder: (context) => home(),));

      }

      on FirebaseAuthException catch(e)
      {
        AchievementView(
            title: e.code.toString(),
            icon: Icon(Icons.dangerous),
            color: Colors.red
        ).show(context);
        setState(() {
          isLoading=false;
        });
      }
    }


  }

  @override
  Widget build(BuildContext context) {

    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bgColorThree,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
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
              Text('Login',style: GoogleFonts.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue
              ),),
              SizedBox(
                height: screenHeight*0.02,
              ),
              Form(child: Column(
                children: [
                  CustomTextField(controller1: emailController,
                      hintText: "Enter Your Email",
                      label: 'Email',
                      icon: Icons.email),
                  SizedBox(
                    height: screenHeight*0.02,
                  ),
                  Container(
                    height: 60,
                    // color: Colors.orange,
                    child: TextFormField(
                      
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: _obsecureText,
                      decoration: InputDecoration(
                        label: Text(
                          
                          'Password', 
                          style: TextStyle(color: Colors.black),
                        ),

                        hintText: "Enter Password",
                        hintStyle: TextStyle(
                          color: Colors.black,
                          fontFamily: "Metropolis",
                          fontSize: 15,
                        ),
                        border: OutlineInputBorder(

                        ),
                        prefixIcon: Icon(Icons.password),

                        suffixIcon: IconButton(
                            icon: Icon(
                              _obsecureText
                                  ? Icons.visibility
                                  : Icons.visibility_off_outlined,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                _obsecureText = !_obsecureText;
                              });
                            }),
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty || val == " ") {
                          return "Password is Required";
                        }
                        if (val.length < 8) {
                          return "Password Length must be greater than 8 digits";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordScreen(),));
                      }, child: Text('Forget Password?',style: TextStyle(
                          color: txtColorone
                      ),))
                    ],
                  ),
                  SizedBox(
                    height: screenHeight*0.03,
                  ),
                  SizedBox(
                    height: 50,
                    width: 450,
                    child: ElevatedButton(style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),
                        onPressed: (){
                          UserLogin();
                        }, child: isLoading==true?CircularProgressIndicator():Text('Login',style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 22,
                        ),)),
                  ),
                  // child: Text('Login')),
                  SizedBox(
                    height: screenHeight*0.02,
                  ),
                  TextButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => signup(),));
                  }, child: Text('Register Account | Sign Up',style: TextStyle(
                      color: txtColorone
                  ),))
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
