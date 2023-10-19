import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late List<_ChartData> chartData;
  late ChartSeriesController _chartSeriesController;

  @override
  void initState() {
    //RAMDOM
    chartData = getChartData();
    Timer.periodic(const Duration(seconds: 1), updateDataSource);

    //Get data from firebass

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
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'title'),
              // Enable legend
              legend: const Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, int>>[
                LineSeries<_ChartData, int>(
                    dataSource: chartData,
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    xValueMapper: (_ChartData data, _) => data.timestamp,
                    yValueMapper: (_ChartData data, _) => data.tempdata,
                    name: 'oC',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
        ]));
  }

  int time = 19;
  void updateDataSource(Timer timer) {
    chartData.add(_ChartData(
        timestamp: time++, tempdata: (math.Random().nextInt(60) + 30)));
    chartData.removeAt(0);
    _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  }

  List<_ChartData> getChartData() {
    return <_ChartData>[
      _ChartData(timestamp: 0, tempdata: 34),
      _ChartData(timestamp: 1, tempdata: 47),
      _ChartData(timestamp: 2, tempdata: 33),
      _ChartData(timestamp: 3, tempdata: 49),
      _ChartData(timestamp: 4, tempdata: 54),
      _ChartData(timestamp: 5, tempdata: 41),
      _ChartData(timestamp: 6, tempdata: 58),
      _ChartData(timestamp: 7, tempdata: 51),
      _ChartData(timestamp: 8, tempdata: 98),
      _ChartData(timestamp: 9, tempdata: 41),
      _ChartData(timestamp: 10, tempdata: 53),
      _ChartData(timestamp: 11, tempdata: 72),
      _ChartData(timestamp: 12, tempdata: 86),
      _ChartData(timestamp: 13, tempdata: 52),
      _ChartData(timestamp: 14, tempdata: 94),
      _ChartData(timestamp: 15, tempdata: 92),
      _ChartData(timestamp: 16, tempdata: 86),
      _ChartData(timestamp: 17, tempdata: 72),
      _ChartData(timestamp: 18, tempdata: 94),
    ];
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue =
        await FirebaseFirestore.instance.collection("chartData").get();
    // List<_ChartData> list = snapShotsValue.docs
    //     .map((e) => _ChartData(
    //         x: DateTime.fromMillisecondsSinceEpoch(
    //             e.data()['x'].millisecondsSinceEpoch),
    //         y: e.data()['y']))
    //     .toList();
    List<_ChartData> list = snapShotsValue.docs
        .map((e) =>
            _ChartData(timestamp: e.data()['x'], tempdata: e.data()['y']))
        .toList();
    setState(() {
      chartData = list;
    });
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _ChartData {
  _ChartData({this.timestamp, this.tempdata});
  final int? timestamp;
  final num? tempdata;
}
