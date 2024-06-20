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
  // Function to map titles
  String mapTitle(String key) {
    switch (key) {
      case 'Giai 8':
        return 'Giải Tám';
      case 'Giai 7':
        return 'Giải Bảy';
      case 'Giai 6':
        return 'Giải Sáu';
      case 'Giai 5':
        return 'Giải Năm';
      case 'Giai 4':
        return 'Giải Tư';
      case 'Giai 3':
        return 'Giải Ba';
      case 'Giai 2':
        return 'Giải Nhì';
      case 'Giai 1':
        return 'Giải Nhất';
      case 'Giai DB':
        return 'Giải Đặc Biệt';
      default:
        return key; // Return original key if not matched
    }
  }

  return Card(
     color: Color.fromARGB(255, 234, 234, 234).withOpacity(0.9), 
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Text(
        //   title,
        //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        // ),
        SizedBox(height: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: results.entries.map((entry) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  mapTitle(entry.key), // Use mapTitle function here
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
      ],
    ),
  );
}

String checkWinningNumbers(List<int> selectedNumbers, Map<String, Map<String, List<String>>> results, DateTime selectedDate) {
  String formattedDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
  
  if (results.containsKey(formattedDate)) {
    List<String> winningNumbers = [];
    selectedNumbers.forEach((num) {
      String formattedNum = num.toString().padLeft(2, '0');
      results[formattedDate]!.forEach((title, numbers) {
        numbers.forEach((number) {
          if (number.endsWith(formattedNum)) {
            winningNumbers.add('$title: $number');
          }
        });
      });
    });

    return winningNumbers.isEmpty ? 'Đánh trật!' : 'Chúc mừng đánh trúng!';
    // return winningNumbers.isEmpty ? 'Đánh trật!' : 'Chúc mừng đánh trúng!: ${winningNumbers.join(", ")}';

  } else {
    return 'Không có kết quả cho ngày này';
  }
}

String checkWinningNumbersDe(List<int> selectedNumbers, Map<String, Map<String, List<String>>> results, DateTime selectedDate) {
  String formattedDate = '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}';
  
  if (results.containsKey(formattedDate)) {
    List<String> winningNumbers = [];
    selectedNumbers.forEach((num) {
      String formattedNum = num.toString().padLeft(2, '0');
      
      // Only check for special prize (giải đặc biệt)
      List<String>? specialNumbers = results[formattedDate]!['Giai DB']; // Adjust 'Giải đặc biệt' to match your actual key
      
      if (specialNumbers != null) {
        specialNumbers.forEach((number) {
          if (number.endsWith(formattedNum)) {
            winningNumbers.add('Giải đặc biệt: $number');
          }
        });
      }
    });

    return winningNumbers.isEmpty ? 'Đánh trật!' : 'Chúc mừng đánh trúng!';
    // return winningNumbers.isEmpty ? 'Đánh trật!' : 'Chúc mừng đánh trúng!: ${winningNumbers.join(", ")}';

  } else {
    return 'Không có kết quả cho ngày này';
  }
}



@override
Widget build(BuildContext context) {
  DateTime now = DateTime.now();
  bool showResults = now.hour >= 17; // Chỉ hiển thị sau 5 giờ chiều

  return Scaffold(
    appBar:  AppBar(
        title: 
        Text(
          'Kết Quả Xổ Số Hôm Nay',
          style: TextStyle(
            fontSize: 19,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Thêm màu nền cho AppBar
      ),
    body:Stack(
      children: [
        Positioned.fill(
              child: Image.asset(
            'assets/bg.png',
            fit: BoxFit.fill,
          )),
     resultsReady
        ? ListView(
            padding: EdgeInsets.all(16),
            children: [
              if (selectedNumbersLo.isEmpty && selectedNumbersDe.isEmpty)
                Center(child: Text('Chưa chọn số', style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),)),
              if (selectedNumbersLo.isNotEmpty || selectedNumbersDe.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Đánh Đề:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Wrap(
                          spacing: 4,
                          children: selectedNumbersLo.isEmpty
                              ? [Text('Chưa chọn')]
                              : selectedNumbersLo.map((num) {
                                  print("de ${num}");
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
                        Text('Kết Quả: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text(
                         showResults ? checkWinningNumbersDe(selectedNumbersLo, results, selectedDate): "Chưa có kết quả!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Đánh Lô:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Wrap(
                          spacing: 4,
                          children: selectedNumbersDe.isEmpty
                              ? [Text('Chưa chọn')]
                              : selectedNumbersDe.map((num) {
                                print("Lô${num}");
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
                        Text('Kết Quả: ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text(
                         showResults? checkWinningNumbers(selectedNumbersDe, results, selectedDate):"Chưa có kết quả!",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                  ],
                ),
            if (!showResults) 
            Center(
              child:Column(
                children: [
                  SizedBox(height: 40,),
               Image.asset(
                'assets/nnot.png', // Đường dẫn đến hình ảnh trong assets
                width: 500, // Độ rộng của hình ảnh
                height: 500, // Độ cao của hình ảnh
                fit: BoxFit.contain, // Đảm bảo hình ảnh vừa với khu vực được cung cấp
              ),
            
                ],
              ),

            ),
              SizedBox(height: 16),
              for (var entry in results.entries)
                if (entry.key == '${selectedDate.year}-${selectedDate.month}-${selectedDate.day}')
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      showResults ? buildResultCard(entry.key, entry.value):SizedBox(),
                      SizedBox(height: 16),
                    ],
                  ),
            ],
          )
        : Center(child: CircularProgressIndicator()),
 

      ],
    )

  );
}

}


