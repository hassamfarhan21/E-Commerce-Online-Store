import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Admin_OrderHistory extends StatefulWidget {
  const Admin_OrderHistory({super.key});

  @override
  State<Admin_OrderHistory> createState() => _Admin_OrderHistoryState();
}

class _Admin_OrderHistoryState extends State<Admin_OrderHistory> {
  bool isLoading = false;
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
        backgroundColor: Colors.orange,
        title: Text(
          "Admin Screen Orders History",
          style: TextStyle(color: Colors.white, fontSize: 29),
        ),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        // elevation: 0,
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AddOrderData')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error'));
                  }
                  if (snapshot.hasData) {
                    int dataLen = snapshot.data!.docs.length;
                    return dataLen > 0
                        ? ListView.builder(
                      itemCount: dataLen,
                      itemBuilder: (context, index) {
                        var ProductName =
                        snapshot.data!.docs[index]['productName'];
                        var ProductToatalPrice1 =
                        snapshot.data!.docs[index]['total_price'];
                        var ProductImage =
                        snapshot.data!.docs[index]['productImage'];
                        int productQuantity1 =
                        snapshot.data!.docs[index]['productQuantity'];

                        var Userid = snapshot.data!.docs[index]['userID'];

                        // var data_id = snapshot.data!.docs[index].id;
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
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0)),
                                    ),
                                    child: Image.network(
                                      '${ProductImage}',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        overflow: TextOverflow.ellipsis,
                                        'Name : $ProductName',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'Total Price : ${ProductToatalPrice1} Rs',
                                        style:
                                        TextStyle(color: Colors.red),
                                      ),
                                      Text(
                                        'Quantity : ${productQuantity1} ',
                                        style: TextStyle(
                                            color: Colors.black),
                                      ),
                                      Text(
                                        'User Email : ${Userid}',
                                        style:
                                        TextStyle(color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Container(
                                        child: ElevatedButton(
                                          child: isLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                            "Accept",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                'Metropolis'),
                                          ),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 9,
                                      ),
                                      Container(
                                        child: ElevatedButton(
                                          child: isLoading
                                              ? CircularProgressIndicator()
                                              : Text(
                                            "Reject",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                'Metropolis'),
                                          ),
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                        : Center(child: Text('There is no Data Found'));
                  }
                  return Center(child: Text('No Data Available'));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}