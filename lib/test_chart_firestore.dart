import 'dart:async';
import 'dart:math' as math;

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart' ;

class TestChartFireBase2 extends StatefulWidget {
  const TestChartFireBase2({super.key});

  @override
  State<TestChartFireBase2> createState() => _TestChartFireBase2State();
}

class _TestChartFireBase2State extends State<TestChartFireBase2> {
  List<_ChartData> chartData = <_ChartData>[];
  
  void getData() {
    Query starCountRef =
      FirebaseDatabase.instance.ref('data').limitToLast(100);
    starCountRef.onValue.listen((DatabaseEvent event) {
      print("test");
      Map data = event.snapshot.value as Map;
      chartData = data.entries.map((e) => _ChartData(
            timestamp: DateTime.fromMillisecondsSinceEpoch(
                e.value()['time'].millisecondsSinceEpoch),
            tempdata: e.value()['temp']))
        .toList();

    });
    print(chartData);
    
  }
  


  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Temperature App'),
          centerTitle: true,
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: DateTimeAxis(),
              primaryYAxis: NumericAxis(),
              // Chart title
              title: ChartTitle(text:'title3'),
              // Enable legend
              legend: const Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.timestamp,
                    yValueMapper: (_ChartData data, _) => data.tempdata,
                    name: 'oC',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
        ]));
  }

  
}



class _ChartData {
  _ChartData({this.timestamp, this.tempdata});
  final DateTime? timestamp;
  final num? tempdata;
}
