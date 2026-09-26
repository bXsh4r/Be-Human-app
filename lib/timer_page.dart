import 'dart:async';

import 'package:flutter/material.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({
    super.key,
    required this.startTime,
    required this.endTime
  });

  final TimeOfDay startTime;
  final TimeOfDay endTime;

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _totalSeconds = 0;

  @override
  void initState() {
    super.initState();
    _calculateDuration();
  }

  void _calculateDuration() {
    int endTimeMin = widget.endTime.hour * 60 + widget.endTime.minute;
    int startTimeMin = widget.startTime.hour * 60 + widget.startTime.minute;

    _totalSeconds = (endTimeMin - startTimeMin) * 60;
  }

  void _startTimer(){

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if(_totalSeconds > 0) {
          _totalSeconds--;
        }else {
          timer.cancel();
        }
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    int displayMinutes = _totalSeconds ~/ 60;
    int displaySeconds = _totalSeconds % 60;

    String minutesString = displayMinutes.toString().padLeft(2, '0');
    String secondsString = displaySeconds.toString().padLeft(2, '0');

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text(
              '$minutesString:$secondsString'
            ),
            ElevatedButton(
              onPressed: _startTimer, 
              child: Text('START')
            ),
            ElevatedButton(
              onPressed:() {
                setState(() {
                  _timer?.cancel();
                  _totalSeconds = 0;
                });
                
               // 
              }, 
              child: Text('CANCEL'))
          ],
        )
      )
    );
  }
}