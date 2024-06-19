import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'result_screen.dart';

class SelectNumbersScreenDe extends StatefulWidget {
  @override
  _SelectNumbersScreenDeState createState() => _SelectNumbersScreenDeState();
}

class _SelectNumbersScreenDeState extends State<SelectNumbersScreenDe> {
  List<int> selectedNumbers = [];
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    checkDailySelection();
  }

  void checkDailySelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedDate = prefs.getString('selectedDateDe');
    DateTime now = DateTime.now();
    String currentDate = '${now.year}-${now.month}-${now.day}';

    if (savedDate != currentDate) {
      prefs.remove('selectedNumbersDe');
      prefs.remove('selectedDateDe');
    } else {
      List<String>? savedNumbers = prefs.getStringList('selectedNumbersDe');
      if (savedNumbers != null) {
        setState(() {
          selectedNumbers = savedNumbers.map((e) => int.parse(e)).toList();
          isConfirmed = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    final int crossAxisCount = 10;
    final double itemHeight = (screenHeight * 4 / 5) / (100 / crossAxisCount).ceil();
    final double itemWidth = screenWidth / crossAxisCount;
    final double childAspectRatio = itemWidth / itemHeight;

    bool canConfirm = selectedNumbers.length == 2 && !isConfirmed;

    return Scaffold(
      appBar: AppBar(
        title: Text('Chọn Số Đánh Đề'),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Text("Đánh đề: "),
                  Expanded(
                    child: Container(
                      height: 50,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: selectedNumbers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              if (!isConfirmed) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Xóa số'),
                                    content: Text('Bạn có chắc chắn muốn xóa số ${selectedNumbers[index]}?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Không'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedNumbers.removeAt(index);
                                          });
                                          // saveSelectedNumbersToLocal();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Đồng ý'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              width: 30,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              margin: EdgeInsets.symmetric(horizontal: 4),
                              child: Center(
                                child: Text(
                                  selectedNumbers[index].toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Checkbox(
                    value: isConfirmed,
                    onChanged: (value) {
                      if (!isConfirmed) {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Xác nhận chọn số'),
                            content: Text('Bạn có chắc chắn muốn xác nhận chọn số và không thể thay đổi sau này?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Không'),
                              ),
                              TextButton(
                                onPressed: canConfirm
                                    ? () {
                                        setState(() {
                                          isConfirmed = true;
                                        });
                                        saveSelectedNumbersToLocal();
                                        Navigator.of(context).pop();
                                      }
                                    : null,
                                child: Text('Đồng ý'),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 4 / 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          mainAxisSpacing: 0,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: 100,
                        itemBuilder: (context, index) {
                          final number = index;
                          final isSelected = selectedNumbers.contains(number);
                          final isSelectable = !isConfirmed && selectedNumbers.length < 2;
                          return GestureDetector(
                            onTap: () {
                              if (isSelectable) {
                                setState(() {
                                  if (isSelected) {
                                    selectedNumbers.remove(number);
                                  } else {
                                    if (selectedNumbers.length < 2) {
                                      selectedNumbers.add(number);
                                    }
                                  }
                                });
                              } else if (selectedNumbers.length < 2) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Thông báo'),
                                    content: Text('Vui lòng chọn đủ 2 số để tiếp tục.'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('OK'),
                                      ),
                                    ],
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected ? Colors.blue : Colors.grey,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  number.toString().padLeft(2, '0'),
                                  style: TextStyle(
                                    color: isConfirmed
                                        ? Colors.grey
                                        : (isSelected ? Colors.blue : Colors.black),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     if (isConfirmed) {
      //       Navigator.push(
      //         context,
      //         MaterialPageRoute(builder: (context) => ResultScreen(selectedNumbers: selectedNumbers)),
      //       );
      //     } else {
      //       showDialog(
      //         context: context,
      //         builder: (context) => AlertDialog(
      //           title: Text('Thông báo'),
      //           content: Text('Vui lòng xác nhận chọn đúng 2 số.'),
      //           actions: [
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.of(context).pop();
      //               },
      //               child: Text('OK'),
      //             ),
      //           ],
      //         ),
      //       );
      //     }
      //   },
      //   child: Icon(Icons.check),
      // ),
   
    );
  }

  void saveSelectedNumbersToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('selectedNumbersDe', selectedNumbers.map((e) => e.toString()).toList());

    DateTime now = DateTime.now();
    String selectedDate = '${now.year}-${now.month}-${now.day}';
    prefs.setString('selectedDateDe', selectedDate);
  }
}