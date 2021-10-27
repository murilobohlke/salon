import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';


class InputTextWidget extends StatelessWidget {
  final String label;
  final IconData icon;
  final FocusNode focus;
  final TextInputType keyboarType;
  final TextEditingController? controller;
  final bool obscureText;
  final Color color;

  const InputTextWidget({
    Key? key,
    required this.label, 
    required this.icon, 
    this.keyboarType=TextInputType.text,
    required this.focus, 
    this.controller,
    this.color = Colors.black87,
    this.obscureText=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: key,
      style: TextStyle(color: Colors.black87),
      obscureText: obscureText,
      controller: controller,
      keyboardType: keyboarType,
      focusNode: focus,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.zero,
        labelText: label,
        labelStyle: TextStyle(color: focus.hasFocus ? markPrimaryColor: Colors.grey,),
        prefixIcon: Icon(icon, color: focus.hasFocus ? Colors.red[700]: Colors.grey[300]!),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[300]!, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: color, width: 2.0),
           borderRadius: BorderRadius.circular(25.0),
        ),
      ),
    );
  }
}