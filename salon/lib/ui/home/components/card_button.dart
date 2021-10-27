import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';

class CardButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  const CardButton(this.label, this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: onTap,
      child: Card(
        color: markSecondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50, horizontal: 45),
          child: Row(
            children: [
              Icon(icon, color: Colors.white,),
              Expanded(child: Text(
                label, 
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.bold),
              ))
            ],
          ),
        ),
      ),
    );
  }
}