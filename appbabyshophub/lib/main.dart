
import 'package:appbabyshophub/Authentication/SignUp.dart';
import 'package:appbabyshophub/Categories/toys_fatchScreen.dart';
import 'package:appbabyshophub/UserScreens/Home.dart';
import 'package:appbabyshophub/UserScreens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'AdminScreen/UserManage.dart';
import 'Categories/Update_clothing.dart';
import 'Categories/Update_toys.dart';
import 'Categories/clothing_fetchScreen.dart';
import 'Categories/diapers_fetch.dart';
import 'Categories/foods_fatchscreen.dart';
import 'Categories/toys.dart';
import 'PaymentScreen/Support.dart';
import 'PaymentScreen/payment.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BabyShop Hub',
      theme: ThemeData(


        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      //home: SupportScreen()
      //home: CheckOut(),
      home:SplashScreen(),
      // home: HomeScreen(),
      // home: Adminhome(),
      // home: Clothing_fetch(),
      //home: users_manage(),

    );
  }
}
