import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:quanlitrungtam/loginb.dart';
import 'package:quanlitrungtam/account_list.dart';
import 'package:quanlitrungtam/language_list.dart';
import 'package:quanlitrungtam/course_list.dart';
import 'package:quanlitrungtam/classRoom_list.dart';
import 'package:quanlitrungtam/room_list.dart';
import 'package:quanlitrungtam/account_profile.dart';
import 'package:quanlitrungtam/index.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:easy_sidemenu/easy_sidemenu.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
  // _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
  PageController page = PageController();
  // SideMenuController sideMenu = SideMenuController();
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }


  exitPressed() async{
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => LoginScreenb()),
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text('Đăng xuất thành công'),
      duration: const Duration(milliseconds: 1400),
    ));
    // final storage = new FlutterSecureStorage();
    // final token = await storage.read(key: 'token');
    // final token = '';
    // if (token != null) {
    //   final headers = {"Authorization": "Bearer $token"};
    //   print(headers);
    //   await http
    //       .post(Uri.http('localhost:8000', '/api/logout'), headers: headers)
    //       .then((response) async {
    //     var jsonData = jsonDecode(response.body);
    //     print(response.statusCode);
    //     if (response.statusCode == 200) {
    //       // successSnackBar(context, 'Đăng xuất thành công');
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: Colors.green,
    //         content: Text('Đăng xuất thành công'),
    //         duration: const Duration(milliseconds: 1400),
    //       ));
    //       Navigator.pushReplacement(
    //         context,
    //         MaterialPageRoute(builder: (context) => LoginScreenb()),
    //       );
    //     } else {
    //       // errorSnackBar(context, 'Có lỗi xảy ra 1');
    //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //         backgroundColor: Colors.red,
    //         content: Text('Có lỗi xảy ra 1'),
    //         duration: const Duration(milliseconds: 1400),
    //       ));
    //     }
    //   }).catchError((error) {
    //     // errorSnackBar(context, 'Có lỗi xảy ra 2');
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: Colors.red,
    //       content: Text('Có lỗi xảy ra 2'),
    //       duration: const Duration(milliseconds: 1400),
    //     ));
    //   });
    // } else {
    //   // errorSnackBar(context, 'Có lỗi xảy ra 3');
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //     backgroundColor: Colors.red,
    //     content: Text('Có lỗi xảy ra 3'),
    //     duration: const Duration(milliseconds: 1400),
    //   ));
    // }
  }




  // @override
  // void initState() {
  //   sideMenu.addListener((p0) {
  //     page.jumpToPage(p0);
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý các khóa học Trung tâm Ngoại ngữ'),
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            // controller: sideMenu,
            controller: page,
            style: SideMenuStyle(
              // showTooltip: false,
              // displayMode: SideMenuDisplayMode.auto,
              hoverColor: Colors.greenAccent[100],
              selectedColor: Colors.greenAccent,
              selectedTitleTextStyle: const TextStyle(color: Colors.white),
              selectedIconColor: Colors.white,
              // decoration: BoxDecoration(
              //   borderRadius: BorderRadius.all(Radius.circular(200)),
              // ),
              // backgroundColor: Colors.blueGrey[700]
            ),
            title: Column(
              children: [
                // ConstrainedBox(
                //   constraints: const BoxConstraints(
                //     maxHeight: 150,
                //     maxWidth: 150,
                //   ),
                //   // child: Image.asset(
                //   //   'assets/images/easy_sidemenu.png',
                //   // ),
                // ),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            // footer: const Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: Text(
            //     'mohada',
            //     style: TextStyle(fontSize: 15),
            //   ),
            // ),
            items: [
              SideMenuItem(
                priority: 0,
                title: 'Tài khoản',
                onTap: () => page.jumpToPage(0),
                icon: const Icon(Icons.supervisor_account),
                // badgeContent: const Text(
                //   '3',
                //   style: TextStyle(color: Colors.white),
                // ),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(
                priority: 1,
                title: 'Ngôn ngữ',
                onTap: () => page.jumpToPage(1),
                icon: const Icon(Icons.translate),
              ),
              SideMenuItem(
                priority: 2,
                title: 'Khóa học',
                onTap: () => page.jumpToPage(2),
                icon: const Icon(Icons.collections_bookmark),
              ),
              SideMenuItem(
                priority: 3,
                title: 'Phòng học',
                onTap: () => page.jumpToPage(3),
                icon: const Icon(Icons.door_sliding_rounded),
              ),
              SideMenuItem(
                priority: 4,
                title: 'Lớp học',
                onTap: () => page.jumpToPage(4),
                icon: const Icon(Icons.auto_awesome_motion_sharp),
                // trailing: Container(
                //     decoration: const BoxDecoration(
                //         color: Colors.amber,
                //         borderRadius: BorderRadius.all(Radius.circular(6))),
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(
                //           horizontal: 6.0, vertical: 3),
                //       child: Text(
                //         'New',
                //         style: TextStyle(fontSize: 11, color: Colors.grey[800]),
                //       ),
                //     )),
              ),
              SideMenuItem(
                priority: 5,
                title: 'Hồ sơ',
                onTap: () => page.jumpToPage(5),
                icon: const Icon(Icons.account_box),
              ),
              SideMenuItem(
                priority:6,
                title: 'Đăng xuất',
                // onTap: () => page.jumpToPage(3),
                onTap: () {exitPressed();},
                icon: const Icon(Icons.exit_to_app),
              ),
            ],
          ),
          Expanded(
            child: PageView(
              controller: page,
              children: [
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: AccountListScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: LanguageListScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: CourseListScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: ClassRoomListScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: RoomListScreen(),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: ProfileScreen(),
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