import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../AddtoCaert_Screen/AddtoCart.dart';
import '../Authentication/Login.dart';
import '../Categories_detailed_description/categories_detaile_description.dart';
import '../Order/orderHistory.dart';
import '../Reviews_Screen/Review_screen.dart';
import '../Search_Category_Wise/Clothing_Search.dart';
import '../Search_Category_Wise/Diaper_Search.dart';
import '../Search_Category_Wise/Food_Search.dart';
import '../Search_Category_Wise/Toy_Searh.dart';
import 'UpdateCurrentUser.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  String user_id = '';
  String search='';

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
      // print('${user_id}');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('user email: $user_id');
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
                      builder: (context) => AddtoCart(),
                    ));
              },
              child: Icon(
                Icons.shopping_cart,
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
                      builder: (context) => OrderHistory(),
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
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ReviewScreen(),));

                },
                child: Icon(Icons.reviews,color: Colors.white,)),
          ),
        ],
        title: Text(
          "Home Page",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[500],

      ),
      drawer: Drawer(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('usersinfo')
              .where("email", isEqualTo: user_id)
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
                  var Address = snapshot.data!.docs[index]['address'];
                  var Phone = snapshot.data!.docs[index]['phone'];
                  var Payment = snapshot.data!.docs[index]['payment'];
                  String pImage = snapshot.data!.docs[index]['image'];

                  // For accessing particular id  in firestore datbase

                  var data_id = snapshot.data!.docs[index].id;
                  return Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 80,
                        child: const DrawerHeader(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                          child: Text(
                            'User Profile',
                            style: TextStyle(color: Colors.white, fontSize: 30),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage('${snapshot.data!.docs[index]['image']}'),
                        radius: 70,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        // leading: Icon(Icons.),
                        title: Text(
                          '${snapshot.data!.docs[index]['name']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.delivery_dining_outlined,
                          color: Colors.red[500],
                        ),
                        title: Text(
                          '${snapshot.data!.docs[index]['address']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: Colors.green,
                        ),
                        title: Text(
                          '${snapshot.data!.docs[index]['phone']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        leading: Icon(
                          Icons.payment,
                          color: Colors.amber,
                        ),
                        title: Text(
                          '${snapshot.data!.docs[index]['payment']}',
                          style: TextStyle(color: Colors.black),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                      Container(
                        height: 34,
                        margin:
                        EdgeInsets.symmetric(horizontal: 36, vertical: 40),
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
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => update_current_User(
                                      id1: data_id,
                                      name1: Name,
                                     address1: Address,
                                     phone_number1: Phone,
                                     img1: pImage,
                                     payment_method1: Payment,
                                  ),
                                ));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                      Text('Update User Profile'),
                    ],
                  );
                },
              );
            }
            return Center(
              child: Container(
                child: Text('There is no Data Found'),
              ),
            );
          },
        ),
      ),

      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextFormField(
                onChanged: (value) {
                  setState(() {
                    search = value;
                  });
                },
                decoration: InputDecoration(
                  fillColor: Colors.grey[200],
                  filled: true,
                  hintText: "Search here...",
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontFamily: "Metropolis",
                    fontSize: 15,
                  ),
                  prefixIcon: Icon(Icons.search),
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
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ToySearch()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Toys',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ClothingSearch()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Clothing',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FoodSearch()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Food',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DiaperSearch()));
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        height: 30,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            'Diapers',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                'Category 1: Toys',
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.blue[500],
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 280,
              child: StreamBuilder(
                  stream: search == ''
                      ? FirebaseFirestore.instance
                      .collection('ToysData')
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('ToysData')
                      .where('productName', isGreaterThanOrEqualTo: search)
                      .where('productName',
                      isLessThanOrEqualTo: '${search!}\uf8ff')
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
                                                productName1: ProductName,
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
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                'Category 2: Clothing',
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.blue[500],
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 280,
              child: StreamBuilder(
                  stream: search == ''
                      ? FirebaseFirestore.instance
                      .collection('ClothingData')
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('ClothingData')
                      .where('productName', isGreaterThanOrEqualTo: search)
                      .where('productName',
                      isLessThanOrEqualTo: '${search!}\uf8ff')
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
                          var ProductName2 =
                          snapshot.data!.docs[index]['productName'];
                          var productPrice2 =
                          snapshot.data!.docs[index]['productPrice'];
                          // var ProductDescription =
                          //     snapshot.data!.docs[index]['productDescription'];
                          var ProductInformation2 =
                          snapshot.data!.docs[index]['productInformation'];
                          String ProductImage2 =
                          snapshot.data!.docs[index]['image'];

                          // For accessing particular id  in firestore datbase

                          var data_id2 = snapshot.data!.docs[index]['id'];
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
                                                pid: data_id2,
                                                productName1: ProductName2,
                                                productPrice1: productPrice2,
                                                productImage1: ProductImage2,
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
                                                  '${ProductImage2}',
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
                                              'Product Name: ${ProductName2}',
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
                                              'Product Info: ${ProductInformation2}',
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
                                              'Product Price: ${productPrice2} Rs.',
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
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                'Category 3: Food',
                style: TextStyle(
                    fontSize: 27,
                    color: Colors.blue[500],
                    fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 280,
              child: StreamBuilder(
                  stream: search == ''
                      ? FirebaseFirestore.instance
                      .collection('FoodsData')
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('FoodsData')
                      .where('productName', isGreaterThanOrEqualTo: search)
                      .where('productName',
                      isLessThanOrEqualTo: '${search!}\uf8ff')
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
                          var ProductName3 =
                          snapshot.data!.docs[index]['productName'];
                          var productPrice3 =
                          snapshot.data!.docs[index]['productPrice'];
                          // var ProductDescription =
                          //     snapshot.data!.docs[index]['productDescription'];
                          var ProductInformation3 =
                          snapshot.data!.docs[index]['productInformation'];
                          String ProductImage3 =
                          snapshot.data!.docs[index]['image'];

                          // For accessing particular id  in firestore datbase

                          var data_id3 = snapshot.data!.docs[index]['id'];
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
                                                pid: data_id3,
                                                productName1: ProductName3,
                                                productPrice1: productPrice3,
                                                productImage1: ProductImage3,
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
                                                  '${ProductImage3}',
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
                                              'Product Name: ${ProductName3}',
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
                                              'Product Info: ${ProductInformation3}',
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
                                              'Product Price: ${productPrice3} Rs.',
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
            SizedBox(
              height: 20,
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
                  stream: search == ''
                      ? FirebaseFirestore.instance
                      .collection('DiapersData')
                      .snapshots()
                      : FirebaseFirestore.instance
                      .collection('DiapersData')
                      .where('productName', isGreaterThanOrEqualTo: search)
                      .where('productName',
                      isLessThanOrEqualTo: '${search!}\uf8ff')
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
                          var ProductName4 =
                          snapshot.data!.docs[index]['productName'];
                          var productPrice4 =
                          snapshot.data!.docs[index]['productPrice'];
                          // var ProductDescription =
                          //     snapshot.data!.docs[index]['productDescription'];
                          var ProductInformation4 =
                          snapshot.data!.docs[index]['productInformation'];
                          String ProductImage4 =
                          snapshot.data!.docs[index]['image'];

                          // For accessing particular id  in firestore datbase

                          var data_id4 = snapshot.data!.docs[index]['id'];
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
                                                pid: data_id4,
                                                productName1: ProductName4,
                                                productPrice1: productPrice4,
                                                productImage1: ProductImage4,
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
                                                  '${ProductImage4}',
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
                                              'Product Name: ${ProductName4}',
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
                                              'Product Info: ${ProductInformation4}',
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
                                              'Product Price: ${productPrice4} Rs.',
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
      ),

    );
  }
}