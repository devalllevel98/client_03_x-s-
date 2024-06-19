import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DebugDataScreen extends StatefulWidget {
  @override
  _DebugDataScreenState createState() => _DebugDataScreenState();
}

class _DebugDataScreenState extends State<DebugDataScreen> {
  List<String> historyTitle = [];
  List<List<String>> historyNumbers = [];

  @override
  void initState() {
    super.initState();
    loadHistoryData();
  }

  void loadHistoryData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedHistoryTitle = prefs.getStringList('historyTitle');
    List<String>? savedHistoryNumbers = prefs.getStringList('historyNumbers');

    if (savedHistoryTitle != null && savedHistoryNumbers != null) {
      setState(() {
        historyTitle = savedHistoryTitle;
        historyNumbers = savedHistoryNumbers.map((numbers) => numbers.split(',')).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Debug Data'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'History Title:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (historyTitle.isEmpty)
              Text(
                'No history titles found.',
                style: TextStyle(color: Colors.red),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: historyTitle.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        historyTitle[index],
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
            SizedBox(height: 16),
            Text(
              'History Numbers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            if (historyNumbers.isEmpty)
              Text(
                'No history numbers found.',
                style: TextStyle(color: Colors.red),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                itemCount: historyNumbers.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        historyNumbers[index].join(' - '),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

