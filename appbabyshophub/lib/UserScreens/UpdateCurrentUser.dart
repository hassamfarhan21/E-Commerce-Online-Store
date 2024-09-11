import 'dart:io';
import 'package:appbabyshophub/Constants/Colors.dart';
import 'package:appbabyshophub/UserScreens/Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class update_current_User extends StatefulWidget {
  String id1;
  String name1;
  String address1;
  String phone_number1;
  String payment_method1;
  String img1;

  @override
  State<update_current_User> createState() => _update_current_UserState();

  update_current_User(
      {required this.id1,
        required this.name1,
        required this.address1,
        required this.phone_number1,
        required this.payment_method1,
        required this.img1});
}

final _formkey = GlobalKey<FormState>();

class _update_current_UserState extends State<update_current_User> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  String? selectedPayment = 'JazzCash';

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
    nameController.text = widget.name1;
    addressController.text = widget.address1;
    phoneController.text = widget.phone_number1;
    selectedPayment = widget.payment_method1;
    super.initState();
  }

  void updateData(String imageUrl) async {
    Map<String, dynamic> updatedata = {
      'name': nameController.text.toString(),
      'address': addressController.text.toString(),
      'phone': phoneController.text.toString(),
      'payment': selectedPayment,
      'image': imageUrl
    };
    await FirebaseFirestore.instance
        .collection('usersinfo')
        .doc(widget.id1)
        .update(updatedata);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Update Data Successfully")));

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
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
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 1),
                height: 50,
                child: Text(
                  "Update Current User",
                  style: TextStyle(fontSize: 32, fontFamily: 'Libre'),
                ),
              ),
            ),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          label: Text(
                            'Name',
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
                            return "Name is Required";
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
                        controller: addressController,
                        decoration: InputDecoration(
                          label: Text(
                            'Address',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Delivery Address",
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
                            return "Address is Required";
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: DropdownButtonFormField(
                      value: selectedPayment,
                      onChanged: (value) {
                        setState(() {
                          selectedPayment = value!;
                        });
                      },
                      items: [
                        'JazzCash',
                        'EasyPaisa',
                        'GooglePay',
                        'SadaPay',
                        'Paypal'
                      ].map((String v1) {
                        return DropdownMenuItem(
                          child: Text(v1),
                          value: v1,
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        fillColor: Colors.grey[200],
                        filled: true,
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
                  Padding(
                    padding: const EdgeInsets.only(left: 28, right: 28, top: 15),
                    child: Container(
                      height: 60,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        decoration: InputDecoration(
                          label: Text(
                            'Phone Number',
                            style: TextStyle(color: Colors.black),
                          ),
                          fillColor: Colors.grey[200],
                          filled: true,
                          hintText: "Enter Phone Number",
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
                            return "Phone Number is Required";
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => home(),));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 50, 108, 255),
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