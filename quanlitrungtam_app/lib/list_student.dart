import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/list_studentInfor.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StudentListScreen extends StatefulWidget{
  var roomID;
  StudentListScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<StudentListScreen> createState() => _StudentListScreenState(roomID);
}

class _StudentListScreenState extends State<StudentListScreen>{
  final roomID;
  _StudentListScreenState(this.roomID);
  String _teacher_email = '';
  String _teacher_phone = '';
  String _type = '1';
  String _teacher_name = '';

  List<dynamic> _student = [];

  var room = null;

  bool _error = false;

  loadStudentList() async {
    setState(() {
      _student = [];
      // _loading = true;
    });
    // final params = {'room_id': roomID.toString()};
    String params = '?room_id=' + roomID.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/studentlist' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _student = jsonData;
      });

    });

    // setState(() {
    //   _loading = false;
    // });
  }

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
            _teacher_name = room['teacher']['name'];
            _teacher_email = room['teacher']['email'];
            _teacher_phone = room['teacher']['phone'];
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
    loadStudentList();
    loadRoomInfor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.greenAccent,
        //   centerTitle: true,
        //   elevation: 0,
        //   title: const Text(
        //     'Quản lý trung tâm Anh ngữ',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),

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
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 100),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  
                  Row(
                  children: [
                    const SizedBox(
                      width: 14,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => PDFviewScreen(postID: postID.toString())),
                            builder: (context) => StudentListIScreen(roomID: roomID.toString())),
                        ).then((value) {
                            loadStudentList();
                          });
                        
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(185,60),
                        backgroundColor: Colors.pink,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Row(children: [
                          // Text('         ', style: TextStyle(fontSize: 30,)),
                          Icon(Icons.door_sliding_rounded, size: 23,),
                          Text(' Thông tin', style: TextStyle(fontSize: 23,)),
                        ],)
                        ],)

                      ),
                  ],
                ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(children: [
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text('Giáo viên giảng dạy', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                  //   ],
                  // ),
                  // Row(children: [
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text(_teacher_name, style: TextStyle(fontSize: 19)),
                  //   ],
                  // ),
                  // Row(children: [
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text(_teacher_email, style: TextStyle(color: Colors.blue.shade600, fontSize: 19, fontStyle: FontStyle.italic)),
                  //   ],
                  // ),
                  // Row(children: [
                  //     const SizedBox(
                  //       width: 10,
                  //     ),
                  //     Text('SĐT: ', style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic)),
                  //     Text(_teacher_phone, style: TextStyle(fontSize: 19, fontStyle: FontStyle.italic)),
                  //   ],
                  // ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                Center(
                  child: Column(
                    children: [
                      Text('DANH SÁCH LỚP', style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),),
                      Text('____________________________________', style: TextStyle(color: Colors.blue, fontSize: 22, fontWeight: FontWeight.bold),),
                    ],
                  ),
                  
                ),
                SingleChildScrollView(scrollDirection: Axis.horizontal, child:
                  Container(
                      // height: MediaQuery.of(context).size.height,
                      // width: MediaQuery.of(context).size.width,
                      child: DataTable(
                        // headingRowColor: MaterialStateProperty.all(Colors.red),
                        columns: const <DataColumn>[
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'STT',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // DataColumn(
                          //   label: Expanded(
                          //     child: Text(
                          //       'ID',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Tên',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Email',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          // DataColumn(
                          //   label: Expanded(
                          //     child: Text(
                          //       'Số điện thoại',
                          //       style: TextStyle(fontWeight: FontWeight.bold),
                          //     ),
                          //   ),
                          // ),
                          
                        ],

                        rows: List<DataRow>.generate(
                            _student.length,
                                (index) => DataRow(cells: [
                              DataCell(Text((index+1).toString(), style: TextStyle(fontSize: 18))),
                              // DataCell(Text(_student[index]['student']['account_id'].toString())),
                              DataCell(Text(_student[index]['student']['name'].toString(), style: TextStyle(fontSize: 18))),
                              // DataCell(
                              //   Column(
                              //     children: [
                              //       Text(_student[index]['student']['email'].toString(), style: TextStyle(fontSize: 18)),
                              //       Text(_student[index]['student']['phone'].toString(), style: TextStyle(fontSize: 18)),
                              //     ]
                              //   )
                              // ),
                              DataCell(Text(_student[index]['student']['email'].toString(), style: TextStyle(fontSize: 18))),
                              // DataCell(Text(_student[index]['student']['phone'].toString())),
                
                            ])
                        ),
                      )
                  ),
            ),
                  // ]),
                ]
            )
        // ),
      ),
    );
  }
}