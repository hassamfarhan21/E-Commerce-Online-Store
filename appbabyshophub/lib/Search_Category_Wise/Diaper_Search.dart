import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Categories_detailed_description/categories_detaile_description.dart';

class DiaperSearch extends StatefulWidget {
  const DiaperSearch({super.key});

  @override
  State<DiaperSearch> createState() => _DiaperSearchState();
}

class _DiaperSearchState extends State<DiaperSearch> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diapers Category',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[500],
        // elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          padding: EdgeInsets.only(
              left: 15.0), // Adjust the padding to make it more attractive
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: Text(
              'Category 4: Diapers',
              style: TextStyle(
                  fontSize: 27,
                  color: Colors.blue[500],
                  fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            height: 280,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('DiapersData')
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
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        var ProductName =
                        snapshot.data!.docs[index]['productName'];
                        var productPrice =
                        snapshot.data!.docs[index]['productPrice'];
                        // var ProductDescription =
                        //     snapshot.data!.docs[index]['productDescription'];
                        var ProductInformation =
                        snapshot.data!.docs[index]['productInformation'];
                        String ProductImage =
                        snapshot.data!.docs[index]['image'];

                        // For accessing particular id  in firestore datbase

                        //  var data_id1 = snapshot.data!.docs[index].id;  // it  access collection id

                        // it  access document id
                        var data_id1 = snapshot.data!.docs[index]['id'];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoriesDetailedPage(
                                              pid: data_id1,
                                              productName1:  ProductName,
                                              productPrice1: productPrice,
                                              productImage1: ProductImage,
                                            ),
                                      ));
                                },
                                child: Card(
                                  shadowColor: Colors.grey[600],
                                  child: Container(
                                    height: 240,
                                    width: 210,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                            height: 150,
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(6.0),
                                              child: Image.network(
                                                '${ProductImage}',
                                                fit: BoxFit.cover,
                                              ),
                                            )),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            'Product Name: ${ProductName}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            'Product Info: ${ProductInformation}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(
                                            'Product Price: ${productPrice} Rs.',
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15),
                                          ),
                                        ),
                                      ],
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
                    child: Container(
                      child: Text('There is no Data Found'),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}