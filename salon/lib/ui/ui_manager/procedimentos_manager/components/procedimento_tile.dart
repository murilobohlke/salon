import 'package:flutter/material.dart';
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
        color: procedimento.color,
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            procedimento.type, 
            style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}