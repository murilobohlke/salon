import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:salon/database/db_firestore.dart';
import 'package:salon/models/user_model.dart';

class Clientes with ChangeNotifier {
  late FirebaseFirestore db;
  
  List<UserModel> _clientes = [];

  List<UserModel> get clientes {
    return [..._clientes];
  }

  Future<void> loadClientes() async {
    db = DBFirestore.get();

    _clientes = [];

    var snapshot = await db.collection('users').get();

    snapshot.docs.forEach((element) {
      if(!element['email'].toString().contains('@saloon.com')){
        var c = UserModel(
        name: element['name'], 
        email:  element['email'], 
        phone:  element['phone'], 
        id: element.reference.id, 
        image:  element['image']
      );

      _clientes.add(c);
      }
    });

    _clientes.sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }


}