import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

import '../AdminScreen/UserManage.dart';

class foods extends StatefulWidget {
  const foods({super.key});

  @override
  State<foods> createState() => _foodsState();
}

class _foodsState extends State<foods> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productInfoController = TextEditingController();
  TextEditingController productDescriptipnController = TextEditingController();

  File? pImage;
  Uint8List? webImg;
  bool isLoading = false;

  void productImage() async {
    setState(() {
      isLoading = true;
    });
    if (kIsWeb) {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('Product_Foods_Images')
          .child(Uuid().v4())
          .putData(webImg!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      productAddInfo(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    } else {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProductFoodsImage')
          .child(Uuid().v4())
          .putFile(pImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      productAddInfo(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    }
    setState(() {
      isLoading = false;
    });
  }

  void productAddInfo(String imageUrl) async {
    Map<String, dynamic> data = {
      'productName': productNameController.text.toString(),
      'productPrice': productPriceController.text.toString(),
      'productDescription': productDescriptipnController.text.toString(),
      'productInformation': productInfoController.text.toString(),
      'id': Uuid().v1(),
      'image': imageUrl
    };
    FirebaseFirestore.instance.collection('FoodsData').add(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          'Foods Screen',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
          iconSize: 24,
          padding: EdgeInsets.only(left: 15.0),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(height: 30),
            Container(
              height: 20,
              child: Text(
                "Please fill the details to Adding Food Category",
                style: TextStyle(color: Colors.grey, fontFamily: "Metropolis"),
              ),
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () async {
                if (kIsWeb) {
                  XFile? pickImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickImage != null) {
                    var convertedFile = await pickImage.readAsBytes();
                    setState(() {
                      webImg = convertedFile;
                    });
                  }
                } else {
                  XFile? pickImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickImage != null) {
                    File convertedFile = File(pickImage.path);
                    setState(() {
                      pImage = convertedFile;
                    });
                  }
                }
              },
              child: kIsWeb
                  ? CircleAvatar(
                radius: 65,
                backgroundImage:
                webImg != null ? MemoryImage(webImg!) : null,
                backgroundColor: Colors.green.shade100,
              )
                  : CircleAvatar(
                radius: 65,
                backgroundImage:
                pImage != null ? FileImage(pImage!) : null,
              ),
            ),
            SizedBox(height: 10),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: productNameController,
                        decoration: InputDecoration(
                          label: Text(
                            'Product Name',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Product Name",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Metropolis",
                            fontSize: 15,
                          ),
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
                                color:
                                const Color.fromARGB(253, 238, 238, 238)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val == " ") {
                            return "Product Name is Required";
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: productPriceController,
                        decoration: InputDecoration(
                          label: Text(
                            'Product Price',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Product Price",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Metropolis",
                            fontSize: 15,
                          ),
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
                                color:
                                const Color.fromARGB(253, 238, 238, 238)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val == " ") {
                            return "Product Price is Required";
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: productDescriptipnController,
                        decoration: InputDecoration(
                          label: Text(
                            'Product Description',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Product Description",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Metropolis",
                            fontSize: 15,
                          ),
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
                                color:
                                const Color.fromARGB(253, 238, 238, 238)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val == " ") {
                            return "Product Description is Required";
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: productInfoController,
                        decoration: InputDecoration(
                          label: Text(
                            'Product Information',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Product Information",
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: "Metropolis",
                            fontSize: 15,
                          ),
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
                                color:
                                const Color.fromARGB(253, 238, 238, 238)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val == " ") {
                            return "Product Information is Required";
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 9),
            Container(
              height: 55,
              margin: EdgeInsets.all(26),
              width: double.infinity,
              child: ElevatedButton(
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                  "Add Procut Details",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: 'Metropolis'),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    productImage();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => users_manage()),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}