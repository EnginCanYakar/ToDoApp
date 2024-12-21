import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

class FocusPage extends StatefulWidget {
  @override
  _FocusPageState createState() => _FocusPageState();
}

class _FocusPageState extends State<FocusPage> {
  Duration _totalDuration = Duration.zero;
  Duration _remainingTime = Duration.zero;
  double _progress = 1.0;
  bool _isRunning = false;
  Timer? _timer;

  // Controllers for the text inputs
  TextEditingController _hoursController = TextEditingController();
  TextEditingController _minutesController = TextEditingController();

  void _startTimer() {
    if (_isRunning || _totalDuration == Duration.zero) return;

    setState(() {
      _remainingTime = _totalDuration;
      _progress = 1.0;
      _isRunning = true;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime.inSeconds > 0) {
          _remainingTime -= Duration(seconds: 1);
          _progress = _remainingTime.inSeconds / _totalDuration.inSeconds;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _showNotification();
          _saveSession(_totalDuration.inMinutes);
        }
      });
    });
  }

  void _resetTimer() {
    setState(() {
      _timer?.cancel();
      _progress = 1.0;
      _isRunning = false;
      _remainingTime = _totalDuration;
    });
  }

  void _showNotification() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Time\'s up!'),
        content: Text('You completed your session!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveSession(int duration) async {
    await FirebaseFirestore.instance.collection('sessions').add({
      'duration': duration,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> _selectTime() async {
    // Show dialog for the user to input hours and minutes
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select Time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Hours input
              TextField(
                controller: _hoursController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Hours',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // You can optionally validate user input here
                },
              ),
              SizedBox(height: 10),
              // Minutes input
              TextField(
                controller: _minutesController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Minutes',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  // You can optionally validate user input here
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                // Convert the entered text to integers and update the timer
                int hours = int.tryParse(_hoursController.text) ?? 0;
                int minutes = int.tryParse(_minutesController.text) ?? 0;

                setState(() {
                  _totalDuration = Duration(
                    hours: hours,
                    minutes: minutes,
                  );
                  _remainingTime = _totalDuration;
                });

                // Clear the text fields
                _hoursController.clear();
                _minutesController.clear();

                Navigator.of(context).pop();
              },
              child: Text('Set Time'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isRunning ? null : _selectTime,
              child: Text('Select Time'),
            ),
            SizedBox(height: 20),
            // Circular Progress Timer
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 200,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 8,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${_remainingTime.inHours.toString().padLeft(2, '0')}:${_remainingTime.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(_remainingTime.inSeconds % 60).toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _isRunning ? 'Remaining Time' : 'Select time to start',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 30),
            // Timer Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _resetTimer : null,
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
