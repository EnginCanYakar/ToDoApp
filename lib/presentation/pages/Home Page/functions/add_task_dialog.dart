import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'FirestoreService.dart';

class AddTaskDialog extends StatefulWidget {
  final DocumentSnapshot? task;

  const AddTaskDialog({this.task});

  @override
  _AddTaskDialogState createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!['title'];
      _descriptionController.text = widget.task!['description'];
      selectedDate = widget.task!['dueDate'].toDate();
      selectedTime = TimeOfDay.fromDateTime(widget.task!['dueDate'].toDate());
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedTime)
      setState(() {
        selectedTime = picked;
      });
  }

  void _saveTask() {
    if (_titleController.text.isNotEmpty &&
        _descriptionController.text.isNotEmpty) {
      if (widget.task != null) {
        // Update existing task
        FirestoreService.updateTask(
            widget.task!.id,
            _titleController.text,
            _descriptionController.text,
            selectedDate ?? DateTime.now(),
            selectedTime?.format(context) ?? 'No time set');
      } else {
        // Add new task
        FirestoreService.addTask(
          _titleController.text,
          _descriptionController.text,
          selectedDate ?? DateTime.now(),
          selectedTime?.format(context) ?? 'No time set',
        );
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shadowColor: Colors.white,
      elevation: 8,
      backgroundColor: Color(0xff363636),
      title: Text(
        widget.task == null ? "Add Task" : "Edit Task",
        style: TextStyle(color: Colors.white),
      ),
      content: SizedBox(
        height: 250,
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white)),
            ),
            Row(
              children: [
                Text(
                  selectedDate == null
                      ? "Select Date"
                      : DateFormat('yyyy-MM-dd').format(selectedDate!),
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today, color: Colors.white),
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  selectedTime == null
                      ? "Select Time"
                      : selectedTime!.format(context),
                  style: TextStyle(color: Colors.white),
                ),
                IconButton(
                  icon: Icon(Icons.access_time, color: Colors.white),
                  onPressed: () => _selectTime(context),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel", style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: _saveTask,
          child: Text(
            widget.task == null ? "Add" : "Save",
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    );
  }
}
