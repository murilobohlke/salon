import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class InputTextAgendar extends StatelessWidget {
  final String label;
  final TextEditingController controller;


  const InputTextAgendar({
    required this.label, 
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color: Colors.black87),
      controller: controller,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
        labelText: label,
        labelStyle: TextStyle(color: markPrimaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: markTertiaryColor, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: markTertiaryColor, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: markTertiaryColor, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}