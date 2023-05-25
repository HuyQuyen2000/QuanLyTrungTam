import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam/language_new.dart';
import 'package:quanlitrungtam/room_edit.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'dart:convert';

class ClassRoomListScreen extends StatefulWidget{
  const ClassRoomListScreen({Key? key}) : super(key: key);

  @override
  State<ClassRoomListScreen> createState() => _ClassRoomListScreenState();
}

class _ClassRoomListScreenState extends State<ClassRoomListScreen>{
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }

  bool _loading = true;
  bool _error = false;
  List<dynamic> _classRooms = [];
  int _select = 0;
  String _name = '';
  String _deleteid = '';

  List more_selection = [
    {'tag': 'Sửa', 'value': 0},
    {'tag': 'Thông tin', 'value': 1},
    {'tag': 'DS học viên', 'value': 2},
  ];

  loadRoomList() async {
    setState(() {
      _classRooms = [];
      // _loading = true;
    });
    // final params = {'type': _type.toString(), 'name': _name};
    await http
        .get(Uri.http('localhost:8000', "/api/allclassrooms"))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _classRooms = jsonData;
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
    final params = {'language_id': _deleteid};
    await http
        .delete(Uri.http('localhost:8000', "/api/deletelanguage", params))
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
                  height: 20,
                ),
                MaterialButton(
                  child: Text('Thêm phòng học', style: TextStyle(fontSize: 20)),
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  hoverColor: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  minWidth: 220,
                  height: 45,
                  onPressed: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => NewLanguageScreen()),
                    // ).then((value) {
                    //   loadLanguageList();
                    // });
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
                          'Tên phòng',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Sức chứa',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Ghi chú',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    // DataColumn(
                    //   label: Expanded(
                    //     child: Text(
                    //       'Ngày cuối',
                    //       style: TextStyle(fontWeight: FontWeight.bold),
                    //     ),
                    //   ),
                    // ),
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
                      _classRooms.length,
                          (index) => DataRow(cells: [
                        DataCell(Text((index+1).toString())),
                        DataCell(Text(_classRooms[index]['name'].toString())),
                        DataCell(Text(_classRooms[index]['capacity'].toString())),
                        DataCell(Text(_classRooms[index]['note'].toString())),
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(builder: (context) => EditRoomScreen(roomID: _rooms[index]['room_id'])),
                            // ).then((value) {
                            //   loadLanguageList();
                            // });
                          },
                        )),
                        DataCell(TextButton(
                          child: Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: (){
                            // setState(() {
                            //   _deleteid = _languages[index]['language_id'].toString();
                            // });
                            // deleteRoom();
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