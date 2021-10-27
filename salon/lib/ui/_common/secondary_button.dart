import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton(this.label, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: width(context)/2,
      child: ElevatedButton(
        child: Text(label),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
          onPrimary: markTertiaryColor,
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), 
          ),
        ),
        onPressed:onPressed, 
      ),
    );
  }
}