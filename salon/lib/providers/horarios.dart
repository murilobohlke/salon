import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:salon/database/db_firestore.dart';
import 'package:salon/models/horario_model.dart';
import 'package:salon/models/type_model.dart';

class Horarios with ChangeNotifier {
  List<HorarioModel> _horarios = [];
  List<HorarioModel> _historico = [];

  List<HorarioModel> historico(String id) {
    return [..._historico].where((element) => element.userId == id).toList();
  }

  List<HorarioModel> get horarios {
    return [..._horarios];
  }

  Future<void> loadHorarios() async {
    final db = DBFirestore.get();
    _horarios = [];
    _historico = [];

    List<HorarioModel> aux = [];
    
    var collection = db.collection('horarios');
    var snapshot = await collection.get();


    snapshot.docs.forEach((element) {
      final h = HorarioModel(
        id:element.reference.id,
        name: element['name'], 
        start: (element['start'] as Timestamp).toDate(), 
        end:(element['end'] as Timestamp).toDate(),  
        background: Color(int.parse(element['color'])),
        type: element['type'], 
        userId: element['userId']);
        aux.add(h);
    });

    aux.forEach((element) { 
      if(DateTime.now().isAfter(element.start)){
        _historico.add(element);
      } else{
        _horarios.add(element);
      }
    });
    print(_historico);
    notifyListeners();

  }

  Future<void> addHorario (HorarioModel h) async {
    _horarios.add(h);

    final db = DBFirestore.get();

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

  Future<void> editHorario(String id, String name, TypeModel type) async{
    print(id);
    print(name);
    print(type);
     final db = DBFirestore.get();

    await db.collection('horarios').doc(id).update({
      'name': name,
      'type': type.label,
      'color': '0xff${type.color.value.toRadixString(16).substring(2, 8)}',
    });

    await loadHorarios();
  }

   Future<void> deleteHorario(String id) async{

    final db = DBFirestore.get();

    await db.collection('horarios').doc(id).delete();

    await loadHorarios();
  }
}