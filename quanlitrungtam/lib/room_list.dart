
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam/room_newS.dart';
import 'package:quanlitrungtam/room_edit.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

import 'dart:convert';

const Map<String, String> headers = {"Content-Type": "application/json"};

class RoomListScreen extends StatefulWidget{
  const RoomListScreen({Key? key}) : super(key: key);

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen>{

  bool _loading = true;
  bool _error = false;
  List<dynamic> _rooms = [];
  int _select = 0;
  String _name = '';
  String _deleteid = '';
    String _search_name = '';

  List more_selection = [
    {'tag': 'Sửa', 'value': 0},
    {'tag': 'Thông tin', 'value': 1},
    {'tag': 'DS học viên', 'value': 2},
  ];

  List<dynamic> _temp1 = [];
  List<dynamic> _languages = [
    {'language_id': 0, 'name': 'Tất cả'},
  ];
  int _language_id = 0;

  List<dynamic> _temp2 = [];
  List<dynamic> _courses = [
    {'course_id': 0, 'name': 'Tất cả'},
  ];
  List<dynamic> _coursesS = [
    {'course_id': 0, 'name': 'Tất cả'},
  ];
  int _course_id = 0;


  loadLanguageList() async {
    setState(() {
      _temp1 = [];
      // _languages = [];
    });
    // final params = {'type': _type.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alllanguages"))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _temp1 = jsonData;
        _languages = _languages..addAll(_temp1);
        // _languages = jsonData;
        _language_id = _languages[0]['language_id'];
      });

    });
  }

  loadCourseList() async {
    setState(() {
      _temp2 = [];
      // _loading = true;
    });
    final params = {'language_id': _language_id.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/languagecourses", params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _temp2 = jsonData;
        _courses = _courses..addAll(_temp2);
        // _languages = jsonData;
        _course_id = _courses[0]['course_id'];
      });

    });

  }

  loadRoomList() async {
    setState(() {
      _rooms = [];
      // _loading = true;
    });
    final params = {'language_id': _language_id.toString(), 'course_id': _course_id.toString(), 'search_name': _search_name.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alltyperoomsS", params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _rooms = jsonData;
      });

    });

    setState(() {
      _loading = false;
    });
  }


  deleteRoom() async {
    // setState(() {
    //   _users = [];
    //   _loading = true;
    // });
    final params = {'room_id': _deleteid};
    await http
        .delete(Uri.http('localhost:8000', "/api/deleteroom", params))
        .then((response){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(jsonDecode(response.body).values.first),
        duration: const Duration(milliseconds: 1400),
      ));
      loadRoomList();
    });
    setState(() {
      _deleteid = '';
    });
  }



  @override
  void initState() {
    super.initState();
    loadRoomList();
    loadLanguageList();
    loadCourseList();
    _select = 0;
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

      body: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  children: [
                    
                    SizedBox(
                      width: 330,
                      child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              prefixIcon: Text('    Chọn ngôn ngữ   ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                              prefixIconConstraints: (BoxConstraints(minWidth: 150, minHeight: 20)),
                              // hintText: 'Thông tin bắt buộc',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none),
                              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              filled: true,
                            ),
                          // borderRadius: BorderRadius.circular(40),
                            items: _languages.map((valueItem) {
                              return DropdownMenuItem(
                                  value: valueItem['language_id'],
                                  child: Text(valueItem['name'].toString()));
                                  // child: Text(valueItem['tag'].toString() + ' con chim non ' + valueItem['tag'].toString()));
                            }).toList(),
                            value: _language_id,
                            onChanged: (newValue) {
                              setState(() {
                                _language_id = int.tryParse(newValue.toString())!;
                                _course_id = 0;
                                _courses = [];
                                _courses = _courses..addAll(_coursesS);
                              });
                              loadCourseList();
                            }
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 330,
                      child: DropdownButtonFormField(
                            decoration: InputDecoration(
                              prefixIcon: Text('    Chọn khóa học   ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                              prefixIconConstraints: (BoxConstraints(minWidth: 150, minHeight: 20)),
                              // hintText: 'Thông tin bắt buộc',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide.none),
                              fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                              filled: true,
                            ),
                          // borderRadius: BorderRadius.circular(40),
                            items: _courses.map((valueItem) {
                              return DropdownMenuItem(
                                  value: valueItem['course_id'],
                                  child: Text(valueItem['name'].toString()));
                                  // child: Text(valueItem['tag'].toString() + ' con chim non ' + valueItem['tag'].toString()));
                            }).toList(),
                            value: _course_id,
                            onChanged: (newValue) {
                              setState(() {
                                _course_id = int.tryParse(newValue.toString())!;
                                // _language_id = newValue.toString();
                              });
                            }
                            ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      child: Text('Liệt kê', style: TextStyle(fontSize: 20)),
                      textColor: Colors.white,
                      color: Colors.greenAccent,
                      hoverColor: Colors.greenAccent.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
                      minWidth: 120,
                      height: 60,
                      onPressed: () {
                        loadRoomList();
                      },
                    ),
                    
                  ]
                ),
                const SizedBox(
                  height: 10,
                ),
                Wrap(children: [
                    SizedBox(
                      width: 920,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Text('    Tìm kiếm: ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          prefixIconConstraints: (BoxConstraints(minWidth: 140, minHeight: 20)),
                          // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                          hintText: 'Nhập từ khóa tên lớp học',
                          // hintText: _room_name,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none),
                          fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          filled: true,
                        ),
                        // controller: TextEditingController(text: _room_name),
                        onChanged: (value) {
                          _search_name = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      child: Text('Tìm kiếm', style: TextStyle(fontSize: 17)),
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      hoverColor: Colors.lightBlue.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
                      minWidth: 100,
                      height: 60,
                      onPressed: () {
                        loadRoomList();
                      },
                    ),

                  ]),
                  const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Text('Thêm lớp học mới', style: TextStyle(fontSize: 20)),
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  hoverColor: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  minWidth: 220,
                  height: 45,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewRoomSScreen()),
                    ).then((value) {
                      loadRoomList();
                    });
                  },
                ),
                // Text('Đây là trang quản lí account nè'),
                DataTable(
                  columns: const <DataColumn>[
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'STT',
                    //       style: TextStyle(fontStyle: FontStyle.italic),
                    //     ),
                    //   ),
                    // ),
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
                          'Tên lớp',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Khóa học',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Lịch học',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Buổi đầu',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Số lượng',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Giáo viên',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Phòng',
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
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       ' ',
                    //       style: TextStyle(fontStyle: FontStyle.italic),
                    //     ),
                    //   ),
                    // ),
                  ],
                  rows: List<DataRow>.generate(
                      _rooms.length,
                          (index) => DataRow(cells: [
                        DataCell(Text((index+1).toString())),
                        // DataCell(Text(_rooms[index]['room_id'].toString())),
                        DataCell(Text(_rooms[index]['room_name'].toString())),
                        DataCell(Text(_rooms[index]['course']['name'].toString())),
                        DataCell(_rooms[index]['scheduleS'].toString() == '1'
                            // ? Text(_rooms[index]['time_start'] + ' - ' + _rooms[index]['time_end'].toString() + ' T2,4,6')
                            ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_start']))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_end']))).toString() + '\nT2,4,6')
                            : _rooms[index]['scheduleS'].toString() == '2'
                            ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_start']))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_end']))).toString() + '\nT3,5,7')
                            : const Text('Không xác định')),
                        DataCell(Text(_rooms[index]['date_start'].toString())),
                        // DataCell(Text(_rooms[index]['members'].toString() + '/' +_rooms[index]['max_mem'].toString())),
                        DataCell(Text(_rooms[index]['teacher']['name'].toString())),
                        DataCell(Text(_rooms[index]['class_room']['name'].toString())),
                        // DataCell(int.parse(_rooms[index]['type']) == 1
                        //     ? const Text('Admin')
                        //     : int.parse(_rooms[index]['type']) == 2
                        //     ? const Text('Giáo viên')
                        //     : int.parse(_rooms[index]['type']) == 3
                        //     ? const Text('Học viên')
                        //     : const Text('Không xác định')),
                        DataCell(
                          Row(
                            children: [
                              TextButton(
                                child: Icon(Icons.edit),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => EditRoomScreen(roomID: _rooms[index]['room_id'])),
                                  ).then((value) {
                                    loadRoomList();
                                  });
                                },
                              ),
                              TextButton(
                                child: Icon(Icons.delete_forever, color: Colors.red),
                                onPressed: (){
                                  setState(() {
                                    _deleteid = _rooms[index]['room_id'].toString();
                                  });
                                  deleteRoom();
                                },
                              )

                            ],
                          ),
                          ),
                        // DataCell(TextButton(
                        //   child: Icon(Icons.edit),
                        //   onPressed: (){
                        //     // Navigator.push(
                        //     //   context,
                        //     //   MaterialPageRoute(builder: (context) => EditRoomScreen(roomID: _rooms[index]['room_id'])),
                        //     // ).then((value) {
                        //     //   loadRoomList();
                        //     // });
                        //   },
                        // )),
                        // DataCell(TextButton(
                        //   child: Icon(Icons.delete_forever),
                        //   onPressed: (){
                        //     // setState(() {
                        //     //   _deleteid = _rooms[index]['room_id'].toString();
                        //     // });
                        //     // deleteRoom();
                        //   },
                        // )),
                      ])
                  ),
                )

                
              ]
          )
      ),
    );
  }
}