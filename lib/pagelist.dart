// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test02/databaseHelper.dart';
import 'package:test02/model/Misura.dart';
import 'package:test02/repository/memory_repository.dart';
import 'package:test02/repository/repository.dart';
import 'package:test02/repository/sqlite_repository.dart';
import 'package:test02/update.dart';

class PageList extends StatefulWidget {
  const PageList({super.key, required this.title});

  final String title;

  @override
  State<PageList> createState() => _PageListState();
}

class _PageListState extends State<PageList> {
  static const double fontSizeTime = 25.0;
  static const double fontSizeDate = 10.0;
  static const Color colorDeleteItem = Colors.red;

  MemoryRepository rep2 = MemoryRepository();
  List<Misura>? measures = [];

  _PageListState() {}
  @override
  Widget build(BuildContext context) {
    setState(
      () {
        rep2.ordina();
        measures = rep2.getAll();
      },
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Lista Misurazioni'),
        ),
        body: ListView(
          children: createCardList(), //<Widget>[
        ));
  }

  Widget createCard(Misura m) {
    DateFormat df = DateFormat("dd/MM/yyyy");
    String dateFormatted = df.format(m.giorno).toString();
    String timeFormatted = formatTime(m.orario.hour, m.orario.minute);

    return Dismissible(
        key: UniqueKey(),
        background: const DecoratedBox(
            decoration: BoxDecoration(color: colorDeleteItem),
            child: Align(
                alignment: Alignment(-0.9, 00),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ))),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          int deleteId = m.id;
          measures?.remove(m);
          setState(() => rep2.delete(deleteId));
        },
        child: Card(
            child: ListTile(
          leading: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              //textDirection: TextDirection.LTR,
              children: [
                Text(
                  timeFormatted,
                  style: const TextStyle(fontSize: fontSizeTime),
                ),
                Text(
                  dateFormatted,
                  style: const TextStyle(fontSize: fontSizeDate),
                ),
              ]),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                //textDirection: TextDirection.ltr,
                children: [
                  Text("Max: ${m.max}"),
                  Text("Min: ${m.min}"),
                  Text("Pulsazioni: ${m.puls}"),
                ],
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              setState(() {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (context) {
                  return UpdatePage(item: getItem(m.id)); //rep2.get(m.id));
                }));
              });
            },
          ),
        )));
  }

  List<Widget> createCardList() {
    List<Misura>? temp = rep2.getAll();
    setState(() => measures = temp);
    print(measures.toString());
    List<Widget> cardList = List.empty(growable: true);
    if (measures!.isEmpty) return [];
    // ignore: avoid_function_literals_in_foreach_calls
    measures?.forEach((element) {
      Widget c = createCard(element);
      cardList.add(c);
    });
    return cardList;
  }

  String formatTime(int h, int m) {
    String hour = "$h".padLeft(2, '0');
    String minutes = "$m".padLeft(2, '0');
    return "$hour:$minutes";
  }

  int compareMeasure(Misura a, Misura b) {
    int gValue = b.giorno.compareTo(a.giorno);
    if (gValue == 0) {
      int diff_h = b.orario.hour - a.orario.hour;
      if (diff_h == 0) {
        int diff_m = b.orario.minute - a.orario.minute;
        return (diff_m);
      }
      return (diff_h);
    } else {
      return gValue;
    }
  }

  // List<Misura> ordina(List<Misura> lista) {
  //   var distinctIds = lista.toSet().toList();
  //   distinctIds.sort((a, b) => compareMeasure(a, b));
  //   lista = distinctIds;
  //   return lista;
  // }

  Misura getItem(int id) {
    late Misura m; //= Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
    m = rep2.get(id);
    return m;
  }
}
