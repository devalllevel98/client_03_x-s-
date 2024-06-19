import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    loadSelectedNumbersAndResults(selectedDate);
  }

  void loadSelectedNumbersAndResults(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    String? savedDate = prefs.getString('resultsDate_$formattedDate');

    if (savedDate != null && savedDate == formattedDate) {
      results = {
        'Giai8': prefs.getStringList('Giai8_$formattedDate') ?? [],
        'Giai7': prefs.getStringList('Giai7_$formattedDate') ?? [],
        'Giai6': prefs.getStringList('Giai6_$formattedDate') ?? [],
        'Giai5': prefs.getStringList('Giai5_$formattedDate') ?? [],
        'Giai4': prefs.getStringList('Giai4_$formattedDate') ?? [],
        'Giai3': prefs.getStringList('Giai3_$formattedDate') ?? [],
        'Giai2': prefs.getStringList('Giai2_$formattedDate') ?? [],
        'Giai1': prefs.getStringList('Giai1_$formattedDate') ?? [],
        'GiaiDB': prefs.getStringList('GiaiDB_$formattedDate') ?? [],
      };
    } else {
      results = {};
    }

    setState(() {
      resultsReady = true;
    });
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
      loadSelectedNumbersAndResults(selectedDate);
    }
  }

  @override
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
}
