// ignore_for_file: prefer_const_constructors

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:test02/model/Misura.dart';
import 'package:test02/repository/memory_repository.dart';

class GraphMeasures extends StatefulWidget {
  const GraphMeasures({super.key, required this.title});

  final String title;

  @override
  State<GraphMeasures> createState() => _GraphMeasuresState();
}

class _GraphMeasuresState extends State<GraphMeasures> {
  static const double fontSizeTime = 8.0;
  static const Color fontColorTime = Colors.green;
  static const double fontSizeDate = 8.0;
  static const Color fontColorDate = Colors.red;
  static const double containerWidth = 500.0;
  static const double minPressure = 20;
  static const double maxPressure = 180;
  static const double bottomReservedSize = 20;
  static const double bottomInterval = 2500;
  static const double leftInterval = 20;

  LineChartBarData lineMax = LineChartBarData();
  LineChartBarData lineMin = LineChartBarData();
  LineChartBarData linePuls = LineChartBarData();

  MemoryRepository rep3 = new MemoryRepository();
  List<Misura> measures = [];
  DateTime firstXTime = DateTime(1970, 1, 1, 0, 0);
  DateTime lastXDay = DateTime(1970, 1, 1, 0, 0);

  _GraphMeasuresState() {
    measures = rep3.getOrderedList();
    firstXTime = DateTime(
        measures.last.giorno.year,
        measures.last.giorno.month,
        measures.last.giorno.day,
        measures.last.orario.hour,
        measures.last.orario.minute);
    lastXDay = firstXTime.subtract(Duration(days: 2));

    print("Primo Elemento: " + firstXTime.toString());
    createPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SafeArea(
        left: true,
        bottom: true,
        child: Container(
          padding: const EdgeInsets.all(50),
          child: SingleChildScrollView(
            controller: ScrollController(
              initialScrollOffset: 0.0,
              keepScrollOffset: true,
            ),
            scrollDirection: Axis.horizontal,
            child: Container(
              width: containerWidth,
              child: LineChart(
                LineChartData(
                  //     minY: minPressure,
                  //     maxY: maxPressure,
                  borderData: FlBorderData(
                      show: true,
                      border: Border(
                          bottom: BorderSide(
                              style: BorderStyle.solid, color: Colors.green))),
                  titlesData: FlTitlesData(
                      show: true,
                      leftTitles: AxisTitles(
                        axisNameWidget: Text(
                          "Valori",
                          style: TextStyle(color: Colors.blue, fontSize: 10),
                        ),
                        axisNameSize: 50,
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: leftInterval,
                          getTitlesWidget: (value, meta) => Text(
                              value.toInt().toString(),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.green)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                              reservedSize: bottomReservedSize,
                              showTitles: true,
                              interval: bottomInterval,
                              getTitlesWidget: (value, meta) =>
                                  createXLabels(value.toInt()))),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: AxisTitles(
                        axisNameSize: 5,
                        sideTitles: SideTitles(
                            showTitles: false, reservedSize: 30, interval: 50),
                        axisNameWidget: Text("Valori"),
                      )),
                  lineBarsData: [lineMax, lineMin, linePuls],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  int minuteBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inMinutes);
  }

  void createPoints() {
    List<FlSpot> puntiMax = [];
    List<FlSpot> puntiMin = [];
    List<FlSpot> puntiPuls = [];
    DateTime firstDay = firstXTime;
    // print("*** Primo giorno: " +
    //     firstDay.toString() +
    //     " " +
    //     measures.last.orario.toString());
    measures.reversed.forEach((element) {
      int x = minuteBetween(firstDay, element.giorno) +
          element.orario.hour.toInt() * 60 +
          (element.orario.minute.toInt());
      // int x = DateTime(element.giorno.year, element.giorno.month,
      //         element.giorno.day, element.orario.hour, element.orario.minute)
      //     .millisecondsSinceEpoch;
      // print(x);

      FlSpot spotMax = FlSpot(x.toDouble(), element.max.toDouble());
      FlSpot spotMin = FlSpot(x.toDouble(), element.min.toDouble());
      FlSpot spotPuls = FlSpot(x.toDouble(), element.puls.toDouble());
      puntiMax.add(spotMax);
      puntiMin.add(spotMin);
      puntiPuls.add(spotPuls);
    });
    lineMax = LineChartBarData(
      spots: puntiMax,
      color: Colors.red,
      isCurved: true,
      barWidth: 1.0,
    );
    lineMin = LineChartBarData(
      spots: puntiMin,
      color: Colors.blue,
      isCurved: true,
      barWidth: 1.0,
    );
    linePuls = LineChartBarData(
      spots: puntiPuls,
      color: Colors.green,
      isCurved: true,
      barWidth: 1.0,
    );
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

  List<Misura> ordina(List<Misura> lista) {
    var distinctIds = lista.toSet().toList();
    distinctIds.sort((a, b) => compareMeasure(a, b));
    lista = distinctIds;
    return lista;
  }

  Widget createXLabels(int value) {
    //value valore in minuti
    DateTime current = firstXTime.add(Duration(minutes: value));
    DateTime lastMeasureDate = DateTime(
        measures.first.giorno.year,
        measures.first.giorno.month,
        measures.first.giorno.day,
        measures.first.orario.hour,
        measures.first.orario.minute);
    TimeOfDay t = TimeOfDay(hour: current.hour, minute: current.minute);
    String stringTime = '${t.hour}:${t.minute}';
    String giornoCorr = current.day.toString() + "/" + current.month.toString();
    String day = '${current.day.toString()}/${current.month.toString()}';
    bool anoth = anotherDay(current, lastXDay);
    if (anoth) {
      lastXDay = current;
    }
    // print("Genera Grafico: value:" +
    //     value.toString() +
    //     " " +
    //     stringTime +
    //     " - " +
    //     day +
    //     " " +
    //     anoth.toString());
    if (current.compareTo(lastMeasureDate) > 0)
      lastXDay = DateTime(1970, 1, 1, 0, 0);
    return Container(
      // height: 5,
      // color: Colors.yellow,
      child: Column(
        children: [
          Text(stringTime,
              style: TextStyle(fontSize: fontSizeDate, color: fontColorDate)),
          Text((anoth ? giornoCorr : " "),
              style: TextStyle(fontSize: fontSizeTime, color: fontColorTime)),
        ],
      ),
    );
    // } else {
    //   print("createXLabels: value:" +
    //       value.toString() +
    //       " " +
    //       stringTime +
    //       " - ");
    //   return Column(
    //     children: [
    //       Text(stringTime,
    //           style: TextStyle(fontSize: fontSizeTime, color: fontColorTime)),
    //       Text("",
    //           style: TextStyle(fontSize: fontSizeDate, color: fontColorDate))
    //     ],
    //   );
    // }
  }

  bool anotherDay(DateTime curr, DateTime backday) {
    if (curr.year > backday.year) {
      return true;
    } else if (curr.month > backday.month)
      return true;
    else if (curr.day > backday.day) return true;
    return false;
  }
}
