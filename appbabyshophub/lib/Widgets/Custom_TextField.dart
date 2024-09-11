import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  // const CustomTextField({super.key});
  TextEditingController controller1;
  bool isShow;
  String label;
  String hintText;
  IconData icon;
  CustomTextField({required this.controller1,
    required this.icon,
    required this.label,
    required this.hintText,
    this.isShow=false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller1,
      obscureText: isShow,
      decoration: InputDecoration(
          label: Text('$label'),
          hintText: "$hintText",
          prefixIcon: Icon(icon),
          border: OutlineInputBorder()
      ),
    );
  }
}
