import 'package:flutter/material.dart';
import 'package:salon/ui/agendar_horario/components/calendar.dart';

class AgendarHorarioPage extends StatelessWidget {
  const AgendarHorarioPage({ Key? key }) : super(key: key);

   @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Calendar()
      )
    );
  }
}