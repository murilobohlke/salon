import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const PrimaryButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
      child: Text(label),
      style: ElevatedButton.styleFrom(
        primary: markPrimaryColor,
        textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), 
        ),
      ),
      onPressed:onPressed, 
    );
  }
}