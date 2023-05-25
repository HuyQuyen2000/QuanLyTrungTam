import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/login.dart';
import 'package:quanlitrungtam_app/rooms_student.dart';
import 'package:quanlitrungtam_app/profile_student.dart';
import 'package:quanlitrungtam_app/calender_s.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentMenuScreen extends StatefulWidget{
  const StudentMenuScreen({Key? key}) : super(key: key);

  @override
  State<StudentMenuScreen> createState() => _StudentMenuScreenState();
}

class _StudentMenuScreenState extends State<StudentMenuScreen>{
  PageController page = PageController();
  
  String _email = '';
  String _name = '';
  // String _type = '1';

  // var _user = null;


  loadUser() async{
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');
    if(user != null){
      setState(() {
      _email = jsonDecode(user)['email'].toString();
      _name = jsonDecode(user)['name'].toString();

      });
      
    }
    else{
      setState(() {
      _email = 'Lỗi';
      _name = 'Lỗi';
      });  
    }
    


  }

  exitPressed() async{
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => LoginScreenb()),
    // );
    // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //   backgroundColor: Colors.green,
    //   content: Text('Đăng xuất thành công'),
    //   duration: const Duration(milliseconds: 1400),
    // ));
    final storage = new FlutterSecureStorage();
    final token = await storage.read(key: 'token');
    // final token = await storage.read(key: 'token');;
    if (token != null) {
      final headers = {"Authorization": "Bearer $token"};
      // print(headers);
      await http
          .post(Uri.parse('http://10.0.2.2:8000/api/logout'), headers: headers)
          .then((response) async {
        var jsonData = jsonDecode(response.body);
        print(response.statusCode);
        if (response.statusCode == 200) {
          // successSnackBar(context, 'Đăng xuất thành công');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Đăng xuất thành công'),
            duration: const Duration(milliseconds: 1400),
          ));
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        } else {
          // errorSnackBar(context, 'Có lỗi xảy ra 1');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Có lỗi xảy ra 1'),
            duration: const Duration(milliseconds: 1400),
          ));
        }
      }).catchError((error) {
        // errorSnackBar(context, 'Có lỗi xảy ra 2');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          // content: Text('Có lỗi xảy ra 2'),
          content: Text(token.toString()),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    } else {
      // errorSnackBar(context, 'Có lỗi xảy ra 3');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Có lỗi xảy ra 3'),
        duration: const Duration(milliseconds: 1400),
      ));
    }
  }

 @override
  void initState() {
    super.initState();
    loadUser();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            '',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
    drawer: Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('Tài khoản học viên', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                Text(_email, style: TextStyle(color: Colors.blue.shade600, fontSize: 19)),
                Text(_name, style: TextStyle(color: Colors.blue.shade600, fontSize: 19)),
              ],
            ),
            // child: Text('Tài khoản giáo viên'),
          ),
          ListTile(
            leading: Icon(
              Icons.home, size: 30
            ),
            title: const Text('Khóa học', style: TextStyle(fontSize: 25)),
            onTap: () {
              page.jumpToPage(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.date_range, size: 30
            ),
            title: const Text('Lịch', style: TextStyle(fontSize: 25)),
            onTap: () {
              page.jumpToPage(1);
              Navigator.pop(context);
            }, 
          ),
          ListTile(
            leading: Icon(
              Icons.account_box, size: 30
            ),
            title: const Text('Hồ sơ', style: TextStyle(fontSize: 25)),
            onTap: () {
              page.jumpToPage(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(
              Icons.exit_to_app, size: 30
            ),
            title: const Text('Đăng xuất', style: TextStyle(fontSize: 25)),
            onTap: () {
              exitPressed();
            },
          ),
        ],
      ),
    ),
    // body: Center(
    //   child: Column(
    //     children: [
    //       SizedBox(
    //         height: 50,
    //       ),
    //     ],
    //   ),
    // ),
    body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: StudentRoomsScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: Calendar(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: StudentInforScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Download',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    
  );
}
}