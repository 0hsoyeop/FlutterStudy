import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_study10_project/network_summary.dart';

ZoomPanBehavior _zoomPanBehavior = ZoomPanBehavior(enablePinching: true);

// Widgets
Widget buildTitleBottomBar(double barWidth) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 3),
    width: barWidth,
    height: 4,
    decoration: BoxDecoration(
      color: Colors.blue[300],
      borderRadius: BorderRadius.circular(5),
    ),
  );
}

// - PhoneInfoContaier
Widget buildPhoneInfoContainer(String title) {
  return Container(
    width: 160,
    height: 40,
    decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(width: 1.5, color: Colors.black12),
      ),
    ),
    child: Center(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black38,
          fontSize: 15,
        ),
      ),
    ),
  );
}

// - FutureBuilder
Widget buildFutureBuilder(Future futureName) {
  return FutureBuilder(
    future: futureName,
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData == false) {
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error');
      } else {
        return buildPhoneInfoContainer(snapshot.data);
      }
    },
  );
}

// SfDataGrid
GridColumn buildGridColum(String colName, String colLabel) {
  return GridColumn(
    allowEditing: false,
    width: 100,
    columnName: colName,
    label: Container(
      padding: EdgeInsets.all(8.0),
      alignment: Alignment.center,
      child: Text(
        colLabel,
        overflow: TextOverflow.ellipsis,
      ),
    ),
  );
}

// - SfCartesianChart
Widget buildChart(String chartTitle, List<ChartData> chartData, double minYAxis, double maxYAxis, DateTime startTime, DateTime endTime) {
  return SfCartesianChart(
    primaryXAxis: DateTimeAxis(
      labelStyle: TextStyle(
        fontSize: 9,
      ),
      title: AxisTitle(
        text: 'Time',
        textStyle: TextStyle(
          color: Colors.black54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      edgeLabelPlacement: EdgeLabelPlacement.shift,
      dateFormat: DateFormat.Hms(),
      interval: 5,
      intervalType: DateTimeIntervalType.auto,
      labelRotation: 90,
      minimum: startTime,
      maximum: endTime,
      autoScrollingMode: AutoScrollingMode.start,
      autoScrollingDelta: 60,
      autoScrollingDeltaType: DateTimeIntervalType.auto,
    ),
    primaryYAxis: NumericAxis(
      labelStyle: TextStyle(
        fontSize: 9,
      ),
      minimum: minYAxis,
      maximum: maxYAxis,
    ),
    series: <ChartSeries>[
      LineSeries<ChartData, DateTime>(
        dataSource: chartData,
        xValueMapper: (ChartData data, _) => data.x,
        yValueMapper: (ChartData data, _) => data.y,
      ),
    ],
    title: ChartTitle(
      alignment: ChartAlignment.center,
      text: chartTitle,
      textStyle: TextStyle(
        color: Colors.grey[700],
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final int y;
}

