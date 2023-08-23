import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test02/model/Misura.dart';
import 'package:test02/repository/repository.dart';

class MemoryRepository extends Repository {
  List<Misura> lista = List.empty(growable: true);
  List<String> users = [];
  static int indice = 0;

  // DateTime firstXTime = DateTime.now();
  // DateTime lastxDay = DateTime.now();

  static final MemoryRepository _instance =
      MemoryRepository._privateConstructor();

  factory MemoryRepository() {
    return _instance;
  }

  MemoryRepository._privateConstructor() {
    if (lista.isEmpty) {
      genMisure();
      indice = 101;
      ordina();
    }

    // firstXTime = DateTime(
    //     lista.last.giorno.year,
    //     lista.last.giorno.month,
    //     lista.last.giorno.day,
    //     lista.last.orario.hour,
    //     lista.last.orario.minute);
    // lastxDay = firstXTime.subtract(Duration(days: 2));
    // print("Primo Elemento: " + firstXTime.toString());
    // lista.reversed.forEach((element) {
    //   DateTime xDateTime = DateTime(element.giorno.year, element.giorno.month,
    //       element.giorno.day, element.orario.hour, element.orario.minute);
    //   int value = xDateTime.difference(firstXTime).inMinutes;
    //   createXLabels(value);
    // });
  }
  @override
  Future<int> add(Misura m) {
    m.id = indice++;
    lista.add(m);
    return Future.value(indice);
  }

  @override
  Future<void> closeDB() {
    return Future.value(Void);
  }

  @override
  bool delete(int id) {
    bool trovato = false;
    Misura item = new Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
    lista.forEach((element) {
      if (element.id == id) item = element;
      trovato = true;
    });
    if (trovato) lista.remove(item);
    return trovato;
  }

  @override
  Misura get(int id) {
    Misura item = Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
    lista.forEach((element) {
      if (element.id == id) item = element;
    });
    return item;
  }

  Misura getValue(int id) {
    Misura item = Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
    lista.forEach((element) {
      if (element.id == id) item = element;
    });
    return item;
  }

  @override
  List<Misura> getAll() {
    return lista;
  }

  List<Misura> getList() {
    return lista;
  }

  List<Misura> getOrderedList() {
    ordina();
    return lista;
  }

  @override
  bool put(int id, Misura m) {
    bool trovato = false;
    int index = 0;
    while ((!trovato) || (index < lista.length)) {
      Misura element = lista[index];
      if (element.id == id) {
        trovato = true;
        break;
      }
      index++;
    }
    if (trovato) {
      m.id = id;
      lista[index] = m;
    }

    print(
        'repository.put: upgrade id=$id - ${m.giorno.day}/${m.giorno.month}/${m.giorno.year} - ${m.orario.hour}:${m.orario.minute} - Max ${m.max} Min ${m.min} Puls ${m.puls}');
    return trovato;
  }

  int compare_measure(Misura a, Misura b) {
    int g_value = b.giorno.compareTo(a.giorno);
    if (g_value == 0) {
      int diff_h = b.orario.hour - a.orario.hour;
      if (diff_h == 0) {
        int diff_m = b.orario.minute - a.orario.minute;
        return (diff_m);
      }
      return (diff_h);
    } else
      return g_value;
  }

  void ordina() {
    //ordina dal più recente al meno recente
    var distinctIds = lista.toSet().toList();
    distinctIds.sort((a, b) => compare_measure(a, b));
    lista = distinctIds;
  }

  void genMisure() {
    print("****** STO GENERANDO LE MISURE ");
    //solo per test
    int n = 20;
    Random genRand = Random();
    for (int i = 0; i < n; i++) {
      int day = genRand.nextInt(27) + 1;
      int hour = genRand.nextInt(24);
      int minute = genRand.nextInt(60);

      int massima = genRand.nextInt(50) + 90;
      int minima = genRand.nextInt(70) + 50;
      int pulse = genRand.nextInt(50) + 50;

      Misura m = Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
      m.id = i;
      m.max = massima;
      m.min = minima;
      m.puls = pulse;
      m.giorno = DateTime(2023, 8, day);
      m.orario = TimeOfDay(hour: hour, minute: minute);
      lista.add(m);
    }
  }

  // void createXLabels(int value) {
  //   //value valore in minuti
  //   DateTime current = firstXTime.add(Duration(minutes: value));
  //   TimeOfDay t = TimeOfDay(hour: current.hour, minute: current.minute);
  //   String day = current.day.toString() + "/" + current.month.toString();
  //   if (anotherDay(current, lastxDay)) {
  //     lastxDay = current;
  //     print("createXLabels: " + t.toString() + " - " + day);
  //   } else {
  //     print("createXLabels: " + t.toString() + " - ");
  //   }
  // }

  // bool anotherDay(DateTime curr, DateTime backday) {
  //   if (curr.year > backday.year)
  //     return true;
  //   else if (curr.month > backday.month)
  //     return true;
  //   else if (curr.day > backday.day) return true;
  //   return false;
  // }

  Future<String> get _localPath async {
    final directory = await getApplicationCacheDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/export_measures.csv');
  }

  Future<Future<File>> exportToCSV() async {
    final file = await _localFile;
    lista.forEach((element) {
      String rigaCSV =
          "${element.utente},${element.id},${element.giorno}, ${element.orario},${element.max},${element.min},${element.puls}\n";
      file.writeAsString(rigaCSV);
    });
    return file.writeAsString("\n");
  }
}
