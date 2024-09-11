import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Authentication/Login.dart';
import '../Categories/clothing.dart';
import '../Categories/diapers.dart';
import '../Categories/foods.dart';
import '../Categories/toys.dart';
import 'Update_clothing.dart';

class Clothing_fetch extends StatefulWidget {
  const Clothing_fetch({super.key});

  @override
  State<Clothing_fetch> createState() => _Clothing_fetchState();
}

class _Clothing_fetchState extends State<Clothing_fetch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clothing Fetch Page", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          padding: EdgeInsets.only(left: 15.0),
        ),
      ),

      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.only(top: 12),
      //   child: CurvedNavigationBar(
      //     // Custom Curve Navigation Bar
      //     backgroundColor: Colors.white,
      //     color: Colors.pink,
      //     animationDuration: Duration(milliseconds: 300),
      //     onTap: (index) {
      //       switch (index) {
      //         case 0:
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => clothing()),
      //         // );
      //           break;
      //         case 1:
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => diapers()),
      //         // );
      //           break;
      //         case 2:
      //         // Navigator.push(
      //         //   context,
      //         //   MaterialPageRoute(builder: (context) => users_manage()),
      //         // );
      //           break;
      //       }
      //     },
      //     items: [
      //       Icon(Icons.search),
      //       Icon(Icons.home),
      //       Icon(Icons.person),
      //       // Icon(Icons.person),
      //       // Icon(Icons.person),
      //     ],
      //   ),
      // ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('ClothingData')
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
                            var ProductName = snapshot.data!.docs[index]['productName'];
                            var ProductPrie = snapshot.data!.docs[index]['productPrice'];
                            var ProductDescription = snapshot.data!.docs[index]['productDescription'];
                            var ProductInfo = snapshot.data!.docs[index]['productInformation'];
                            var ProductImage = snapshot.data!.docs[index]['image'];

                            // For accessing particular id  in firestore datbase

                            var data_id = snapshot.data!.docs[index].id;

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
                                      Container(
                                        height: 110,
                                        width: 95,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                        ),
                                        // color: Colors.orange,
                                        child: Image.network('${ProductImage}',fit: BoxFit.cover,),
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          // Text('User Payment Method : $Payment'),
                                          Text('Product Name : $ProductName'),
                                          Text('Product Price : $ProductPrie'),
                                          Text('Product Information : $ProductInfo'),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          IconButton(onPressed: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context) => update_clothing(
                                              Productname1: ProductName,
                                              id1: data_id,
                                              ProductPrice1: ProductPrie,
                                              ProductInfo1: ProductInfo,
                                              img1: ProductImage,
                                              ProductDescription1: ProductDescription,
                                            ),));
                                          }, icon: Icon(Icons.edit,color: Colors.blue,)),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 10.0),
                                            child: IconButton(onPressed: (){
                                              FirebaseFirestore.instance.collection('ClothingData').doc(data_id).delete();
                                              ScaffoldMessenger.of(context)
                                                            .showSnackBar(SnackBar(
                                                                content: Text(
                                                                    "Delete Successfully")));
                                            }, icon: Icon(Icons.delete,color: Colors.red,)),
                                          ),
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