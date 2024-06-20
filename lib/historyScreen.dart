import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  DateTime selectedDate = DateTime.now();
  Map<String, List<String>> results = {};
  bool resultsReady = false;

  @override
  void initState() {
    super.initState();
    loadResultsForDate(selectedDate);
  }

  void loadResultsForDate(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    String? jsonStringHistory = prefs.getString('historyMap');

    if (jsonStringHistory != null) {
      Map<String, dynamic> historyMap = json.decode(jsonStringHistory);
      if (historyMap.containsKey(formattedDate)) {
        dynamic historyData = historyMap[formattedDate];
        if (historyData is List<dynamic>) {
          List<String> resultList = historyData.map((item) => item.toString()).toList();
          results = {formattedDate: resultList};
        } else {
          results = {};
        }
      } else {
        results = {};
      }
    } else {
      results = {};
    }

    setState(() {
      resultsReady = true;
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        resultsReady = false; // Reset results
      });
      loadResultsForDate(selectedDate);
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lịch Sử'),
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
      body: resultsReady
          ? ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
                if (results.isNotEmpty)
                  ...results.entries.map((entry) {
                    return buildResultCard(entry.key, entry.value);
                  }).toList()
                else
                  Center(child: Text('Không có kết quả nào cho ngày này')),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildResultCard(String title, List<String> numbers) {
    return Card(
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: numbers.map((number) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    number,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                );
              }).toList().expand((element) => [element, Text(' - ')]).toList()..removeLast(),
            ),
          ),
        ],
      ),
    );
  }
}
