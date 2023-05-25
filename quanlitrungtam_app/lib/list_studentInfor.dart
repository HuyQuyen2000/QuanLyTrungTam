import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class StudentListIScreen extends StatefulWidget{
  var roomID;
  StudentListIScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<StudentListIScreen> createState() => _StudentListIScreenState(roomID);
}

class _StudentListIScreenState extends State<StudentListIScreen>{
  final roomID;
  _StudentListIScreenState(this.roomID);
  String _email = '';
  String _password = '';
  String _type = '1';


  var room = null;
   String _room_name = '';
  String _scheduleS = '';
  String _date_start = '';
  String _time_start = '';
  String _time_end = '';
  String _account_id = '';
  String _teacher_name = '';
  String _teacher_email = '';
  String _teacher_phone = '';
  String _max_mem = '';
  String _members = '';
  String _lessons = '';
  String _course_name = '';
  String _language = '';
  String _classroom = '';

  bool _error = false;

  loadRoomInfor() async {
    // setState(() {
    //   _loading = true;
    // });
    String params = '?room_id=' + roomID.toString();
    await http.get(Uri.parse('http://10.0.2.2:8000/api/idroom' + params.toString())).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            room = jsonData;
            _room_name = room['room_name'].toString();
            _scheduleS = room['scheduleS'].toString();
            _date_start = room['date_start'].toString();
            _time_start = room['time_start'].toString();
            _time_end = room['time_end'].toString();
            _teacher_name = room['teacher']['name'].toString();
            _teacher_email = room['teacher']['email'].toString();
            _teacher_phone = room['teacher']['phone'].toString();
            _max_mem = room['max_mem'].toString();
            _members = room['members'].toString();
            _course_name = room['course']['name'].toString();
            _language = room['course']['language']['name'].toString();
            _lessons = room['course']['lessons'].toString();
            _classroom = room['class_room']['name'].toString();

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
        //       Text('Danh sách học viên của lớp học ở đây nè bạn tôi ơi  ' + roomID.toString()),
        //       Text(_student.toString()),
        //     ]
        //   )
        // ),
        

        body:
        SingleChildScrollView(
        // scrollDirection: Axis.horizontal,
        child:
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                height: 10,
              ),
              Text('Thông tin lớp học', style: TextStyle(color: Colors.pink, fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 25,
              ),
              
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Giáo viên:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_teacher_name, style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('E-mail:  ', style: TextStyle(fontSize: 20)),
                      Text(_teacher_email, style: TextStyle(fontSize: 20, color: Colors.red)),
                    ],
                  ),
                ],
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('SĐT:  ', style: TextStyle(fontSize: 20)),
                      Text(_teacher_phone, style: TextStyle(fontSize: 20, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Khóa học:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_course_name, style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Ngôn ngữ:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_language, style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Số buổi học:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_lessons + ' buổi', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Sỉ số:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_members + ' học viên', style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
               SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Phòng học:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_classroom, style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),
               SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Lịch học:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                                _scheduleS.toString() == '1'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + '    T2,4,6', style: TextStyle(fontSize: 22),)
                                  : _scheduleS.toString() == '2'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + '    T3,5,7', style: TextStyle(fontSize: 22),)
                                  : const Text('Không xác định'),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Khai giảng:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      Text(_date_start, style: TextStyle(fontSize: 22)),
                    ],
                  ),
                ],
              ),

             
                ]
            )
        ),
      ),
    );
  }
}