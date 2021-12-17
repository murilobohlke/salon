import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/user_model.dart';

class ClienteTile extends StatelessWidget {
  final UserModel user;
  final int total;

  const ClienteTile(this.user, this.total);

  @override
  Widget build(BuildContext context) {
    
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
      elevation: 5,
      color: markSecondaryColor,
      child: ListTile(
        leading: ClipRRect(
          borderRadius:BorderRadius.all(Radius.circular(40)),
          child: Image.network(
            user.image, 
            height: 60, 
            width: 60, 
            fit: BoxFit.cover,
          )
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person, color: Colors.white,),
            SizedBox(width: 10,),
            Text(user.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
          ],
        ),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.phone, color: Colors.white, size: 20,),
            SizedBox(width: 10,),
            Text(user.phone, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Horários',
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              '$total',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      )
    );
  }
}