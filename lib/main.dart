import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Pomodoro App',
      home: PomodoroScreen(),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  const PomodoroScreen({super.key});

  @override
  PomodoroScreenState createState() => PomodoroScreenState();
}

class PomodoroScreenState extends State<PomodoroScreen> {
  int workDuration = 25;
  int breakDuration = 5;
  bool isWorking = true;
  bool isRunning = false;
  bool isPaused = false;
  int currentTime = 25 * 60; // Initial time in seconds

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pomodoro App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              isWorking ? 'Work Time' : 'Break Time',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              formatTime(currentTime),
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? null : () => startTimer(isWorking),
                  child: const Text('Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: isRunning ? () => pauseTimer() : null,
                  child: const Text('Pause'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: resetTimer,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildDurationButton('Work', workDuration),
                buildDurationButton('Break', breakDuration),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDurationButton(String label, int duration) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: isRunning ? null : () => setDuration(label, duration),
          child: Text('$duration min'),
        ),
      ],
    );
  }

  void setDuration(String label, int duration) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Set $label Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select $label duration in minutes:'),
              const SizedBox(height: 20),
              DropdownButton<int>(
                value: duration,
                items: [15, 20, 25, 30, 45, 60]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('$value min'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    if (label == 'Work') {
                      workDuration = value!;
                    } else {
                      breakDuration = value!;
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void startTimer(bool isWorking) {
    setState(() {
      isRunning = true;
    });
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!isPaused) {
        if (currentTime > 0) {
          setState(() {
            currentTime--;
          });
        } else {
          timer.cancel();
          setState(() {
            isWorking = !isWorking;
            currentTime = isWorking ? workDuration * 60 : breakDuration * 60;
            isRunning = false;
          });
        }
      }
    });
  }

  void pauseTimer() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void resetTimer() {
    setState(() {
      isRunning = false;
      isPaused = true;
      isWorking = false;
      currentTime = workDuration * 60;
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
