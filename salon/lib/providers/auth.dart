
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:salon/_utils/urls.dart';
import 'package:salon/database/db_firestore.dart';
import 'package:salon/database/store.dart';
import 'package:salon/exceptions/auth_exception.dart';
import 'package:salon/models/user_model.dart';


class Auth with ChangeNotifier {
  late FirebaseFirestore db;
  
  String? _token;
  String? _email;
  String? _userId;
  DateTime? _expiryDate;
  Timer? _logoutTimer;

  UserModel? _user;

  bool get isAuth {
    final isValid = _expiryDate?.isAfter(DateTime.now()) ?? false;
    return _token != null && isValid;
  }

  String? get token {
    return isAuth ? _token : null;
  }

  String? get email {
    return isAuth ? _email : null;
  }

  String? get userId {
    return isAuth ? _userId : null;
  }
  
  UserModel? get user {
    return isAuth ? _user : null;
  }

  Future<void> signUp(String email, String password, String name, String phone, String imagePath) async {
    final _url = SINGUP_URL;
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    if(body['error'] != null){
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      final FirebaseStorage storage = FirebaseStorage.instance;
      File file = File(imagePath);
      String imgUrl1 = '';
      try {
        String ref = 'images/$_userId.jpg';
        UploadTask task1 = storage.ref(ref).putFile(file);

      imgUrl1 = await (await task1).ref.getDownloadURL();

      } on FirebaseException catch (e) {
        print(e);
      }

      db = DBFirestore.get();

      await db.collection('users').doc(_userId).set({
        'name': name,
        'phone': phone,
        'email': email,
        'image': imgUrl1
      });

      _user = UserModel(
        name: name, 
        email: email, 
        phone: phone, 
        image: imgUrl1,
        id: body['localId']
      );

      Store.saveMap('userData',{
        'name' : _user!.name,
        'email' : _user!.email,
        'phone' : _user!.phone,
        'image' : _user!.image,
        'id' : _user!.id,
        'token' : _token,
        'expiry' : _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final _url = LOGIN_URL;
    final response = await http.post(
      Uri.parse(_url),
      body: jsonEncode({
        'email': email,
        'password': password,
        'returnSecureToken': true
      })
    );
    Map<String, dynamic> body = jsonDecode(response.body);
    if(body['error'] != null){
      throw AuthException(body['error']['message']);
    } else {
      _token = body['idToken'];
      _email = body['email'];
      _userId = body['localId'];

      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(body['expiresIn']),
        ),
      );

      db = DBFirestore.get();

      final response = await db.collection('users').doc(_userId).get();
      Map<String, dynamic> data = response.data() as Map<String, dynamic>;
      
      _user = UserModel(
        name: data['name'], 
        email: data['email'], 
        phone: data['phone'], 
        image: data['image'],
        id: body['localId']
      );

      Store.saveMap('userData',{
        'name' : _user!.name,
        'email' : _user!.email,
        'phone' : _user!.phone,
        'image' : _user!.image,
        'id' : _user!.id,
        'token' : _token,
        'expiry' : _expiryDate!.toIso8601String(),
      });

      _autoLogout();
      notifyListeners();
    }
  }
  
  Future<void> editUser(String id, String name, String phone) async {
    db = DBFirestore.get();

    await db.collection('users').doc(id).update({
      'name': name,
      'phone': phone,
    });

    _user = _user!.copyWith(name: name, phone: phone);

    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    if (isAuth) return;

    final userData = await Store.getMap('userData');
    if (userData.isEmpty) return;

    final expiryDate = DateTime.parse(userData['expiry']);
    if (expiryDate.isBefore(DateTime.now())) return;

    _token = userData['token'];
    _email = userData['email'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;

    _user = UserModel(
        name: userData['name'],
        email: userData['email'], 
        phone: userData['phone'], 
        image: userData['image'],
        id: userData['id']
      );

    _autoLogout();
    notifyListeners();

  }

  void logout() {
    _token = null;
    _email = null;
    _userId = null;
    _expiryDate = null;

    _logoutTimer?.cancel();
    _logoutTimer = null;

    Store.remove('userData').then((value) =>notifyListeners());
  }

  void _autoLogout() {
    _logoutTimer?.cancel();
    _logoutTimer = null;

    final time = _expiryDate?.difference(DateTime.now()).inSeconds;

    _logoutTimer = Timer(Duration(seconds: time ?? 0), logout);
  }

}