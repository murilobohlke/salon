import 'package:flutter/material.dart';
import 'package:salon/_utils/app_config.dart';
import 'package:salon/models/horario_model.dart';

class HistoricTile extends StatelessWidget {
  final HorarioModel h;

  const HistoricTile(this.h);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),
      elevation: 5,
      color: markSecondaryColor,
      child: ListTile(
        trailing: Text('${h.end.day}/${h.end.month}/${h.end.year}', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
        title: Text(h.name, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),),
        subtitle: Text(h.type, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16),),
      )
    );
  }
}