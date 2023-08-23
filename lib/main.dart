import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test02/databaseHelper.dart';
import 'package:test02/graph.dart';
import 'package:test02/model/Misura.dart';
import 'package:test02/pagelist.dart';
import 'package:test02/repository/memory_repository.dart';
import 'package:test02/repository/repository.dart';
import 'package:test02/repository/sqlite_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Controllo Pressione Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<String> users = ["Francesca"];
  String _currentUser = "Francesca";
  DateFormat df = DateFormat("dd/MM/yyyy");
  final TextEditingController maxController = TextEditingController();
  final TextEditingController minController = TextEditingController();
  final TextEditingController pulsController = TextEditingController();
  MemoryRepository rep = MemoryRepository();
  DateTime _giorno = DateTime.now();
  TimeOfDay _orario = TimeOfDay.now();
  int _selectedIndex = 0;
  int _max = 0;
  int _min = 0;
  int _puls = 0;

  String tempo = "";

  _MyHomePageState() {}
  void getData(BuildContext context) async {
    var fDate = await showDatePicker(
        context: context,
        initialDate: _giorno,
        firstDate: DateTime(2018),
        lastDate: DateTime(2030));
    if (fDate != null) {
      setState(() {
        _giorno = fDate;
      });
    }
  }

  void getTime(BuildContext context) async {
    var fTime = await showTimePicker(
      context: context,
      initialTime: _orario,
    );
    if (fTime != null) {
      setState(() {
        _orario = fTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final formattedTimeOfDay = localizations.formatTimeOfDay(_orario);
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(
          children: <Widget>[
            Row(children: <Widget>[
              // DropdownButton<String>(
              //   items: [
              //     DropdownMenuItem<String>(child: Text(_currentUser)),
              //   ],
              //   onChanged: (value) => {setState(() => _currentUser = value!)},
              // )
            ]),
            Row(children: <Widget>[
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Text(df.format(_giorno)),
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
                    Text(_orario.format(context)),
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
                    setState(() {
                      _max = int.parse(maxController.text);
                      _min = int.parse(minController.text);
                      _puls = int.parse(pulsController.text);
                      Misura nuovo = Misura(
                          giorno: DateTime.now(), orario: TimeOfDay.now());
                      nuovo.utente = _currentUser;
                      nuovo.giorno = _giorno;
                      nuovo.orario = _orario;
                      nuovo.max = _max;
                      nuovo.min = _min;
                      nuovo.puls = _puls;
                      rep.add(nuovo);
                      rep.ordina();
                    });

                    // ignore: prefer_interpolation_to_compose_strings
                    tempo = df.format(_giorno).toString() +
                        " " +
                        _orario.hour.toString() +
                        ":" +
                        _orario.minute.toString();
                    //print(tempo);

                    final snackBar = SnackBar(
                      content: Text(
                          "Misura $tempo Max: $_max Min: $_min Pulsazioni: $_puls memorizzata"),
                      action: SnackBarAction(
                        label: '',
                        onPressed: () {
                          // Some code to undo the change.
                        },
                      ),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    clearInput();
                  },
                  child: const Text('Invia'),
                )),
            Container(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                    style: style,
                    child: const Text('Elenco'),
                    onPressed: () {
                      List<Misura> l1 = rep.getAll();
                      printAll(l1);
                    })),
            // Container(
            //     padding: const EdgeInsets.all(10),
            //     child: ElevatedButton(
            //         style: style,
            //         child: const Text('ListView'),
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute<void>(
            //                   builder: (context) => PageList(
            //                         title: "Liste",
            //                       )));
            //         })),
            // Container(
            //     padding: const EdgeInsets.all(10),
            //     child: ElevatedButton(
            //         style: style,
            //         child: const Text('Grafico'),
            //         onPressed: () {
            //           Navigator.push(
            //               context,
            //               MaterialPageRoute<void>(
            //                   builder: (context) =>
            //                       GraphMeasures(title: "Grafici")));
            //         })),
          ],
        ),
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(_currentUser),
              ),
              ListTile(
                title: const Text('Inserimento Misure'),
                selected: _selectedIndex == 0,
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                  navigate();
                },
              ),
              ListTile(
                title: const Text('Lista Misurazioni'),
                selected: _selectedIndex == 1,
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                  navigate();
                },
              ),
              ListTile(
                title: const Text('Grafici'),
                selected: _selectedIndex == 2,
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                  navigate();
                },
              ),
            ],
          ),
        ));
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void navigate() {
    if (_selectedIndex == 0) {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => MyHomePage(
                    title: "Pressione",
                  )));
    }
    if (_selectedIndex == 1) {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => PageList(
                    title: "Liste",
                  )));
    }
    if (_selectedIndex == 2) {
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (context) => GraphMeasures(title: "Grafici")));
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    maxController.dispose();
    minController.dispose();
    pulsController.dispose();
    super.dispose();
  }

  void printAll(List<Misura> lista) {
    int count = 0;

    lista.forEach((element) {
      count++;
      String progr = element.id.toString();
      String usr = element.utente;
      String day1 = df.format(element.giorno).toString();
      String hour1 = "${element.orario.hour}:${element.orario.minute}";
      String max1 = element.max.toString();
      String min1 = element.min.toString();
      String puls1 = element.puls.toString();
      // ignore: avoid_print
      print(
          'N. $count\t$progr\t$usr\t$day1\t$hour1\tMax: $max1\tMin: $min1\tPulsazioni: $puls1');
    });
  }

  void clearInput() {
    maxController.clear();
    minController.clear();
    pulsController.clear();
  }
}
