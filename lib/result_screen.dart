import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, List<String>> results = {};
  bool resultsReady = false;
  List<int> selectedNumbersLo = [];
  List<int> selectedNumbersDe = [];

  @override
  void initState() {
    super.initState();
    loadSelectedNumbers();
    generateOrLoadResults();
  }

  

  void loadSelectedNumbers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedNumbersLo = prefs.getStringList('selectedNumbersLo');
    List<String>? savedNumbersDe = prefs.getStringList('selectedNumbersDe');

    if (savedNumbersLo != null) {
      setState(() {
        selectedNumbersLo = savedNumbersLo.map((e) => int.parse(e)).toList();
      });
    }

    if (savedNumbersDe != null) {
      setState(() {
        selectedNumbersDe = savedNumbersDe.map((e) => int.parse(e)).toList();
      });
    }
  }

  void generateOrLoadResults() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime now = DateTime.now();
    String currentDate = '${now.year}-${now.month}-${now.day}';
    List<String>? savedResults = prefs.getStringList(currentDate);

    if (savedResults != null) {
      // Load results from SharedPreferences
      results = {
        'Giai8': prefs.getStringList('Giai8')!,
        'Giai7': prefs.getStringList('Giai7')!,
        'Giai6': prefs.getStringList('Giai6')!,
        'Giai5': prefs.getStringList('Giai5')!,
        'Giai4': prefs.getStringList('Giai4')!,
        'Giai3': prefs.getStringList('Giai3')!,
        'Giai2': prefs.getStringList('Giai2')!,
        'Giai1': prefs.getStringList('Giai1')!,
        'GiaiDB': prefs.getStringList('GiaiDB')!,
      };
    } else {
      // Generate new results
      var random = Random();
      results = {
        'Giai8': List.generate(1, (_) => (random.nextInt(100)).toString().padLeft(2, '0')),
        'Giai7': List.generate(1, (_) => (random.nextInt(1000)).toString().padLeft(3, '0')),
        'Giai6': List.generate(3, (_) => (random.nextInt(10000)).toString().padLeft(4, '0')),
        'Giai5': List.generate(1, (_) => (random.nextInt(10000)).toString().padLeft(4, '0')),
        'Giai4': List.generate(7, (_) => (random.nextInt(100000)).toString().padLeft(5, '0')),
        'Giai3': List.generate(2, (_) => (random.nextInt(100000)).toString().padLeft(5, '0')),
        'Giai2': List.generate(1, (_) => (random.nextInt(100000)).toString().padLeft(5, '0')),
        'Giai1': List.generate(1, (_) => (random.nextInt(100000)).toString().padLeft(5, '0')),
        'GiaiDB': List.generate(1, (_) => (random.nextInt(1000000)).toString().padLeft(6, '0')),
      };

      // Save results to SharedPreferences
      List<String> resultsList = results.values.expand((list) => list).toList();
      prefs.setStringList(currentDate, resultsList);
    }

    setState(() {
      resultsReady = true;
    });
  }

  void saveResultToHistory(String title, List<String> numbers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = DateTime.now().toString();
    prefs.setStringList('historyTitle', [title]);
    prefs.setStringList('historyNumbers', numbers);
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
                bool isWinnerLo = selectedNumbersLo.any((selected) => number.endsWith(selected.toString().padLeft(2, '0')));
                bool isWinnerDe = selectedNumbersDe.any((selected) => number.endsWith(selected.toString().padLeft(2, '0')));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      if (isWinnerLo || isWinnerDe) {
                        saveResultToHistory(title, numbers);
                      }
                    },
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: isWinnerLo || isWinnerDe ? Colors.red : Colors.transparent,
                          ),
                          child: Text(
                            number,
                            style: TextStyle(
                              fontSize: 18,
                              color: isWinnerLo || isWinnerDe ? Colors.white : Colors.black,
                            ),
                          ),
                        ),
                        if (isWinnerLo || isWinnerDe)
                          Text(
                            'Bạn đã đánh trúng',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                      ],
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

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    bool showResults = now.hour >= 9;

    return Scaffold(
      appBar: AppBar(
        title: Text('Kết Quả Xổ Số'),
      ),
      body: resultsReady
          ? ListView(
              children: [
                if (!showResults) Center(child: Text('Kết quả chưa được mở')),
                if (selectedNumbersLo.isEmpty && selectedNumbersDe.isEmpty)
                  Center(child: Text('Chưa chọn số')),
                if (selectedNumbersLo.isNotEmpty || selectedNumbersDe.isNotEmpty)
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đánh Lô:'),
                          SizedBox(width: 8), // Khoảng cách giữa tiêu đề và các đĩa số
                          Wrap(
                            spacing: 4, // Khoảng cách giữa các đĩa số
                            children: selectedNumbersLo.map((num) {
                              String formattedNum = num.toString().padLeft(2, '0');
                              return Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 34, 0, 255),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  formattedNum,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),

                      // Tương tự cho số đề nếu có
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đánh đề:'),
                          SizedBox(width: 8),
                          Wrap(
                            spacing: 4,
                            children: selectedNumbersDe.map((num) {
                              String formattedNum = num.toString().padLeft(2, '0');
                              return Container(
                                padding: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 255, 0, 0),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  formattedNum,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                if (showResults)
                  ...results.entries.map((entry) {
                    return buildResultCard(entry.key, entry.value);
                  }).toList(),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}
