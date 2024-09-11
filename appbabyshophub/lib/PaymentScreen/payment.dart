import 'package:appbabyshophub/PaymentScreen/success.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  final String pid2;
  final String productName2;
  final String productImage2;
  final int productTotalPrice2;
  final String USERID2;
  final int Count2;

  CheckOut(
      {required this.pid2,
        required this.productName2,
        required this.productTotalPrice2,
        required this.productImage2,
        required this.USERID2,
        required this.Count2});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {

  void AddtoOrder() async {
    Map<String, dynamic> data = {
      'pid': widget.pid2.toString(),
      'userID': widget.USERID2.toString(),
      'total_price': widget.productTotalPrice2,
      'productName': widget.productName2,
      'productImage': widget.productImage2,
      'productQuantity': widget.Count2,
    };
    FirebaseFirestore.instance.collection('AddOrderData').add(data);
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Successfully Submit the Order'.toString())));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          'Checkout',
          style: TextStyle(color: Colors.white, fontSize: 29),
        ),
        centerTitle: true,
        foregroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping address',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                height: 108,
                decoration: BoxDecoration(
                  color: Color(0xff2A2C36),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Muhammad Shujauddin',
                            style: TextStyle(color: Colors.white),
                          ),
                          InkWell(
                            onTap: () {},
                            child: Text(
                              'Change',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '3 Newbridge Court\nChino Hills, CA 91709, United States',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment',
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(
                    width: 80,
                    height: 25,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 1,
                        backgroundColor: Colors.blue,
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true, // Allows content to scroll within the sheet
                          builder: (BuildContext context) {
                            return Container(
                              height: 450,
                              width: double.infinity,
                              color: Colors.black,
                              padding: EdgeInsets.all(15),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      'Add New Card',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2A2C36),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    height: 60,
                                    width: double.infinity,
                                    child: ListTile(
                                      title: Text(
                                        'Name on card',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2A2C36),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    height: 60,
                                    width: double.infinity,
                                    child: ListTile(
                                      title: Text(
                                        'Card Number',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '5546 8205 3693 3947',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: Image.asset('assets/card.png'),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2A2C36),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    height: 60,
                                    width: double.infinity,
                                    child: ListTile(
                                      title: Text(
                                        'Expire date',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '523',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xff2A2C36),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    height: 60,
                                    width: double.infinity,
                                    child: ListTile(
                                      title: Text(
                                        'CVV',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      subtitle: Text(
                                        '567',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      trailing: const Icon(
                                        Icons.question_mark_rounded,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  SizedBox(
                                    width: 343,
                                    height: 45,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                        side: BorderSide(color: Colors.white, width: 2),
                                      ),
                                      onPressed: () {},
                                      child: Text(
                                        'Done Account Details',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: Text(
                        'ADD',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Image.asset('assets/card.png'),
                  Text(
                    '3947',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Delivery method',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset('assets/fedex.png'),
                    Image.asset('assets/usps.png'),
                    Image.asset('assets/dhl.png'),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '112\$',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Delivery',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '15\$',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Summary',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '127\$',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  width: 343,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 1,
                      backgroundColor: Colors.blue,
                      side: BorderSide(color: Colors.white, width: 2),
                    ),
                    onPressed: () {
                      AddtoOrder();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) {
                            return SuccessfulScreen();
                          },
                        ),
                      );
                    },
                    child: Text(
                      'SUBMIT ORDER',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
