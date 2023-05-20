import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final String subjectName;
  final int attendedLectures;
  final int totalLectures;

  SubjectCard({
    required this.subjectName,
    required this.attendedLectures,
    required this.totalLectures,
  });

  @override
  Widget build(BuildContext context) {
    var attendance =
        ((attendedLectures / totalLectures) * 100).toStringAsPrecision(4);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subjectName,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Attendance: $attendance %',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Total Lectures: $totalLectures',
                  style: const TextStyle(fontSize: 16.0),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Attended Lectures: $attendedLectures',
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
            IconButton(
              color: Colors.blue,
              icon: const Icon(Icons.add),
              onPressed: () {
                // Perform the desired action when the '+' button is pressed
              },
            ),
          ],
        ),
      ),
    );
  }
}

// Example usage:
class MyAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Subject Cards'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SubjectCard(
                subjectName: 'DSA',
                attendedLectures: 5,
                totalLectures: 10,
              ),
              SubjectCard(
                subjectName: 'EM-3',
                attendedLectures: 7,
                totalLectures: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
