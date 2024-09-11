import 'dart:io';

import 'package:achievement_view/achievement_view.dart';
import 'package:appbabyshophub/Constants/Colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:appbabyshophub/Authentication/Login.dart';
import 'package:appbabyshophub/Widgets/Custom_TextField.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  final nameController=TextEditingController();
  final emailController=TextEditingController();
  final passwordController=TextEditingController();
  final addressController=TextEditingController();
  final phoneController=TextEditingController();
  String? selectedPayment = 'JazzCash';

  File? pImage;
  Uint8List? webImg;
  bool isLoading = false;

  void productImage() async {
    setState(() {
      isLoading = true;
    });
    if (kIsWeb) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('Product_Images')
          .child(Uuid().v4())
          .putData(webImg!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      addInfo(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    } else {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProductImage')
          .child(Uuid().v4())
          .putFile(pImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      addInfo(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    }
    setState(() {
      isLoading = false;
    });
  }

  void addInfo(String imageUrl) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text);

    Map<String, dynamic> data = {
      'name': nameController.text.toString(),
      'email': emailController.text.toString(),
      'address': addressController.text.toString(),
      'phone': phoneController.text.toString(),
      'payment': selectedPayment,


      'id': Uuid().v1(),
      'image': imageUrl
    };
    FirebaseFirestore.instance.collection('usersinfo').add(data);
  }


  @override
  Widget build(BuildContext context) {
    double screenWidth=MediaQuery.of(context).size.width;
    double screenHeight=MediaQuery.of(context).size.height;

    // void UserSignUp() async
    // {
    //   // await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //   //     email: emailController.text.toString(),
    //   //     password: passwordController.text.toString());
    //   // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SignUp Successfully')));
    //   // print('end');
    //
    //   try
    //   {
    //     // print('SignUp');
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //         email: emailController.text.toString(),
    //         password: passwordController.text.toString());
    //     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('SignUp Successfully')));
    //     AchievementView(
    //         title: 'Account Create Successfully',
    //         color: Colors.green,
    //         icon: Icon(Icons.emoji_emotions,color: Colors.white,)
    //     ).show(context);
    //     Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
    //   }
    //
    //   on FirebaseAuthException catch(e)
    //   {
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.code.toString())));
    //   }
    //
    // }

    return Scaffold(
      backgroundColor: bgColorThree,
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth*0.05),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('SignUp',style: GoogleFonts.poppins(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colorthree
                ),),
                SizedBox(
                  height: screenHeight*0.02,
                ),
                GestureDetector(
                  onTap: () async {
                    if (kIsWeb) {
                      XFile? pickImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickImage != null) {
                        var convertedFile = await pickImage.readAsBytes();
                        setState(() {
                          webImg = convertedFile;
                        });
                      }
                    } else {
                      XFile? pickImage = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (pickImage != null) {
                        File convertedFile = File(pickImage.path);
                        setState(() {
                          pImage = convertedFile;
                        });
                      }
                    }
                  },
                  child: kIsWeb
                      ? CircleAvatar(
                    radius: 65,
                    backgroundImage:
                    webImg != null ? MemoryImage(webImg!) : null,
                    backgroundColor: Colors.green.shade100,
                    child: Icon(Icons.camera),
                  )
                      : CircleAvatar(
                    radius: 65,
                    backgroundImage:
                    pImage != null ? FileImage(pImage!) : null,
                    child: Icon(Icons.camera),
                  ),
                ),
                SizedBox(
                  height: screenHeight*0.02,
                ),

                Form(child: Column(
                  children: [
                    CustomTextField(controller1: nameController,
                        hintText: "Enter Your User Name",
                        label: 'User Name',
                        icon: Icons.supervised_user_circle),
                    SizedBox(
                      height: screenHeight*0.02,
                    ),
                    CustomTextField(controller1: emailController,
                        hintText: "Enter Your Email",
                        label: 'Email',
                        icon: Icons.email),
                    SizedBox(
                      height: screenHeight*0.02,
                    ),
                    CustomTextField(controller1: passwordController,
                        isShow: true,
                        hintText: "Enter Your Password",
                        label: 'Password',
                        icon: Icons.password),
                    SizedBox(
                      height: screenHeight*0.02,
                    ),
                    CustomTextField(controller1: addressController,
                        hintText: "Enter Your Address",
                        label: 'Address',
                        icon: Icons.home),
                    SizedBox(
                      height: screenHeight*0.02,
                    ),

                    DropdownButtonFormField(
                      value: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      items: [
                        'JazzCash',
                        'EasyPaisa',
                        'GooglePay',
                        'SadaPay',
                        'Paypal'
                      ].map((String v1) {
                        return DropdownMenuItem(
                          child: Text(v1),
                          value: v1,
                        );
                      }).toList(),
                      decoration: InputDecoration(

                        border: OutlineInputBorder(

                        ),
                      ),
                    ),

                    SizedBox(
                      height: screenHeight*0.02,
                    ),
                    CustomTextField(controller1: phoneController,
                        // isShow: true,
                        hintText: "Enter Your Phone Number",
                        label: 'Phone Number',
                        icon: Icons.phone),
                    SizedBox(
                      height: screenHeight*0.03,
                    ),
                    SizedBox(
                      height: 50,
                      width: 450,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colorthree
                          ),
                          onPressed: (){
                            productImage();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                          }, child: Text('SignUp',style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 22,
                      ),)),
                    ),
                    SizedBox(
                      height: screenHeight*0.02,
                    ),
                    TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(),));
                    }, child: Text('Account Create| Sign In',style: TextStyle(
                        color: txtColorone
                    ),))
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
