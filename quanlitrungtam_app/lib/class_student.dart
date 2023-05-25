import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/posts_student.dart';
import 'package:quanlitrungtam_app/posts_student2.dart';
import 'package:quanlitrungtam_app/posts_student3.dart';
import 'package:quanlitrungtam_app/list_student.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentClassScreen extends StatefulWidget{
  var roomID;
  StudentClassScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<StudentClassScreen> createState() => _StudentClassScreenState(roomID);
}

class _StudentClassScreenState extends State<StudentClassScreen>{
  PageController page = PageController();

  int _selectedIndex = 0;
  final roomID;
  _StudentClassScreenState(this.roomID);
  String _room_name = '';
  String _password = '';
  String _type = '1';
  
  
  var room = null;

  bool _error = false;

  loadRoomInfor() async {
    // setState(() {
    //   _loading = true;
    // });
    String params = '?room_id=' + roomID.toString();
    await http.get(Uri.parse('http://10.0.2.2:8000/api/idroom' + params)).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            room = jsonData;
            _room_name = room['room_name'];
          });
        }
      } else
        setState(() {
          _error = true;
        });
    }).catchError((error) {
      setState(() {
        _error = true;
      });
    });
  }


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if(_selectedIndex == 0){
      page.jumpToPage(0);
    }

    if(_selectedIndex == 1){
      page.jumpToPage(1);
    }

    if(_selectedIndex == 2){
      page.jumpToPage(2);
    }

    if(_selectedIndex == 3){
      page.jumpToPage(3);
    }

  }

  @override
  void initState() {
    super.initState();
    loadRoomInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            _room_name,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // body: SingleChildScrollView(
        //   child: Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     mainAxisAlignment: MainAxisAlignment.center,
        //     children: [
        //       Text(_room_name),
        //     ]
        //   )
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
                  child: Center(
                    child: StudentPostsScreen(roomID: roomID.toString()),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: StudentPosts2Screen(roomID: roomID.toString()),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: StudentPosts3Screen(roomID: roomID.toString()),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Center(
                    child: StudentListScreen(roomID: roomID.toString()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),


        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.orange,
          unselectedItemColor: Colors.grey,
          unselectedLabelStyle: TextStyle(color: Colors.grey),
          selectedFontSize: 15,
          unselectedFontSize: 15,
          iconSize: 35,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper),
              label: 'Thông báo',
            ),
             BottomNavigationBarItem(
              icon: Icon(Icons.book),
              label: 'Tài liệu',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home_work),
              label: 'Bài tập',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervisor_account),
              label: 'Lớp học',
            ),
            // BottomNavigationBarItem(
            //   icon: Icon(Icons.school),
            //   label: 'School',
            // ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
      ),
    );
  }
}