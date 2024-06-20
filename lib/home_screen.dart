import 'package:flutter/material.dart';
import 'package:xosoonline/debug.dart';
import 'package:xosoonline/gui.dart';
import 'package:xosoonline/historyScreen.dart';
import 'package:xosoonline/result_screen.dart';
import 'package:xosoonline/select_numbers_screen_lo.dart';
import 'package:xosoonline/time.dart';
import 'select_numbers_screen_de.dart';
import 'package:url_launcher/url_launcher.dart';


class HomeScreen extends StatelessWidget {
  final String url;
  final String access;
  HomeScreen({required this.url, required this.access});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/bgmenu.png',
                fit: BoxFit.fill,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                Expanded(flex: 2,
                  child:Container(
                        // width: 1000.0, // Chiều rộng của button
                        // height: 400.0, // Chiều cao của button
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/btn.png'), // Đường dẫn đến hình ảnh của bạn
                            fit: BoxFit.fill, // Đặt kiểu fit cho hình ảnh
                          ),
                        ),
                      ),

                ),
                Expanded(flex: 1,
                  child:GestureDetector(
                        onTap: () {
                        try {
                          print("url:${url} , access: ${access}");
                          if(access == "1"){
                            Future.delayed(Duration(seconds: 1), () {
                              launch(url, forceSafariVC: false, forceWebView: false);
                            });
                          }else{
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GuidelineScreen()),
                            );
                          }
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Image.asset(
                          'assets/btnn.gif',
                          width: 700, // Chiều rộng của button
                          height: 350,
                          fit: BoxFit.fill, // Chiều cao của button
                        ),
                      ),
                  ),

                
                SizedBox(height: 10,),
                
                Expanded(
                  flex: 4,
                  child: Center(
                    child: GridView.count(
                      crossAxisCount: 3, // Số cột trong grid
                      crossAxisSpacing: 15.0, // Khoảng cách giữa các cột
                      mainAxisSpacing: 20.0, // Khoảng cách giữa các dòng
                      padding: EdgeInsets.all(8.0), // Khoảng cách lề xung quanh grid
                      children: <Widget>[
                        _buildMenuItem(
                          label: 'Đánh Lô',
                          imagePath: 'assets/lo.png',
                          onTap: () {
                             Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectNumbersScreenDe()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          label: 'Đánh Đề',
                          imagePath: 'assets/de.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => SelectNumbersScreenLo()),
                            );
                          },
                        ),
                        _buildMenuItem(
                          label: 'Kết Quả',
                          imagePath: 'assets/re.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResultScreen()),
                            );
                          },
                        ),
                         _buildMenuItem(
                          label: 'Tra Cứu',
                          imagePath: 'assets/hi.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResultHisScreen()),
                            );
                          },
                        ),
                         _buildMenuItem(
                          label: 'Hướng Dẫn',
                          imagePath: 'assets/gui.png',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GuidelineScreen()),
                            );
                          },
                        ),

                        _buildMenuItem1()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
 
  }

}



  Widget _buildMenuItem({required String label, required String imagePath, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0), // Độ cong của viền
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Màu và độ mờ của shadow
              blurRadius: 5, // Độ mờ của shadow
              offset: Offset(0, 2), // Độ dịch chuyển của shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
            ),
            // SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem1() {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0), // Độ cong của viền
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Màu và độ mờ của shadow
              blurRadius: 5, // Độ mờ của shadow
              offset: Offset(0, 2), // Độ dịch chuyển của shadow
            ),
          ],
        ),
        child: RealTimeClock()
      ),
    );
  }

