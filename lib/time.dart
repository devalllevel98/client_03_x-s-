import 'dart:async';

import 'package:flutter/material.dart';

class RealTimeClock extends StatefulWidget {
  const RealTimeClock({Key? key}) : super(key: key);

  @override
  _RealTimeClockState createState() => _RealTimeClockState();
}

class _RealTimeClockState extends State<RealTimeClock> {
  late Stream<DateTime> _clockStream;
  late DateTime _currentTime;

  @override
  void initState() {
    super.initState();
    _currentTime = DateTime.now();
    _clockStream = Stream<DateTime>.periodic(Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Center(
        child: StreamBuilder<DateTime>(
          stream: _clockStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _currentTime = snapshot.data!;
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getTimeString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  String _getTimeString() {
    String hour = _currentTime.hour.toString().padLeft(2, '0');
    String minute = _currentTime.minute.toString().padLeft(2, '0');
    String second = _currentTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}

void main() {
  runApp(MaterialApp(
    home: RealTimeClock(),
  ));
}
