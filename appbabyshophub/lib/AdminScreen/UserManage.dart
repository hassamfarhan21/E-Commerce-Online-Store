import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authentication/Login.dart';
import '../Categories/clothing.dart';
import '../Categories/clothing_fetchScreen.dart';
import '../Categories/diapers.dart';
import '../Categories/diapers_fetch.dart';
import '../Categories/foods.dart';
import '../Categories/foods_fatchscreen.dart';
import '../Categories/toys.dart';
import '../Categories/toys_fatchScreen.dart';
import '../PaymentScreen/Support.dart';
import '../Reviews_Screen/Review_screen.dart';
import 'admin_orderHistory.dart';

class users_manage extends StatefulWidget {
  const users_manage({super.key});

  @override
  State<users_manage> createState() => _users_manageState();
}

class _users_manageState extends State<users_manage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
      // Do nothing or navigate to the current screen
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Clothing_fetch()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => diapers_fatch()),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => foods_fetch()),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => toys_fetch()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
              icon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
            );
          },
        ),
        actions: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Admin_OrderHistory(),
                    ));
              },
              child: Icon(
                Icons.shopify,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SupportScreen(),
                    ));
              },
              child: Icon(
                Icons.support,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(),));

                },
                child: Icon(Icons.reviews,color: Colors.white,)),
          ),
        ],

        title: Text("Users Manage Page", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: 80,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.orange,
                ),
                child: Text(
                  'Categories',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28),
                ),
              ),
            ),
            ListTile(
              title: const Text(
                'Baby Clothing',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => clothing()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Baby Toys',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => toys()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Baby Diapers',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => diapers()),
                );
              },
            ),
            ListTile(
              title: const Text(
                'Baby Foods',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => foods()),
                );
              },
            ),
            Container(
              height: 34,
              margin: EdgeInsets.symmetric(horizontal: 36, vertical: 40),
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "Logout",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: 'Metropolis'),
                ),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(),
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: CurvedNavigationBar(
          backgroundColor: Colors.white,
          color: Colors.orange,
          animationDuration: Duration(milliseconds: 300),
          index: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            Icon(Icons.person, color: Colors.white),
            Icon(Icons.outlet, color: Colors.white),
            Icon(Icons.baby_changing_station, color: Colors.white),
            Icon(Icons.food_bank, color: Colors.white),
            Icon(Icons.toys, color: Colors.white),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('usersinfo')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (ConnectionState.waiting == snapshot.connectionState) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error'));
                    }

                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            var Name = snapshot.data!.docs[index]['name'];
                            var Email = snapshot.data!.docs[index]['email'];
                            var Address = snapshot.data!.docs[index]['address'];
                            var Phone = snapshot.data!.docs[index]['phone'];
                            var Payment = snapshot.data!.docs[index]['payment'];

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 2),
                              child: Card(
                                shadowColor: Colors.grey[600],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text('User Name : $Name'),
                                          Text('User Email : $Email'),
                                          Text('User Address : $Address'),
                                          Text('User Phone Number : $Phone'),
                                          Text(
                                              'User Payment Method : $Payment'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    }
                    return Center(
                      child: Container(
                        child: Text('There is no Data Found'),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
