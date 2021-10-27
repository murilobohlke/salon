import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class RowInfo extends StatelessWidget {
  final String type;
  final String value;

  const RowInfo(this.type, this.value);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: markSecondaryColor,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row( 
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
            Text(type, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
            Text('  R\$ ', style: TextStyle(fontSize: 15, color: Colors.white,),),
            Text(value, style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),)
          ],
        ),
      ),
    );
  }
}