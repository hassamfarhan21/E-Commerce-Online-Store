import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  String user_id = '';

  Future getUserEmail() async {
    SharedPreferences userCred = await SharedPreferences.getInstance();
    var Uemail = userCred.getString("email");
    return Uemail;
  }

  @override
  void initState() {
    getUserEmail().then((value) {
      setState(() {
        user_id = value!;
      });
      print('${user_id}');
    });
    super.initState();
  }

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
        backgroundColor: Colors.blue,
        title: Text(
          "Orders History",
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
                    .where('userID', isEqualTo: user_id)
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