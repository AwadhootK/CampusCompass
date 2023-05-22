import 'dart:developer' as dev;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class AttendancePieChart extends StatelessWidget {
  final Map<String, double> dataMap;

  const AttendancePieChart({required this.dataMap});

  List<Color> generateUniqueColors(int count) {
    Random random = Random();
    List<Color> colors = [];

    for (int i = 0; i < count; i++) {
      int red = random.nextInt(256);
      int green = random.nextInt(256);
      int blue = random.nextInt(256);

      Color color = Color.fromRGBO(red, green, blue, 1);
      colors.add(color);
    }

    return colors;
  }

  @override
  Widget build(BuildContext context) {
    dev.log(dataMap.toString());
    double overallAttendance = 0;
    dataMap.forEach((key, value) {
      overallAttendance += value;
    });
    overallAttendance /= dataMap.length;
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: const Text('Attendance Statistics'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PieChart(
            animationDuration: const Duration(milliseconds: 1500),
            dataMap: dataMap,
            chartLegendSpacing: 40,
            chartRadius: MediaQuery.of(context).size.width / 1.3,
            chartType: ChartType.disc,
            legendOptions: const LegendOptions(
              showLegendsInRow: true,
              legendPosition: LegendPosition.bottom,
              showLegends: true,
              legendTextStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            colorList: [
              Colors.blue[800]!,
              Colors.green,
              Colors.red,
              Colors.yellow,
              ...generateUniqueColors(dataMap.length - 4)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Overall Attendance: ${(overallAttendance * 100).toStringAsFixed(2)} % ',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
