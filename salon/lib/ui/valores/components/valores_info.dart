import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:salon/models/procedimento_model.dart';

class ValoresInfo extends StatelessWidget {
  final ProcedimentoModel p;

  const ValoresInfo(this.p);

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm');
    
    return Card(
      color: p.color,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(p.type, style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),),
            Row( 
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Icon(Icons.attach_money, color: Colors.white,),
                Text(p.price, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
                SizedBox(width: 40,),
                Icon(Icons.timer_outlined, color: Colors.white,),
                SizedBox(width: 5,),
                Text(formatter.format(p.time), style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),)
              ],
            ),
          ],
        ),
      ),
    );
  }
}