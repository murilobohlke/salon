import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/_utils/app_routes.dart';
import 'package:salon/models/procedimento_model.dart';

class ProcedimentoTile extends StatelessWidget {
  final ProcedimentoModel procedimento;

  const ProcedimentoTile(this.procedimento);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=> Navigator.pushNamed(context, AppRoutes.PROCEDIMENTO_DETAILS_MANAGER, arguments: procedimento),
      child: Card(
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
              Text(procedimento.type, style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),),
              Text('  R\$ ', style: TextStyle(fontSize: 15, color: Colors.white,),),
              Text(procedimento.price, style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}