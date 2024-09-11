import 'dart:io';
import 'package:appbabyshophub/AdminScreen/UserManage.dart';
import 'package:appbabyshophub/Constants/Colors.dart';
import 'package:appbabyshophub/UserScreens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


class update_Toys extends StatefulWidget {
  String id1;
  String Productname1;
  String ProductPrice1;
  String ProductInfo1;
  String ProductDescription1;
  String img1;

  @override
  State<update_Toys> createState() => _update_ToysState();

  update_Toys(
      {required this.id1,
        required this.Productname1,
        required this.ProductPrice1,
        required this.ProductInfo1,
        required this.ProductDescription1,
        required this.img1});
}

final _formkey = GlobalKey<FormState>();

class _update_ToysState extends State<update_Toys> {
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
      //Rawait FirebaseStorage.instance.refFromURL(widget.img1).delete();
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('Product_Images')
          .child(Uuid().v4())
          .putData(webImg!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      updateData(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    } else {
      UploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child('ProductImage')
          .child(Uuid().v4())
          .putFile(pImage!);
      TaskSnapshot taskSnapshot = await uploadTask;
      String getImageUrl = await taskSnapshot.ref.getDownloadURL();
      updateData(getImageUrl);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Data submit')));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    productNameController.text = widget.Productname1;
    productPriceController.text = widget.ProductPrice1;
    productInfoController.text = widget.ProductInfo1;
    productDescriptipnController.text = widget.ProductDescription1;
    super.initState();
  }

  void updateData(String imageUrl) async {
    Map<String, dynamic> updatedata = {
      'productName': productNameController.text.toString(),
      'productPrice': productPriceController.text.toString(),
      'productInformation': productInfoController.text.toString(),
      'productDescription': productDescriptipnController.text.toString(),
      'image': imageUrl
    };
    await FirebaseFirestore.instance
        .collection('ToysData')
        .doc(widget.id1)
        .update(updatedata);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Update Data Successfully")));

    Navigator.pop(context);
  }



  @override
  void dispose() {
    productNameController.dispose();
    productPriceController.dispose();
    productInfoController.dispose();
    productDescriptipnController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Toys Screen',style: TextStyle(color: Colors.white,fontSize: 30),),
        centerTitle: true,
        backgroundColor: Colors.orange,
        // elevation: 0,
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
            SizedBox(height: 10,),
            Container(
              height: 20,
              child: Text(
                "Please fill the details and Update Data",
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
                child: webImg != null
                    ? kIsWeb
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
                  child: Icon(Icons.camera),
                )
                    : CircleAvatar(
                  backgroundImage: NetworkImage(widget.img1),
                  radius: 65,
                )),
            SizedBox(height: 30),
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: productNameController ,
                        decoration: InputDecoration(
                          label: Text(
                            'Product Name',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Name",
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
                                color: const Color.fromARGB(253, 238, 238, 238)),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        validator: (val) {
                          if (val == null || val.isEmpty || val == " ") {
                            return " Product Name is Required";
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 15),
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
                                color: const Color.fromARGB(253, 238, 238, 238)),
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
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 15),
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
                                color: const Color.fromARGB(253, 238, 238, 238)),
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
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: productInfoController,
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
                                color: const Color.fromARGB(253, 238, 238, 238)),
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
                ],
              ),
            ),
            SizedBox(height: 9),
            Container(
              height: 55,
              margin: EdgeInsets.all(26),
              width: double.infinity,
              child: ElevatedButton(
                child: Text(
                  "Update Data",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontFamily: 'Metropolis'),
                ),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    productImage();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => users_manage(),));
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