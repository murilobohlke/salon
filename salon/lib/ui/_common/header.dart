import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class Header extends StatelessWidget {
  final String label;

  const Header(this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold,),),
        Container(height: 3, width: 50, color: markPrimaryColor,)
      ],
    );
  }
}