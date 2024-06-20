import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'dart:convert';

class ResultScreen extends StatefulWidget {
  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Map<String, Map<String, List<String>>> results = {};
  bool resultsReady = false;
  List<int> selectedNumbersLo = [];
  List<int> selectedNumbersDe = [];
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    loadSelectedNumbers(selectedDate);
    generateOrLoadResults(selectedDate);
  }

  void loadSelectedNumbers(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    String? jsonStringLo = prefs.getString('selectedNumbersLoMap');
    String? jsonStringDe = prefs.getString('selectedNumbersDeMap');

    if (jsonStringLo != null) {
      Map<String, dynamic> jsonMapLo = json.decode(jsonStringLo);
      if (jsonMapLo.containsKey(formattedDate)) {
        setState(() {
          selectedNumbersLo = List<String>.from(jsonMapLo[formattedDate])
              .map((e) => int.parse(e))
              .toList();
        });
      } else {
        setState(() {
          selectedNumbersLo = [];
        });
      }
    } else {
      setState(() {
        selectedNumbersLo = [];
      });
    }

    if (jsonStringDe != null) {
      Map<String, dynamic> jsonMapDe = json.decode(jsonStringDe);
      if (jsonMapDe.containsKey(formattedDate)) {
        setState(() {
          selectedNumbersDe = List<String>.from(jsonMapDe[formattedDate])
              .map((e) => int.parse(e))
              .toList();
        });
      } else {
        setState(() {
          selectedNumbersDe = [];
        });
      }
    } else {
      setState(() {
        selectedNumbersDe = [];
      });
    }
  }

  void generateOrLoadResults(DateTime date) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String formattedDate = '${date.year}-${date.month}-${date.day}';
    String? jsonStringResults = prefs.getString('resultsMap');
    Map<String, dynamic> resultsMap =
        jsonStringResults != null ? json.decode(jsonStringResults) : {};

    if (resultsMap.containsKey(formattedDate)) {
      // Load results from SharedPreferences
      List<dynamic> dailyResults = resultsMap[formattedDate];
      results[formattedDate] = groupResultsByTitle(dailyResults);
    } else {
      // Generate random results and save to SharedPreferences
      Map<String, List<String>> generatedResults = generateRandomResults();
      results[formattedDate] = generatedResults;

      // Save results to SharedPreferences
      prefs.setString('resultsMap', json.encode({ ...resultsMap, formattedDate: flattenResults(generatedResults) }));
    }

    setState(() {
      resultsReady = true;
    });
  }

  Map<String, List<String>> groupResultsByTitle(List<dynamic> dailyResults) {
    Map<String, List<String>> groupedResults = {};

    dailyResults.forEach((result) {
      String title = result['title'];
      String number = result['number'];

      if (groupedResults.containsKey(title)) {
        groupedResults[title]!.add(number);
      } else {
        groupedResults[title] = [number];
      }
    });

    return groupedResults;
  }

  List<dynamic> flattenResults(Map<String, List<String>> results) {
    List<dynamic> flattenedResults = [];

    results.forEach((title, numbers) {
      numbers.forEach((number) {
        flattenedResults.add({'title': title, 'number': number});
      });
    });

    return flattenedResults;
  }

  Map<String, List<String>> generateRandomResults() {
    Random random = Random();
    Map<String, List<String>> randomResults = {
      'Giai 8': [random.nextInt(100).toString()],
      'Giai 7': [random.nextInt(1000).toString()],
      'Giai 6': [random.nextInt(10000).toString(), random.nextInt(10000).toString(), random.nextInt(10000).toString()],
      'Giai 5': [random.nextInt(10000).toString()],
      'Giai 4': [random.nextInt(100000).toString(), random.nextInt(100000).toString(), random.nextInt(100000).toString(), random.nextInt(100000).toString(), random.nextInt(100000).toString(), random.nextInt(100000).toString(), random.nextInt(100000).toString()],
      'Giai 3': [random.nextInt(100000).toString(), random.nextInt(100000).toString()],
      'Giai 2': [random.nextInt(100000).toString()],
      'Giai 1': [random.nextInt(100000).toString()],
      'Giai DB': [random.nextInt(1000000).toString()]
    };

    return randomResults;
  }

  Color getColorForNumber(String number, List<int> selectedNumbers) {
    int lastTwoDigits = int.parse(number.substring(number.length - 2));
    return selectedNumbers.contains(lastTwoDigits) ? Colors.green : Colors.blue;
  }

Widget buildResultCard(String title, Map<String, List<String>> results) {
  List<String> wonPrizes = [];

  // Function to check if the user has selected any winning numbers in a category
  bool hasWonInCategory(String category, List<int> selectedNumbers) {
    if (results.containsKey(category)) {
      List<String> categoryResults = results[category]!;
      return categoryResults.any((num) => selectedNumbers.contains(int.parse(num)));
    }
    return false;
  }

  // Check each prize category
  bool isLoSelected = selectedNumbersLo.isNotEmpty && [
    'Giai 8', 'Giai 7', 'Giai 6', 'Giai 5', 'Giai 4', 'Giai 3', 'Giai 2', 'Giai 1'
  ].any((category) => hasWonInCategory(category, selectedNumbersLo));

  bool isDeSelected = selectedNumbersDe.isNotEmpty && [
    'Giai DB'
  ].any((category) => hasWonInCategory(category, selectedNumbersDe));

  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: results.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.key,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: entry.value.map((value) {
                      Color backgroundColor = getColorForNumber(value, selectedNumbersLo);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: backgroundColor,
                          ),
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 8),
              ],
            );
          }).toList(),
        ),
        if (isLoSelected || isDeSelected)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isLoSelected)
                  Row(
                    children: [
                      Text(
                        'Kết quả Lô1: ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Chúc mừng bạn đã đánh trúng!',
                        style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                if (isDeSelected)
                  Row(
                    children: [
                      Text(
                        'Kết quả Đề: ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Chúc mừng bạn đã đánh trúng!',
                        style: TextStyle(color: Colors.green, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
              ],
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
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? picked = await showDatePicker(
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
                loadSelectedNumbers(selectedDate);
                generateOrLoadResults(selectedDate);
              }
            },
            icon: Icon(Icons.calendar_today),
          ),
        ],
      ),
      body: resultsReady
          ? ListView(
              padding: EdgeInsets.all(16),
              children: [
                if (!showResults) Center(child: Text('Kết quả chưa được mở')),
                if (selectedNumbersLo.isEmpty && selectedNumbersDe.isEmpty)
                  Center(child: Text('Chưa chọn số')),
                if (selectedNumbersLo.isNotEmpty || selectedNumbersDe.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đánh Lô:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Wrap(
                            spacing: 4,
                            children: selectedNumbersLo.isEmpty
                                ? [Text('Chưa chọn')]
                                : selectedNumbersLo.map((num) {
                                    return Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 0, 153, 255),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        num.toString().padLeft(2, '0'),
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
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Kết Quả Đánh Lô: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          //code thêm để ví dụ đánh trúng: chúc mừng đánh trúng : 44, 66. đánh trật báo là không trúng
                          SizedBox(width: 8),
                        ],
                      ),

                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Đánh Đề:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Wrap(
                            spacing: 4,
                            children: selectedNumbersDe.isEmpty
                                ? [Text('Chưa chọn')]
                                : selectedNumbersDe.map((num) {
                                    return Container(
                                      padding: EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 0, 0),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        num.toString().padLeft(2, '0'),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text('Kết Quả Đánh đề: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          //code thêm để ví dụ đánh trúng: chúc mừng đánh trúng : 44, 66... đánh trật báo là không trúng
                        ],
                      ),
                      
                      SizedBox(height: 8),
                    ],
                    
                    
                  ),
                SizedBox(height: 16),
                for (var entry in results.entries)
                  if (entry.key == '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}')
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ngày ${entry.key}:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        buildResultCard(entry.key, entry.value),
                        SizedBox(height: 16),
                      ],
                    ),
              ],
            )
          : Center(child: CircularProgressIndicator()),
    );
  }
}


