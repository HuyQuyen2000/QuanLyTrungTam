import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/list_teacherCheck.dart';
import 'package:quanlitrungtam_app/list_teacherInfor.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeacherListScreen extends StatefulWidget{
  var roomID;
  TeacherListScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<TeacherListScreen> createState() => _TeacherListScreenState(roomID);
}

class _TeacherListScreenState extends State<TeacherListScreen>{
  final roomID;
  _TeacherListScreenState(this.roomID);
  String _email = '';
  String _password = '';
  String _type = '1';

  List<dynamic> _student = [];

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

  @override
  void initState() {
    super.initState();
    loadStudentList();
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
                            builder: (context) => TeacherListIScreen(roomID: roomID.toString())),
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
                      SizedBox(
                        width: 15,
                      ),
                      ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => PDFviewScreen(postID: postID.toString())),
                            builder: (context) => TeacherCheckScreen(roomID: roomID.toString())),
                        ).then((value) {
                            loadStudentList();
                          });
                        
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(185,60),
                        backgroundColor: Colors.greenAccent.shade700,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Row(children: [
                          // Text('         ', style: TextStyle(fontSize: 30,)),
                          Icon(Icons.file_download_done, size: 23,),
                          Text(' Điểm danh', style: TextStyle(fontSize: 23,)),
                        ],)
                        ],)

                      ),
                  ],
                ),
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
                                'Thông tin',
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
                              DataCell(
                                Column(
                                  children: [
                                    Text(_student[index]['student']['email'].toString(), style: TextStyle(fontSize: 18)),
                                    Text('sđt: ' + _student[index]['student']['phone'].toString(), style: TextStyle(fontSize: 18)),
                                  ]
                                )
                              ),
                              // DataCell(Text(_student[index]['student']['email'].toString())),
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