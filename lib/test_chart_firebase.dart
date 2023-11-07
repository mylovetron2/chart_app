import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:firebase_database/firebase_database.dart' ;

class TestChartFireBase extends StatefulWidget {
  const TestChartFireBase({super.key});

  @override
  State<TestChartFireBase> createState() => _TestChartFireBaseState();
}

class _TestChartFireBaseState extends State<TestChartFireBase> {
  List<_ChartData> chartData = <_ChartData>[];
  
  
  
  @override
  
  void initState() {
    //RAMDOM
    //chartData = getChartData();
    //Timer.periodic(const Duration(seconds: 1), getDataFromFireStore);

    //Get data from firebass
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });

  

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
              title: ChartTitle(text:'title2'),
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

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("chartData").get();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) => _ChartData(
            timestamp: DateTime.fromMillisecondsSinceEpoch(
                e.data()['timestamp'].millisecondsSinceEpoch),
            tempdata: e.data()['tempdata']))
        .toList();
    // List<_ChartData> list = snapShotsValue.docs
    //     .map((e) =>
    //         _ChartData(timestamp: e.data()['timestamp'], tempdata: e.data()['tempdata']))
    //     .toList();
    setState(() {
      chartData = list;
    });
  }

  Future<void> getRealtimeFromFireStore() async {
        
    
    
  }


}



class _ChartData {
  _ChartData({this.timestamp, this.tempdata});
  final DateTime? timestamp;
  final num? tempdata;
}
