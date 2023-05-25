import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/list_teacher.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeacherCheckSScreen extends StatefulWidget{
  var roomID;
  var idx;
  TeacherCheckSScreen({Key? key, @required this.roomID, @required this.idx}) : super(key: key);

  @override
  State<TeacherCheckSScreen> createState() => _TeacherCheckSScreenState(roomID, idx);
}

class _TeacherCheckSScreenState extends State<TeacherCheckSScreen>{
  PageController page = PageController();

  int _selectedIndex = 0;
  final roomID;
  final idx;
  _TeacherCheckSScreenState(this.roomID, this.idx);
  String _room_name = '';
  String _password = '';
  String _type = '1';

  List<dynamic> _student = [];
  bool isChecked = false;

  List<bool> _check = [];
  
  
  var room = null;

  bool _error = false;

  loadStudentList() async {
    setState(() {
      _student = [];
      _check = [];
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

    for(int i=0; i < _student.length; i++ ){
        setState(() {
        _check.add(false);
      });
      }

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
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            'Buổi ' + idx.toString(),
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
        //       Text(_room_name),
        //     ]
        //   )
        // ),

        body: 
        Container(
          decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.orangeAccent, Colors.blue.shade200],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(0.9, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp
                ),
            ),
          child: Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 1),
            padding: EdgeInsets.all(1),
            child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text('Đây là trang rooms teacher nè ' + _account_id.toString()),
              Expanded(
                // child: Text(_rooms.toString() + _account_id.toString()),
                child: ListView.builder(
                  padding: EdgeInsets.all(3),
                  itemCount: _student.length,
                   itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: InkWell(
                        onTap: () {
                          
                        },
                        child: Card(
                          // color: Colors.white.withOpacity(0.9),
                          // surfaceTintColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: Colors.black,
                                      ),
                                    ),
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(_student[index]['student']['name'].toString(), style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold)),
                                Transform.scale(
                                  scale: 2.0,
                                  child: Checkbox(
                                    value: _check[index],
                                    onChanged: (bool? value) {
                                      setState(() {
                                        _check[index] = value!;
                                      });
                                    }
                                  ))
                              ],
                            )
                        ],)
                      )

                    )
                      )
                    );                                        
                   }

                ),
                
              ),
            ]
          )
          ),
    ),

        
    );
  }
}