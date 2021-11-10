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
      final p = ProcedimentoModel(element['type'], element['price'], Color(int.parse(element['color'])),); 
      _procedimentos.add(p);
    });

    _procedimentos.sort((a, b) => a.type.compareTo(b.type));

    notifyListeners();
  }
}
