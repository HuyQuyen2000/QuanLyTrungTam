import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/PDFviewer.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SubmitListScreen extends StatefulWidget{
  var taskID;
  var roomID;
  SubmitListScreen({Key? key, @required this.taskID, @required this.roomID}) : super(key: key);

  @override
  State<SubmitListScreen> createState() => _SubmitListScreenState(taskID,roomID);
}

class _SubmitListScreenState extends State<SubmitListScreen>{
  final taskID;
  final roomID;
  _SubmitListScreenState(this.taskID,this.roomID);
  
  String _email = '';
  String _password = '';
  String _type = '1';

  List<dynamic> _student = [];

  bool _visible1 = false;
  bool _visible2 = false;

  loadStudentList() async {
    setState(() {
      _student = [];
      // _loading = true;
    });
    // final params = {'room_id': roomID.toString()};
    String params = '?task_id=' + taskID.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/submitlist' + params.toString()))
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

  update() async{
    final params = {
      'room_id': roomID.toString(),
      'task_id': taskID.toString(),
    };
    await http
        .post(Uri.parse('http://10.0.2.2:8000/api/updateSubmitList'), body: params)
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Cập nhật thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        // Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Cập nhật thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Cập nhật thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });
  }

  bool Visible1(String a){
    if(a == '1'){
      return true;
    }else{
      return false;
    }
  }

  bool Visible2(String a){
    if(a == '2'){
      return true;
    }else{
      return false;
    }
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
            'Danh sách nộp bài',
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
        //       Text('Danh sách nộp bài nè bạn tôi ơi '),
        //     ]
        //   )
        // ),
        

        body:
        SingleChildScrollView(scrollDirection: Axis.horizontal, child:
        // Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 100),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 5,
                  ),
                  Center(
                    child:MaterialButton(
                        child: Text('Cập nhật danh sách', style: TextStyle(fontSize: 23)),
                        textColor: Colors.white,
                        color: Colors.green,
                        hoverColor: Colors.greenAccent.shade100,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 200,
                        height: 40,
                        onPressed: () {
                          update().then((value){loadStudentList();});
                        },
                      ),
                  ),       
                  const SizedBox(
                    height: 5,
                  ),
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
                                'Nộp bài',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Thời gian',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                '',
                                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          
                          
                        ],

                        rows: List<DataRow>.generate(
                            _student.length,
                                (index) => DataRow(cells: [
                              DataCell(Text((index+1).toString(), style: TextStyle(fontSize: 18))),
                              // DataCell(Text(_student[index]['student']['account_id'].toString())),
                              DataCell(Text(_student[index]['user_account']['name'].toString(), style: TextStyle(fontSize: 18))),
                              // DataCell(Text(_student[index]['status'].toString(), style: TextStyle(fontSize: 18))),
                               DataCell(int.parse(_student[index]['status']) == 1
                                ? const Text('Chưa nộp', style: TextStyle(fontSize: 18, color: Colors.red))
                                : int.parse(_student[index]['status']) == 2
                                ? const Text('Đã nộp', style: TextStyle(fontSize: 18, color: Colors.green))
                                : const Text('Không xác định')),
                              // DataCell(
                              //   Column(
                              //     children: [
                              //       Text(_student[index]['student']['email'].toString(), style: TextStyle(fontSize: 18)),
                              //       Text('sđt: ' + _student[index]['student']['phone'].toString(), style: TextStyle(fontSize: 18)),
                              //     ]
                              //   )
                              // ),
                              // DataCell(Text(_student[index]['student']['email'].toString())),
                              // DataCell(Text(_student[index]['student']['phone'].toString())),
                               DataCell(Text(_student[index]['submit_time'].toString(), style: TextStyle(fontSize: 18))),
                               DataCell(
                                Column(
                                  children: [
                                    Visibility(
                                      visible: Visible1(_student[index]['status'].toString()),
                                      child: TextButton(
                                        child: Icon(Icons.book, color:Colors.grey),
                                        onPressed: (){
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(builder: (context) => EditUserScreen(userID: _users[index]['account_id'])),
                                          // ).then((value) {
                                          //   loadStudentList();
                                          // });
                                        },
                                      )
                                    ),
                                    Visibility(
                                      visible: Visible2(_student[index]['status'].toString()),
                                      child: TextButton(
                                        child: Icon(Icons.book, color:Colors.blue),
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              // builder: (context) => PDFviewScreen(postID: postID.toString())),
                                              builder: (context) => PDFviewScreen(docName: _student[index]['document_name'].toString())),
                                          ).then((value) {
                                              loadStudentList();
                                            });
                                        },
                                      )
                                    ),
                                    

                                  ],
                                ),
                              ),
                
                            ])
                        ),
                      )
                  ),
                  // ]),
                ]
            )
        // ),
      ),
    );
  }
}