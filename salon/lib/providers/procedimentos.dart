import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:salon/database/db_firestore.dart';
import 'package:salon/models/procedimento_model.dart';

class Procedimentos with ChangeNotifier {
  late FirebaseFirestore db;

  List<ProcedimentoModel> _procedimentos = [];

  List<ProcedimentoModel> get procedimentos {
    return [..._procedimentos];
  }


  Future<void> loadProcedimentos() async {
    db = DBFirestore.get();

    _procedimentos = [];
    
    var snapshot = await db.collection('procedimentos').get();

    snapshot.docs.forEach((element) {
      final p = ProcedimentoModel(element.reference.id, element['type'], element['price'], Color(int.parse(element['color'])),(element['time'] as Timestamp).toDate()); 
      _procedimentos.add(p);
    });

    _procedimentos.sort((a, b) => a.type.compareTo(b.type));

    notifyListeners();
  }

  Future<void> addProcedimento (ProcedimentoModel p) async {
    db = DBFirestore.get();

    await db.collection('procedimentos').add({
      'type': p.type,
      'price': p.price,
      'color': '0xff${p.color.value.toRadixString(16).substring(2, 8)}',
      'time': p.time
    });

    await loadProcedimentos();
  }

  Future<void> editProcedimento(ProcedimentoModel p) async{
    db = DBFirestore.get();

    await db.collection('procedimentos').doc(p.id).update({
      'type': p.type,
      'price': p.price,
      'color': '0xff${p.color.value.toRadixString(16).substring(2, 8)}',
      'time': p.time
    });

    await loadProcedimentos();
  }

  Future<void> deleteProcedimento(String id) async{
    print(id);

    db = DBFirestore.get();

    await db.collection('procedimentos').doc(id).delete();

    await loadProcedimentos();
  }
}
