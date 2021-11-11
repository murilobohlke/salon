import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:salon/database/db_firestore.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/procedimento_model.dart';

class Horarios with ChangeNotifier {
  late FirebaseFirestore db;

  List<HorarioModel> _horarios = [];
  List<HorarioModel> _historico = [];

  List<HorarioModel> historicoId(String id) {
    return [..._historico].where((element) => element.userId == id).toList();
  }

  List<HorarioModel> get horarios {
    return [..._horarios];
  }

  List<HorarioModel> get historico {
    return [..._historico];
  }

  Future<void> loadHorarios() async {
    db = DBFirestore.get();

    _horarios = [];
    _historico = [];

    List<HorarioModel> aux = [];
    
    var snapshot = await db.collection('horarios').get();

    snapshot.docs.forEach((element) {
      final h = HorarioModel(
        id:element.reference.id,
        name: element['name'], 
        start: (element['start'] as Timestamp).toDate(), 
        end:(element['end'] as Timestamp).toDate(),  
        background: Color(int.parse(element['color'])),
        type: element['type'], 
        userId: element['userId']
      );

      aux.add(h);
    });

    aux.forEach((element) { 
      if(DateTime.now().isAfter(element.start)){
        _historico.add(element);
      } else{
        _horarios.add(element);
      }
    });

    _historico.sort((a,b) => a.start.compareTo(b.start));

    _historico = _historico.reversed.toList();

    notifyListeners();
  }

  Future<void> addHorario (HorarioModel h) async {
    _horarios.add(h);

    db = DBFirestore.get();

    await db.collection('horarios').add({
      'name': h.name,
      'start': h.start,
      'end': h.end,
      'type': h.type,
      'userId': h.userId,
      'color': '0xff${h.background.value.toRadixString(16).substring(2, 8)}',
    });

    await loadHorarios();
  }

  Future<void> editHorario(String id, String name, ProcedimentoModel type) async{
    db = DBFirestore.get();

    await db.collection('horarios').doc(id).update({
      'name': name,
      'type': type.type,
      'color': '0xff${type.color.value.toRadixString(16).substring(2, 8)}',
    });

    await loadHorarios();
  }

  Future<void> editHorarioManager(String id, DateTime initialTime, DateTime endTime) async{
    db = DBFirestore.get();

    await db.collection('horarios').doc(id).update({
      'end' : endTime,
      'start' : initialTime,
    });

    await loadHorarios();
  }

   Future<void> deleteHorario(String id) async{

    db = DBFirestore.get();

    await db.collection('horarios').doc(id).delete();

    await loadHorarios();
  }
}
