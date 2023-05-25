import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class NewRoomScreen extends StatefulWidget{
  const NewRoomScreen({Key? key}) : super(key: key);

  @override
  State<NewRoomScreen> createState() => _NewRoomScreenState();
}

class _NewRoomScreenState extends State<NewRoomScreen>{
  DateTime _chosenDate = DateTime.now();

  String _room_name = '';
  String _schedule = '';
  String _date_start = 'Thông tin bắt buộc';
  String _date_end = 'Thông tin bắt buộc';
  // String _account_id = '';
  int _account_id = 3;
  List<dynamic> _teacher_list = [];
  int _type = 2;

  int _example = 1;

  String _date_startt = '';

  List example_list = [
    {'tag': 'Admin', 'value': 1},
    {'tag': 'Giáo viên', 'value': 2},
    {'tag': 'Học viên', 'value': 3},
  ];


  loadTeacherList() async {
    setState(() {
      _teacher_list = [];
    });
    final params = {'type': _type.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alltypeaccounts",params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _teacher_list = jsonData;
        _account_id = _teacher_list[0]['account_id'];
      });

    });
  }

  newRoom() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';

    final params = {
      'room_name': _room_name,
      'schedule': _schedule,
      'date_start': _date_start,
      'date_end': _date_end,
      'account_id': _account_id.toString(),
    };
    await http
        .post(Uri.http('localhost:8000', "/api/newroom", params),)
        .then((response) {
      if (response.statusCode == 200) {
        // successSnackBar(context, 'Thêm mới thành công');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Thêm mới thành công'),
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
          content: Text('Thêm mới thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm mới thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });

    // Navigator.pop(context, true);
  }


  @override
  void initState() {
    super.initState();
    loadTeacherList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thêm mới khóa học',
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
                    height: 30,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập tên khóa học mới',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                      hintText: 'Thông tin bắt buộc',
                      // hintText: _teacher_list.toString(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _room_name = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập lịch học',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: 'Thông tin bắt buộc',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _schedule = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập ngày học đầu',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _date_start,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _date_start = value;
                    },
                    onTap: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          // _date_start = DateFormat('y-M-d').parse(chosenDate.toString()).toString();
                          var temp = DateFormat('y-MM-dd').parse(chosenDate.toString());
                          _date_start = DateFormat('y-MM-dd').format(temp);
                          // _dateDMY = dMY(chosenDate.toString());
                        });
                    },
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Text('    Nhập ngày học đầu',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                  //     prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                  //     hintText: 'Thông tin bắt buộc',
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(40),
                  //         borderSide: BorderSide.none),
                  //     fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  //     filled: true,
                  //   ),
                  //   onChanged: (value) {
                  //     _date_start = value;
                  //   },
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập ngày học cuối',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _date_end,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _date_end = value;
                    },
                    onTap: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          // _date_start = DateFormat('y-M-d').parse(chosenDate.toString()).toString();
                          var temp = DateFormat('y-MM-dd').parse(chosenDate.toString());
                          _date_end = DateFormat('y-MM-dd').format(temp);
                        });
                    },
                  ),
                  // const SizedBox(
                  //   height: 15,
                  // ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Text('    Nhập giáo viên giảng dạy',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                  //     prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                  //     hintText: 'Thông tin bắt buộc',
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(40),
                  //         borderSide: BorderSide.none),
                  //     fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  //     filled: true,
                  //   ),
                  //   onChanged: (value) {
                  //     _account_id = value;
                  //   },
                  // ),
                  const SizedBox(
                    height: 20,
                  ),
                  // Row(children: [
                    // Text('    Loại:    ',
                    //     style: TextStyle(
                    //         fontSize: 17, color: Colors.lightBlue)),
                    DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Text('    Nhập giáo viên giảng dạy',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                          // hintText: 'Thông tin bắt buộc',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none),
                          fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          filled: true,
                        ),
                      // borderRadius: BorderRadius.circular(40),
                        items: _teacher_list.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem['account_id'],
                              child: Text(valueItem['name'].toString() + ' (' + valueItem['email'].toString() + ')'));
                              // child: Text(valueItem['tag'].toString() + ' con chim non ' + valueItem['tag'].toString()));
                        }).toList(),
                        value: _account_id,
                        onChanged: (newValue) {
                          setState(() {
                            _account_id = int.tryParse(newValue.toString())!;
                            // _account_id = newValue.toString();
                          });
                        }
                        ),
                  // ]),
                  const SizedBox(
                    height: 20,
                  ),
                  MaterialButton(
                    child: Text('THÊM MỚI', style: TextStyle(fontSize: 20)),
                    // child: Text(_account_id.toString(), style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.greenAccent,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: () =>newRoom(),
                  ),
                  // ]),
                ]
            )
        ),
      ),
    );
  }
}