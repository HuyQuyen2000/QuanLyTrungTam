import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam/course_new.dart';
import 'package:quanlitrungtam/course_edit.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'dart:convert';

const Map<String, String> headers = {"Content-Type": "application/json"};

class CourseListScreen extends StatefulWidget{
  const CourseListScreen({Key? key}) : super(key: key);

  @override
  State<CourseListScreen> createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen>{
  bool _loading = true;
  bool _error = false;
  List<dynamic> _courses = [];
  int _select = 0;
  String _name = '';
  String _deleteid = '';

    List<dynamic> _temp = [];

  List<dynamic> _languages = [
    {'language_id': 0, 'name': 'Tất cả'},
  ];
  int _language_id = 0;

  List more_selection = [
    {'tag': 'Sửa', 'value': 0},
    {'tag': 'Thông tin', 'value': 1},
    {'tag': 'DS học viên', 'value': 2},
  ];

  loadLanguageList() async {
    setState(() {
      _temp = [];
      // _languages = [];
    });
    // final params = {'type': _type.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alllanguages"))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _temp = jsonData;
        _languages = _languages..addAll(_temp);
        // _languages = jsonData;
        _language_id = _languages[0]['language_id'];
      });

    });
  }

  loadCourseList() async {
    setState(() {
      _courses = [];
      // _loading = true;
    });
    final params = {'language_id': _language_id.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/languagecourses", params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _courses = jsonData;
      });

    });

    setState(() {
      _loading = false;
    });
  }


  deleteCourse() async {
    // setState(() {
    //   _users = [];
    //   _loading = true;
    // });
    final params = {'course_id': _deleteid};
    await http
        .delete(Uri.http('localhost:8000', "/api/deletecourse", params))
        .then((response){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(jsonDecode(response.body).values.first),
        duration: const Duration(milliseconds: 1400),
      ));
      loadCourseList();
    });
    setState(() {
      _deleteid = '';
    });
  }



  @override
  void initState() {
    super.initState();
    loadCourseList();
    loadLanguageList();
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
                        loadCourseList();
                      },
                    ),
                    
                  ]
                ),
                
                SizedBox(
                  height: 10,
                ),
                // Text(_languages.toString()),
                MaterialButton(
                  child: Text('Thêm khóa học mới', style: TextStyle(fontSize: 20)),
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  hoverColor: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  minWidth: 220,
                  height: 45,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewCourseScreen()),
                    ).then((value) {
                      loadCourseList();
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
                          'Tên khóa học',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ngôn ngữ',
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
                          'Số buổi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Học phí',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Giáo viên',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          ' ',
                          style: TextStyle(fontStyle: FontStyle.italic),
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
                      _courses.length,
                          (index) => DataRow(cells: [
                        DataCell(Text((index+1).toString())),
                        DataCell(Text(_courses[index]['name'].toString())),
                        DataCell(Text(_courses[index]['language']['name'].toString())),
                        // DataCell(Text(_courses[index]['max_mem'].toString() + ' học viên')),
                        DataCell(Text(_courses[index]['lessons'].toString())),
                        DataCell(Text(_courses[index]['cost'].toString() + ' VND')),
                        // DataCell(Text(_rooms[index]['date_end'].toString())),
                        // DataCell(Text(_rooms[index]['teacher']['name'].toString())),
                        // DataCell(int.parse(_rooms[index]['type']) == 1
                        //     ? const Text('Admin')
                        //     : int.parse(_rooms[index]['type']) == 2
                        //     ? const Text('Giáo viên')
                        //     : int.parse(_rooms[index]['type']) == 3
                        //     ? const Text('Học viên')
                        //     : const Text('Không xác định')),
                        DataCell(TextButton(
                          child: Icon(Icons.edit),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditCourseScreen(courseID: _courses[index]['course_id'])),
                            ).then((value) {
                              loadCourseList();
                            });
                          },
                        )),
                        DataCell(TextButton(
                          child: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: (){
                            setState(() {
                              _deleteid = _courses[index]['course_id'].toString();
                            });
                            deleteCourse();
                          },
                        )),
                      ])
                  ),
                )
              ]
          )
      ),
    );
  }
}