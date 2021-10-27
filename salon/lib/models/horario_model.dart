import 'dart:convert';

import 'package:flutter/material.dart';

class HorarioModel {
  final String name;
  final DateTime start;
  final DateTime end;
  final Color background;
  final String type;
  final String userId;
  final String id;

  HorarioModel({
    required this.name, 
    required this.start, 
    required this.end, 
    required this.background, 
    required this.type,
    required this.userId,
    required this.id});
    
  HorarioModel copyWith({
    String? name,
    DateTime? start,
    DateTime? end,
    Color? background,
    String? type,
    String? userId,
    String? id,
  }) {
    return HorarioModel(
      name: name ?? this.name,
      start: start ?? this.start,
      end: end ?? this.end,
      background: background ?? this.background,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'background': background.value,
      'type': type,
      'userId': userId,
      'id': id,
    };
  }

  factory HorarioModel.fromMap(Map<String, dynamic> map) {
    return HorarioModel(
      name: map['name'],
      start: DateTime.fromMillisecondsSinceEpoch(map['start']),
      end: DateTime.fromMillisecondsSinceEpoch(map['end']),
      background: Color(map['background']),
      type: map['type'],
      userId: map['userId'],
      id: map['id'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioModel.fromJson(String source) => HorarioModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HorarioModel(name: $name, start: $start, end: $end, background: $background, type: $type, userId: $userId, id: $id)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is HorarioModel &&
      other.name == name &&
      other.start == start &&
      other.end == end &&
      other.background == background &&
      other.type == type &&
      other.userId == userId &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      start.hashCode ^
      end.hashCode ^
      background.hashCode ^
      type.hashCode ^
      userId.hashCode ^
      id.hashCode;
  }
}
