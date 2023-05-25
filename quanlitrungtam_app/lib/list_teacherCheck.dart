import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/list_teacherCheckS.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TeacherCheckScreen extends StatefulWidget{
  var roomID;
  TeacherCheckScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<TeacherCheckScreen> createState() => _TeacherCheckScreenState(roomID);
}

class _TeacherCheckScreenState extends State<TeacherCheckScreen>{
  PageController page = PageController();

  int _selectedIndex = 0;
  final roomID;
  _TeacherCheckScreenState(this.roomID);
  String _room_name = '';
  String _password = '';
  String _type = '1';

  List<dynamic> _schedules = [];
  
  
  var room = null;

  bool _error = false;

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
            _room_name = room['room_name'];
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

  loadSchedules() async {
    setState(() {
      _schedules = [];
    });
    // final params = {'room_id': roomID.toString()};
    String params = '?room_id=' + roomID.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/listScheduleRoom' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _schedules = jsonData;
      });

    });

  }



  @override
  void initState() {
    super.initState();
    loadRoomInfor();
    loadSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0,
          title: Text(
            _room_name,
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
                    colors: [Colors.purple.shade800, Colors.greenAccent.shade400],
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
                  padding: EdgeInsets.all(5),
                  itemCount: _schedules.length,
                   itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: InkWell(
                        onTap: () {
                           Navigator.push(
                          context,
                          MaterialPageRoute(
                            // builder: (context) => PDFviewScreen(postID: postID.toString())),
                            builder: (context) => TeacherCheckSScreen(roomID: roomID.toString(), idx: (index+1).toString())),
                        ).then((value) {
                            loadRoomInfor();
                            loadSchedules();
                          });
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
                                Text('Buổi ' + (index+1).toString(), style: TextStyle(color: Colors.blue.shade900, fontSize: 25, fontWeight: FontWeight.bold)),
                                Text(_schedules[index]['date'].toString() + '             ', style: TextStyle(color: Colors.black, fontSize: 25, fontWeight: FontWeight.bold))
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