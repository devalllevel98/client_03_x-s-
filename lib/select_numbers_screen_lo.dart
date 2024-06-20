import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'result_screen.dart';
import 'dart:convert';
class SelectNumbersScreenLo extends StatefulWidget {
  @override
  _SelectNumbersScreenLoState createState() => _SelectNumbersScreenLoState();
}

class _SelectNumbersScreenLoState extends State<SelectNumbersScreenLo> {
  List<int> selectedNumbers = [];
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    checkDailySelection();
  }

  void checkDailySelection() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('selectedNumbersLoMap');
    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      DateTime now = DateTime.now();
      String currentDate = '${now.year}-${now.month}-${now.day}';

      if (jsonMap.containsKey(currentDate)) {
        List<String>? savedNumbers = List<String>.from(jsonMap[currentDate]);
        if (savedNumbers != null) {
          setState(() {
            selectedNumbers = savedNumbers.map((e) => int.parse(e)).toList();
            isConfirmed = true;
          });
        }
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

    bool canConfirm = selectedNumbers.length == 10 && !isConfirmed;

    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Chọn Số Đánh Đề',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255), // Thêm màu nền cho AppBar
      ),
      body: Stack(
        children: [
           Positioned.fill(
              child: Image.asset(
            'assets/bg.png',
            fit: BoxFit.fill,
          )),
          Column(
            children: [
              Row(
                children: [
                Text(
                    '   Số Chọn: ',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 60,
                      child: Wrap(
                        spacing: 8.0, // spacing between each number
                        runSpacing: 4.0, // spacing between rows
                        children: List.generate(selectedNumbers.length, (index) {
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
                              height: 30,
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
                        }),
                      ),
                    ),
                  ),
                  // Checkbox(
                  //   value: isConfirmed,
                  //   onChanged: (value) {
                  //     if (!isConfirmed) {
                  //       showDialog(
                  //         context: context,
                  //         builder: (context) => AlertDialog(
                  //           title: Text('Xác nhận chọn số'),
                  //           content: Text('Bạn có chắc chắn muốn xác nhận chọn số và không thể thay đổi sau này?'),
                  //           actions: [
                  //             TextButton(
                  //               onPressed: () {
                  //                 Navigator.of(context).pop();
                  //               },
                  //               child: Text('Không'),
                  //             ),
                  //             TextButton(
                  //               onPressed: canConfirm
                  //                   ? () {
                  //                       setState(() {
                  //                         isConfirmed = true;
                  //                       });
                  //                       saveSelectedNumbersToLocal();
                  //                       Navigator.of(context).pop();
                  //                     }
                  //                   : null,
                  //               child: Text('Đồng ý'),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                      
                  //     }
                  //   },
                  // ),
                ],
              ),
                           SizedBox(height: 50,),
              ElevatedButton(
              onPressed: () {
                if (!isConfirmed) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Xác nhận chọn số'),
                      content: Text(
                          'Bạn có chắc chắn muốn xác nhận chọn số và không thể thay đổi sau này?'),
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
            
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
             backgroundColor:isConfirmed ? Colors.orange:Color.fromARGB(255, 0, 34, 255) , // Màu chữ của nút
            shadowColor: Colors.black, // Màu bóng của nút
            elevation: 10, // Độ cao của bóng
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30), // Độ cong của viền nút
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10), // Khoảng cách padding
          ),
          child: Text(
            isConfirmed ? 'Đã xác nhận' : 'Xác nhận chọn số',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
             
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: 1,
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
                          final isSelectable = !isConfirmed && selectedNumbers.length < 10;
                          return GestureDetector(
                            onTap: () {
                              if (isSelectable) {
                                setState(() {
                                  if (isSelected) {
                                    selectedNumbers.remove(number);
                                  } else {
                                    if (selectedNumbers.length < 10) {
                                      selectedNumbers.add(number);
                                    }
                                  }
                                });
                              } else if (selectedNumbers.length < 10) {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('Thông báo'),
                                    content: Text('Vui lòng chọn đủ 10 số để tiếp tục.'),
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
    );
  }

  void saveSelectedNumbersToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Lấy dữ liệu đã lưu (nếu có) từ SharedPreferences
    String? jsonString = prefs.getString('selectedNumbersLoMap');
    Map<String, List<String>> selectedNumbersLoMap = {};

    if (jsonString != null) {
      Map<String, dynamic> jsonMap = json.decode(jsonString);
      jsonMap.forEach((key, value) {
        selectedNumbersLoMap[key] = List<String>.from(value);
      });
    }

    // Cập nhật dữ liệu với ngày hiện tại
    DateTime now = DateTime.now();
    String currentDate = '${now.year}-${now.month}-${now.day}';
    selectedNumbersLoMap[currentDate] = selectedNumbers.map((e) => e.toString()).toList();

    // Lưu lại dữ liệu vào SharedPreferences dưới dạng JSON
    String updatedJsonString = json.encode(selectedNumbersLoMap);
    prefs.setString('selectedNumbersLoMap', updatedJsonString);
  }
}



