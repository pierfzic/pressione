import 'dart:core';
import 'package:test02/model/Misura.dart';

abstract class Repository {
  List<Misura> getAll();
  Misura get(int id);
  bool delete(int id);
  void add(Misura m);
  bool put(int id, Misura m);
  void closeDB();
}
