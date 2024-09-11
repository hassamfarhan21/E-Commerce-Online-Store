import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PaymentScreen/payment.dart';

class AddtoCart extends StatefulWidget {
  const AddtoCart({super.key});

  @override
  State<AddtoCart> createState() => _AddtoCartState();
}

class _AddtoCartState extends State<AddtoCart> {
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

  double totalPrice = 0.0;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text("Add To Cart Screen", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          padding: EdgeInsets.only(left: 15.0),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('AddtoCartData')
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
                        var ProductPrice1 =
                        snapshot.data!.docs[index]['productPrice'];
                        var ProductImage =
                        snapshot.data!.docs[index]['productImage'];
                        int pCount = snapshot.data!.docs[index]['count'];

                        var data_id = snapshot.data!.docs[index].id;
                        int productPrice = int.parse(ProductPrice1);

                        int TotalPrice = productPrice * pCount;

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
                                          'Name : $ProductName'),
                                      Text(
                                        'Price : ${TotalPrice} Rs',
                                        style:
                                        TextStyle(color: Colors.red),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                bottom: 15),
                                            child: IconButton(
                                              onPressed: () async {
                                                if (pCount > 1) {
                                                  setState(() {
                                                    pCount--;
                                                  });
                                                  await FirebaseFirestore
                                                      .instance
                                                      .collection(
                                                      'AddtoCartData')
                                                      .doc(data_id)
                                                      .update({
                                                    'count': pCount,
                                                    'total_price':
                                                    productPrice *
                                                        pCount
                                                  });
                                                }
                                              },
                                              icon: Icon(Icons.minimize),
                                            ),
                                          ),
                                          Text('$pCount'),
                                          IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                pCount++;
                                              });
                                              await FirebaseFirestore
                                                  .instance
                                                  .collection(
                                                  'AddtoCartData')
                                                  .doc(data_id)
                                                  .update({
                                                'count': pCount,
                                                'total_price':
                                                productPrice * pCount
                                              });
                                            },
                                            icon: Icon(Icons.add),
                                          ),
                                        ],
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
                                            "Payment",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily:
                                                'Metropolis'),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckOut(
                                                        pid2: data_id,
                                                        productName2:
                                                        ProductName,
                                                        productImage2:
                                                        ProductImage,
                                                        USERID2: user_id,
                                                        productTotalPrice2:
                                                        TotalPrice,
                                                        Count2: pCount,
                                                      )),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 10.0),
                                        child: IconButton(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection(
                                                'AddtoCartData')
                                                .doc(data_id)
                                                .delete();
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      "Deleted Successfully")),
                                            );
                                          },
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
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