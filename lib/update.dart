import 'package:flutter/material.dart';

// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test02/model/Misura.dart';
import 'package:test02/repository/memory_repository.dart';
import 'package:test02/repository/repository.dart';
import 'package:test02/repository/sqlite_repository.dart';

class UpdatePage extends StatelessWidget {
  UpdatePage({required this.item, super.key}) {
    maxController.text = item.max.toString();
    minController.text = item.min.toString();
    pulsController.text = item.puls.toString();
  }

  final Misura item;

  String _currentUser = "Francesca";
  DateFormat df = DateFormat("dd/MM/yyyy");
  final TextEditingController maxController = TextEditingController();
  final TextEditingController minController = TextEditingController();
  final TextEditingController pulsController = TextEditingController();
  MemoryRepository rep = MemoryRepository();
  DateTime _giorno = DateTime.now();
  TimeOfDay _orario = TimeOfDay.now();

  int _max = 0;
  int _min = 0;
  int _puls = 0;

  String tempo = "";

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text("Aggiorna Misura"),
        ),
        body: Column(
          children: <Widget>[
            Row(children: <Widget>[
              DropdownButton(
                items: [
                  DropdownMenuItem<String>(child: Text(_currentUser)),
                ],
                onChanged: (value) => {},
              )
            ]),
            Row(children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(df.format(this.item.giorno)),
                    IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        getData(context);
                      },
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(this.item.orario.format(context)),
                    IconButton(
                      icon: Icon(Icons.timer_sharp),
                      onPressed: () {
                        getTime(context);
                      },
                    )
                  ],
                ),
              ),
            ]),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: maxController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Pressione Massima"),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: minController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Pressione Minima"),
                  onSubmitted: (value) => {},
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: pulsController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "Pulsazioni"),
                  onSubmitted: (value) => {},
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  style: style,
                  onPressed: () {
                    // setState(() {
                    //   _max = int.parse(maxController.text);
                    //   _min = int.parse(minController.text);
                    //   _puls = int.parse(pulsController.text);
                    //   Misura nuovo = Misura();
                    //   nuovo.utente = _currentUser;
                    //   nuovo.giorno = _giorno;
                    //   nuovo.orario = _orario;
                    //   nuovo.max = _max;
                    //   nuovo.min = _min;
                    //   nuovo.puls = _puls;
                    //   rep.put(3, nuovo);
                    // });
                    Misura updateMisura =
                        Misura(giorno: DateTime.now(), orario: TimeOfDay.now());
                    updateMisura.giorno = item.giorno;
                    updateMisura.orario = item.orario;
                    updateMisura.max = int.parse(maxController.text.toString());
                    updateMisura.min = int.parse(minController.text.toString());
                    updateMisura.puls =
                        int.parse(pulsController.text.toString());

                    rep.put(item.id, updateMisura);
                    rep.ordina();

                    tempo = df.format(_giorno).toString() +
                        " " +
                        _orario.hour.toString() +
                        ":" +
                        _orario.minute.toString();
                    print(
                        'update.onpressed:  id=${updateMisura.id} - ${updateMisura.giorno.day}/${updateMisura.giorno.month}/${updateMisura.giorno.year} - ${updateMisura.orario.hour}:${updateMisura.orario.minute} - Max ${updateMisura.max} Min ${updateMisura.min} Puls ${updateMisura.puls}');
                    // final snackBar = SnackBar(
                    //   content: Text(
                    //       "$tempo Max: $_max Min: $_min Pulsazioni: $_puls"),
                    //   action: SnackBarAction(
                    //     label: 'Undo',
                    //     onPressed: () {
                    //       // Some code to undo the change.
                    //     },
                    //   ),
                    // );

                    //ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    //clearInput();
                    Navigator.pop(context);
                  },
                  child: const Text('Aggiorna'),
                )),
          ],
        ));
  }

  void clearInput() {
    maxController.clear();
    minController.clear();
    pulsController.clear();
  }

  void getData(BuildContext context) async {
    var fDate = await showDatePicker(
        context: context,
        initialDate: _giorno,
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));
    if (fDate != null) {
      _giorno = fDate;
    }
  }

  void getTime(BuildContext context) async {
    var fTime = await showTimePicker(
      context: context,
      initialTime: _orario,
    );
    if (fTime != null) {
      _orario = fTime;
    }
  }
}
