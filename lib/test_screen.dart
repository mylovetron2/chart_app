import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late List<_ChartData> chartData;

  @override
  void initState() {
    chartData = getChartData();
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
              title: ChartTitle(text: 'Half yearly sales analysis'),
              // Enable legend
              legend: const Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, int>>[
                LineSeries<_ChartData, int>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.time,
                    yValueMapper: (_ChartData data, _) => data.temp_data,
                    name: 'time',
                    // Enable data label
                    dataLabelSettings: const DataLabelSettings(isVisible: true))
              ]),
        ]));
  }

  List<_ChartData> getChartData() {
    return <_ChartData>[
      _ChartData(0, 42),
      _ChartData(1, 47),
      _ChartData(2, 33),
      _ChartData(3, 49),
      _ChartData(4, 54),
      _ChartData(5, 41),
      _ChartData(6, 58),
      _ChartData(7, 51),
      _ChartData(8, 98),
      _ChartData(9, 41),
      _ChartData(10, 53),
      _ChartData(11, 72),
      _ChartData(12, 86),
      _ChartData(13, 52),
      _ChartData(14, 94),
      _ChartData(15, 92),
      _ChartData(16, 86),
      _ChartData(17, 72),
      _ChartData(18, 94),
    ];
  }
}

class _SalesData {
  _SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class _ChartData {
  _ChartData(this.time, this.temp_data);
  final int time;
  final num temp_data;
}
