import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class RowInfo extends StatelessWidget {
  final String text;
  final IconData icon;
  final FontWeight font;

  const RowInfo(this.text, this.icon, [this.font = FontWeight.normal]);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40, color: markSecondaryColor,),
        SizedBox(width: 10,),
        Text(text, style: TextStyle(fontSize: 18, fontWeight: font),)
      ],
    );
  }
}