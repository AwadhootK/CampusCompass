import 'package:firebase/screens/Attendance/Attendance_screen.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatefulWidget {
  final String subjectName;
  final int attendedLectures;
  final int totalLectures;
  final Function deleteSubject;
  final Function incrementCount;

  SubjectCard({
    required this.subjectName,
    required this.attendedLectures,
    required this.totalLectures,
    required this.deleteSubject,
    required this.incrementCount,
  });

  @override
  State<SubjectCard> createState() => _SubjectCardState();
}

class _SubjectCardState extends State<SubjectCard> {
  @override
  Widget build(BuildContext context) {
    var attendance = ((widget.attendedLectures / widget.totalLectures) * 100)
        .toStringAsPrecision(4);
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.subjectName,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Attendance: $attendance %',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Total Lectures: ${widget.totalLectures}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                  const SizedBox(height: 2.0),
                  Text(
                    'Attended Lectures: ${widget.attendedLectures}',
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
              IconButton(
                color: Colors.blue,
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await widget.incrementCount(
                      widget.subjectName, widget.attendedLectures, true);

                  // setState(() {
                  //   details = fetch();
                  //   details['attended']++;
                  //   PostRecord();
                  // });
                  // Perform the desired action when the '+' button is pressed
                },
              ),
              IconButton(
                color: Colors.blue,
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await widget.deleteSubject(widget.subjectName);
                  // setState(() {
                  //   details = fetch();
                  //   details['attended']++;
                  //   PostRecord();
                  // });
                  // Perform the desired action when the '+' button is pressed
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
