import 'package:flutter/material.dart';

class Misura {
  int id = 0;
  String utente = "";
  DateTime giorno = DateTime.now();
  TimeOfDay orario = TimeOfDay.now();
  int max = 0;
  int min = 0;
  int puls = 0;

  Misura(
      {this.id = 0,
      this.utente = "",
      required this.giorno,
      required this.orario,
      this.max = 0,
      this.min = 0,
      this.puls = 0});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user': utente,
      'giorno': '${giorno.year}-${giorno.month}-${giorno.day}',
      'orario': '${orario.hour}:${orario.minute}',
      'max': max,
      'min': min,
      'puls': puls
    };
  }

  // Misura fromMap(Map<String, dynamic> map) {
  //   Misura m;
  //   String s = map['orario'];
  //   m = Misura(
  //       id: map['id'],
  //       giorno: DateTime.parse(map['giorno']),
  //       utente: map['user'],
  //       orario: TimeOfDay(
  //           hour: int.parse(s.split(":")[0]),
  //           minute: int.parse(s.split(":")[1])),
  //       max: map['max'],
  //       min: map['min'],
  //       puls: map['puls']);
  //   return m;
  // }

  Misura.fromMap(Map<String, dynamic> map) {
    String s = map['orario'];
    id = map['id'];
    utente = map['user'];
    giorno = DateTime.parse(map['giorno']);
    orario = TimeOfDay(
        hour: int.parse(s.split(":")[0]), minute: int.parse(s.split(":")[1]));
    max = map['max'];
    min = map['min'];
    puls = map['puls'];
  }

  @override
  String toString() {
    return 'Measure{id: $id, user: $utente, giorno: $giorno, orario: $orario, max : $max, min: $min, puls: $puls}';
  }
}
