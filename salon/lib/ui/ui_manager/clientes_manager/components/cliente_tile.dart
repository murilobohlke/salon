import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/user_model.dart';

class ClienteTile extends StatelessWidget {
  final UserModel user;

  const ClienteTile(this.user);

  @override
  Widget build(BuildContext context) {
    bool load = false;
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
            loadingBuilder: (BuildContext context, Widget child, loadingProgress) {
              if (loadingProgress == null && !load) {
                load = true;
                return Container( 
                  height: 60, 
                  width: 60,
                  child: Center(child: CircularProgressIndicator(color: markPrimaryColor,),)
                );
              }
              return child; 
            } 
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
        trailing: Text(''),
      )
    );
  }
}