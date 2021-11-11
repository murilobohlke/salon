import 'package:flutter/material.dart';
import 'package:salon/ui/ui_manager/horarios_manager/components/calendar_manager.dart';

class HorariosManagerPage extends StatelessWidget {
  const HorariosManagerPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Editar Horários'),),
      body: SafeArea(
        child: CalendarManager()
      )
    );
  }
}