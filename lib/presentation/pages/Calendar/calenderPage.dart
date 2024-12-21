import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calenderpage extends StatefulWidget {
  const Calenderpage({Key? key}) : super(key: key);

  @override
  State<Calenderpage> createState() => _CalenderpageState();
}

class _CalenderpageState extends State<Calenderpage> {
  DateTime _selectedDate = DateTime.now();

  // Function to format the date for Firestore query
  String getFormattedDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  // Stream to fetch tasks based on the selected date
  Stream<QuerySnapshot> _getTasksForSelectedDate() {
    return FirebaseFirestore.instance
        .collection('tasks')
        .where('dueDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                _selectedDate.year, _selectedDate.month, _selectedDate.day)))
        .where('dueDate',
            isLessThan: Timestamp.fromDate(DateTime(
                    _selectedDate.year, _selectedDate.month, _selectedDate.day)
                .add(Duration(days: 1))))
        .orderBy('dueDate')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Calendar Timeline
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: CalendarTimeline(
                initialDate: _selectedDate,
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                onDateSelected: (date) {
                  if (date != null) {
                    setState(() {
                      _selectedDate = date;
                    });
                  }
                },
                leftMargin: 20,
                monthColor: Colors.white,
                dayColor: Colors.white,
                dayNameColor: Colors.white,
                showYears: true,
                activeDayColor: Colors.white,
                activeBackgroundDayColor: Colors.purpleAccent,
                dotColor: Colors.white,
                selectableDayPredicate: (date) {
                  return true;
                },
              ),
            ),

            // Task List for selected date
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                "Tasks for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _getTasksForSelectedDate(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No tasks for this day.",
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                  }

                  final tasks = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, index) {
                      final task = tasks[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color(0xff363636),
                              borderRadius: BorderRadius.circular(5)),
                          child: ListTile(
                            leading: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete Task"),
                                      content: Text(
                                          "Are you sure you want to delete this task?"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // Delete the task from Firestore
                                            FirebaseFirestore.instance
                                                .collection('tasks')
                                                .doc(task.id)
                                                .delete();
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text("Delete",
                                              style:
                                                  TextStyle(color: Colors.red)),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context)
                                                .pop(); // Close the dialog
                                          },
                                          child: Text("Cancel",
                                              style: TextStyle(
                                                  color: Colors.black)),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                            title: Text(
                              task['title'],
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  task['description'],
                                  style: TextStyle(color: Colors.white70),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Due Time: ${task['dueTime']}",
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
