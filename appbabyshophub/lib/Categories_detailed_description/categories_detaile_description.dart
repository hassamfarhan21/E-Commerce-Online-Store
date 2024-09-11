import 'dart:io';
import 'package:appbabyshophub/Categories_detailed_description/ratingbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../UserScreens/Home.dart'; // Import rxdart

class CategoriesDetailedPage extends StatefulWidget {

  final String pid;
  final String productName1;
  final String productImage1;
  final String productPrice1;
  CategoriesDetailedPage({required this.pid, required this.productName1,required this.productPrice1,
    required this.productImage1});

  @override
  State<CategoriesDetailedPage> createState() => _CategoriesDetailedPageState();
}

class _CategoriesDetailedPageState extends State<CategoriesDetailedPage> {

  final reviewController=TextEditingController();
  bool isLoading = false;

  double _currentRating = 2; // Track the current rating

  // Function to merge streams from multiple collections
  Stream<List<QuerySnapshot>> _mergeStreams() {
    Stream<QuerySnapshot> toysStream = FirebaseFirestore.instance
        .collection('ToysData')
        .where('id', isEqualTo: widget.pid)
        .snapshots();

    Stream<QuerySnapshot> clothingStream = FirebaseFirestore.instance
        .collection('ClothingData')
        .where('id', isEqualTo: widget.pid)
        .snapshots();

    Stream<QuerySnapshot> diapersStream = FirebaseFirestore.instance
        .collection('DiapersData')
        .where('id', isEqualTo: widget.pid)
        .snapshots();

    Stream<QuerySnapshot> foodStream = FirebaseFirestore.instance
        .collection('FoodsData')
        .where('id', isEqualTo: widget.pid)
        .snapshots();

    return Rx.combineLatest4(
      toysStream,
      clothingStream,
      diapersStream,
      foodStream,
          (QuerySnapshot toys, QuerySnapshot clothing, QuerySnapshot diapers,
          QuerySnapshot food) {
        return [toys, clothing, diapers, food];
      },
    );
  }


  void ReviewsAdd() async {
    Map<String, dynamic> data = {
      'pid': widget.pid.toString(),
      'productName': widget.productName1,
      'Review': reviewController.text.toString(),
    };
    FirebaseFirestore.instance.collection('ReviwsData').add(data);
  }

  String user_id = '';

  Future getUserEmail() async {
    SharedPreferences userCred = await SharedPreferences.getInstance();
    var Uemail = userCred.getString("email");
    return Uemail;
  }

  @override
  void initState() {
    // TODO: implement initState
    getUserEmail().then((value) {
      setState(() {
        user_id = value;
      });
      print('${user_id}');
    });
    super.initState();
  }

  void AddtoCart() async {
    Map<String, dynamic> data = {
      'pid': widget.pid.toString(),
      'userID': user_id,
      'count': 1,
      'total_price': widget.productPrice1 * 1,
      'productName': widget.productName1,
      'productPrice': widget.productPrice1,
      'productImage': widget.productImage1,
    };
    FirebaseFirestore.instance.collection('AddtoCartData').add(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully Add the Item'.toString())));
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => home(),
        ));
  }


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
        title: Text(
          "Categories Detail Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[500],
      ),
      body: StreamBuilder<List<QuerySnapshot>>(
        stream: _mergeStreams(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.hasData) {
            // Combine all documents from different collections
            List<DocumentSnapshot> allDocs = [];
            for (var querySnapshot in snapshot.data!) {
              allDocs.addAll(querySnapshot.docs);
            }

            if (allDocs.isEmpty) {
              return Center(child: Text('There is no Data Found'));
            }

            return ListView.builder(
              itemCount: allDocs.length,
              itemBuilder: (context, index) {
                var productData = allDocs[index];
                var productName = productData['productName'];
                var productPrice = productData['productPrice'];
                var productDescription = productData['productDescription'];
                var productInformation = productData['productInformation'];
                String productImage = productData['image'];

                return Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 350,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.0),
                          child: Image.network(
                            productImage,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      RatingSection(
                        currentRating: _currentRating,
                        onRatingUpdate: (rating) {
                          setState(() {
                            _currentRating = rating;
                          });
                        },
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Product Name: $productName',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Product Information: $productInformation',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Product Price: $productPrice Rs.',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.red),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Product Description: $productDescription',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: TextFormField(
                          controller: reviewController,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[200],
                            filled: true,
                            hintText: "Kindly Drop your Review here...",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontFamily: "Metropolis",
                              fontSize: 15,
                            ),
                            prefixIcon: Icon(Icons.reviews),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(255, 66, 164, 244)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: const Color.fromARGB(253, 238, 238, 238)),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          height: 55,
                          width: double.infinity,
                          child: ElevatedButton(
                            child: isLoading
                                ? CircularProgressIndicator()
                                : Text(
                              "Add to Cart",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontFamily: 'Metropolis'),
                            ),
                            onPressed: () {
                              setState(() {
                                isLoading = true;
                                ReviewsAdd();
                                AddtoCart();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => home(),));
                              });
                              // Add to Cart functionality here
                              // After processing, reset isLoading to false
                              setState(() {
                                isLoading = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[500],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(
            child: Text('There is no Data Found'),
          );
        },
      ),
    );
  }
}