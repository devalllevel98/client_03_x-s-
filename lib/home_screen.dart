import 'package:flutter/material.dart';
import 'package:xosoonline/debug.dart';
import 'package:xosoonline/historyScreen.dart';
import 'package:xosoonline/result_screen.dart';
import 'package:xosoonline/select_numbers_screen_lo.dart';
import 'select_numbers_screen_de.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lô Đề Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectNumbersScreenDe()),
                );
              },
              child: Text('Chơi Lô Đề'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SelectNumbersScreenLo()),
                );
              },
              child: Text('Chơi Lô'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen()),
                );
              },
              child: Text('Ket qua'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
              child: Text('Lịch sử'),
            ),
           ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DebugDataScreen()),
                );
              },
              child: Text('bug'),
            ),
            // Bạn có thể thêm các nút khác tại đây cho các trò chơi khác.
          ],
        ),
      ),
    );
  }
}
