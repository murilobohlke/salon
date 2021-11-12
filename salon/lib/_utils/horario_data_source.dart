import 'package:flutter/material.dart';
import 'package:salon/models/horario_model.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HorarioDataSource extends CalendarDataSource {
  HorarioDataSource(List<HorarioModel> source){
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].start;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].end;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return appointments![index].background;
  }

  @override
  bool isAllDay(int index) {
    return false;
  }
}
