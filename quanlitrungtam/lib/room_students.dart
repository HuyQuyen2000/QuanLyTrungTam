import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:quanlitrungtam/room_infor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class AddStudentRoomScreen extends StatefulWidget{
  var roomID;
  AddStudentRoomScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<AddStudentRoomScreen> createState() => _AddStudentRoomScreenState(roomID);
}

class _AddStudentRoomScreenState extends State<AddStudentRoomScreen>{
  final roomID;
  _AddStudentRoomScreenState(this.roomID);

  String _search_name = '';
  String _account_id = '';
  int _type = 3;

  List<dynamic> _student = [];

  var room = null;

  bool _error = false;


  loadStudentList() async {
    setState(() {
      _student = [];
      // _loading = true;
    });
    final params = {'type': _type.toString(),'search_name': _search_name};
    await http
        .get(Uri.http('localhost:8000', "/api/alltypeaccounts", params))
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

  addStudent() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';

    final params = {
      'account_id': _account_id.toString(),
      'room_id': roomID.toString(),
    };
    await http
        .post(Uri.http('localhost:8000', "/api/addstudent", params),
        headers: {'Authorization': 'Bearer ' + token.toString()})
        .then((response) {
      if (response.statusCode == 200) {
        // successSnackBar(context, 'Thêm mới thành công');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Thêm học viên thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        // errorSnackBar(context, jsonDecode(response.body).values.first);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      } else {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm học viên thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm học viên thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });

    // Navigator.pop(context, true);

  }




  @override
  void initState() {
    super.initState();
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
          'Thêm học viên vào khóa học',
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
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Wrap(children: [
                      SizedBox(
                        width: 900,
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Text('    Tìm kiếm: ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            prefixIconConstraints: (BoxConstraints(minWidth: 140, minHeight: 20)),
                            // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                            hintText: 'Nhập tên tài khoản',
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
                          loadStudentList();
                        },
                      ),

                    ]),
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Text('    Tìm kiếm: ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                  //     prefixIconConstraints: (BoxConstraints(minWidth: 140, minHeight: 20)),
                  //     // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                  //     hintText: 'Nhập tên tài khoản',
                  //     // hintText: _room_name,
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(40),
                  //         borderSide: BorderSide.none),
                  //     fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  //     filled: true,
                  //   ),
                  //   // controller: TextEditingController(text: _room_name),
                  //   onChanged: (value) {
                  //     _search_name = value;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 5,
                  // ),
                  // MaterialButton(
                  //   child: Text('Tìm kiếm', style: TextStyle(fontSize: 17)),
                  //   textColor: Colors.white,
                  //   color: Colors.lightBlue,
                  //   hoverColor: Colors.lightBlue.shade100,
                  //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  //   minWidth: 100,
                  //   height: 40,
                  //   onPressed: () {
                  //     loadStudentList();
                  //   },
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
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
                              DataCell(Text(_student[index]['account_id'].toString())),
                              DataCell(Text(_student[index]['name'].toString())),
                              DataCell(Text(_student[index]['email'].toString())),
                              DataCell(Text(_student[index]['phone'].toString())),
                              DataCell(TextButton(
                                child: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: (){
                                  setState(() {
                                    _account_id = _student[index]['account_id'].toString();
                                  });
                                  addStudent();
                                  // setState(() {
                                  //   _account_id = '';
                                  // });
                                },
                              )),
                            ])
                        ),
                      )
                  ),
                  // Text(_account_id.toString() + roomID.toString()),
                ]
            )
        ),
      ),
    );
  }
}