import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:quanlitrungtam/room_infor.dart';
import 'package:quanlitrungtam/room_students.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class EditRoomScreen extends StatefulWidget{
  var roomID;
  EditRoomScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<EditRoomScreen> createState() => _EditRoomScreenState(roomID);
}

class _EditRoomScreenState extends State<EditRoomScreen>{
  final roomID;
  _EditRoomScreenState(this.roomID);
  String _room_name = '';
  String _scheduleS = '';
  String _date_start = '';
  String _time_start = '';
  String _time_end = '';
  String _account_id = '';
  String _teacher_name = '';
  String _teacher_email = '';
  String _max_mem = '';
  String _members = '';
  String _lessons = '';
  String _course_name = '';
  String _language = '';
  String _classroom = '';

  String _deleteid = '';

  List<dynamic> _student = [];

  var room = null;

  bool _error = false;



  loadRoomInfor() async {
    // setState(() {
    //   _loading = true;
    // });
    final params = {'room_id': roomID.toString()};
    await http.get(Uri.http('localhost:8000', "/api/idroom", params)).then((response) {
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


  loadStudentList() async {
    setState(() {
      _student = [];
      // _loading = true;
    });
    final params = {'room_id': roomID.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/studentlist", params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _student = jsonData;
      });

    });

  }

  deleteStudent() async {
    // setState(() {
    //   _users = [];
    //   _loading = true;
    // });
    final params = {'register_id': _deleteid};
    await http
        .delete(Uri.http('localhost:8000', "/api/removestudent", params))
        .then((response){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(jsonDecode(response.body).values.first),
        duration: const Duration(milliseconds: 1400),
      ));
      loadStudentList();
    });
    setState(() {
      _deleteid = '';
    });
  }



  @override
  void initState() {
    super.initState();
    loadRoomInfor();
    loadStudentList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Quản lí lớp học',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child:Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Wrap(children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                      children:[
                        // Wrap(
                        //   children: [
                        //     Text('Tên khóa học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_room_name, style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Khóa học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_course_name + ' (' + _language + ')', style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Số buổi học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_lessons + ' (3 buổi / 1 tuần)', style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Sỉ số: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_members + '/' + _max_mem, style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Phòng học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_classroom, style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Giáo viên: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_teacher_name + ' (' + _teacher_email + ')', style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Lịch học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     _scheduleS.toString() == '1'
                        //     ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + ', T2,4,6', style: TextStyle(color: Colors.blue),)
                        //     : _scheduleS.toString() == '2'
                        //     ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + ', T3,5,7', style: TextStyle(color: Colors.blue),)
                        //     : const Text('Không xác định'),
                        //   ],
                        // ),
                        // Wrap(
                        //   children: [
                        //     Text('Buổi đầu: ', style: TextStyle(fontWeight: FontWeight.bold),),
                        //     Text(_date_start, style: TextStyle(color: Colors.blue),),
                        //   ],
                        // ),

                        Wrap(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Tên lớp học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Khóa học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Số buổi học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Sỉ số: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Phòng học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Giáo viên: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Lịch học: ', style: TextStyle(fontWeight: FontWeight.bold),),
                                Text('Khai giảng: ', style: TextStyle(fontWeight: FontWeight.bold),),

                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(_room_name, style: TextStyle(color: Colors.blue),),
                                Text(_course_name + ' (' + _language + ')', style: TextStyle(color: Colors.blue),),
                                Text(_lessons + ' buổi (3 buổi / 1 tuần)', style: TextStyle(color: Colors.blue),),
                                Text(_members + '/' + _max_mem, style: TextStyle(color: Colors.blue),),
                                Text('Phòng ' + _classroom, style: TextStyle(color: Colors.blue),),
                                Text(_teacher_name + ' (' + _teacher_email + ')', style: TextStyle(color: Colors.blue),),
                                _scheduleS.toString() == '1'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + ', T2,4,6', style: TextStyle(color: Colors.blue),)
                                  : _scheduleS.toString() == '2'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_start))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_time_end))).toString() + ', T3,5,7', style: TextStyle(color: Colors.blue),)
                                  : const Text('Không xác định'),
                                  Text(_date_start, style: TextStyle(color: Colors.blue),),
                              ],
                            )
                          ],
                        )

                      ]
                    )
                  ),

                  const SizedBox(
                    height: 15,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Row(children: [
                      MaterialButton(
                        child: Text('Sửa thông tin', style: TextStyle(fontSize: 17)),
                        textColor: Colors.white,
                        color: Colors.orangeAccent,
                        hoverColor: Colors.orangeAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 200,
                        height: 40,
                        onPressed: () {
                          // setState(() {

                          // });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => EditInforRoomScreen(roomID: roomID)),
                          // ).then((value) {
                          //   loadRoomInfor();
                          //   loadStudentList();
                          // });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        child: Text('Thêm học viên', style: TextStyle(fontSize: 17)),
                        textColor: Colors.white,
                        color: Colors.green,
                        hoverColor: Colors.green.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 200,
                        height: 40,
                        onPressed: () {
                          setState(() {

                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddStudentRoomScreen(roomID: roomID)),
                          ).then((value) {
                            loadRoomInfor();
                            loadStudentList();
                          });
                        },
                      ),

                    ]),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text('DANH SÁCH LỚP', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'STT',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'ID',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Tên',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Email',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Số điện thoại',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                ' ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],

                        rows: List<DataRow>.generate(
                            _student.length,
                                (index) => DataRow(cells: [
                              DataCell(Text((index+1).toString())),
                              DataCell(Text(_student[index]['student']['account_id'].toString())),
                              DataCell(Text(_student[index]['student']['name'].toString())),
                              DataCell(Text(_student[index]['student']['email'].toString())),
                              DataCell(Text(_student[index]['student']['phone'].toString())),
                              // DataCell(int.parse(_users[index]['type']) == 1
                              //     ? const Text('Admin')
                              //     : int.parse(_users[index]['type']) == 2
                              //     ? const Text('Giáo viên')
                              //     : int.parse(_users[index]['type']) == 3
                              //     ? const Text('Học viên')
                              //     : const Text('Không xác định')),
                              // DataCell(TextButton(
                              //   child: Icon(Icons.edit),
                              //   onPressed: (){
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(builder: (context) => EditUserScreen(userID: _users[index]['account_id'])),
                              //     ).then((value) {
                              //       loadUserTypeList();
                              //     });
                              //   },
                              // )),
                              DataCell(TextButton(
                                child: Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: (){
                                  setState(() {
                                    _deleteid = _student[index]['register_id'].toString();
                                  });
                                  deleteStudent();
                                },
                              )),
                            ])
                        ),
                      )
                  ),
                  // ]),
                ]
            )
        ),
      ),
    );
  }
}