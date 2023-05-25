import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class NewCourseScreen extends StatefulWidget{
  const NewCourseScreen({Key? key}) : super(key: key);

  @override
  State<NewCourseScreen> createState() => _NewCourseScreenState();
}

class _NewCourseScreenState extends State<NewCourseScreen>{
  DateTime _chosenDate = DateTime.now();

  String _name = '';
  String _max_mem = '';
  String _cost = '';
  String _date_end = 'Thông tin bắt buộc';
  // String _account_id = '';
  int _language_id = 1;
  List<dynamic> _languages = [];
  int _type = 2;
  int _lessons = 24;

  int _example = 1;

  String _date_startt = '';

  List lessons_list = [
    {'tag': '24 buổi (3 buổi/tuần)', 'value': 24},
    {'tag': '30 buổi (3 buổi/tuần)', 'value': 30},
  ];


  loadLanguageList() async {
    setState(() {
      _languages = [];
    });
    final params = {'type': _type.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alllanguages",params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _languages = jsonData;
        _language_id = _languages[0]['language_id'];
      });

    });
  }

  newLanguage() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';

    final params = {
      'name': _name.toString(),
      // 'max_mem': _max_mem.toString(),
      'lessons': _lessons.toString(),
      'cost': _cost.toString(),
      'language_id': _language_id.toString(),
    };
    await http
        .post(Uri.http('localhost:8000', "/api/newcourse", params),)
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
    loadLanguageList();
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
                      _name = value;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Text('    Nhập ngôn ngữ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
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
                            // _account_id = newValue.toString();
                          });
                        }
                        ),
                  
                  const SizedBox(
                    height: 20,
                  ),
                  // TextField(
                  //   decoration: InputDecoration(
                  //     prefixIcon: Text('    Số lương',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                  //     prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                  //     hintText: 'Thông tin bắt buộc',
                  //     border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.circular(40),
                  //         borderSide: BorderSide.none),
                  //     fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  //     filled: true,
                  //   ),
                  //   onChanged: (value) {
                  //     _max_mem = value;
                  //   },
                  // ),
                  // const SizedBox(
                  //   height: 20,
                  // ),
                  DropdownButtonFormField(
                        decoration: InputDecoration(
                          prefixIcon: Text('    Nhập số buổi học',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                          // hintText: 'Thông tin bắt buộc',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none),
                          fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          filled: true,
                        ),
                      // borderRadius: BorderRadius.circular(40),
                        items: lessons_list.map((valueItem) {
                          return DropdownMenuItem(
                              value: valueItem['value'],
                              child: Text(valueItem['tag'].toString()));
                              // child: Text(valueItem['tag'].toString() + ' con chim non ' + valueItem['tag'].toString()));
                        }).toList(),
                        value: _lessons,
                        onChanged: (newValue) {
                          setState(() {
                            _lessons = int.tryParse(newValue.toString())!;
                            // _account_id = newValue.toString();
                          });
                        }
                        ),
                  
                  const SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Text('    Học phí',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: 'Thông tin bắt buộc',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _cost = value;
                    },
                  ),
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
                    onPressed: () =>newLanguage(),
                  ),
                  // ]),
                ]
            )
        ),
      ),
    );
  }
}