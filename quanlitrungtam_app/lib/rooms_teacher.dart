import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/login.dart';
import 'package:quanlitrungtam_app/class_teacher.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class TeacherRoomsScreen extends StatefulWidget{
  const TeacherRoomsScreen({Key? key}) : super(key: key);

  @override
  State<TeacherRoomsScreen> createState() => _TeacherRoomsScreenState();
}

class _TeacherRoomsScreenState extends State<TeacherRoomsScreen>{
  String _email = '';
  String _password = '';
  String _type = '1';

  String _account_id = '';
  // int _account_id = 0;

  List<dynamic> _rooms = [];

  loginPressed() async{

  }

  loadRooms() async{
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');
    if(user != null){
      setState(() {
      _rooms = [];
      _account_id = jsonDecode(user)['account_id'].toString();
      // _account_id = jsonDecode(user)['account_id'];
    });
      
    }
    else{
      setState(() {
      _account_id = 'lỗi';
    });

    }

    // final params = {'account_id': _account_id.toString()};
    final params = '?account_id='+_account_id.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/teacherrooms' + params.toString()))
        .then((response) {
      var jsonData = jsonDecode(response.body);
      setState(() {
        _rooms = jsonData;
      });

    });
  }


  String getphoto(int a){
    String image = 'assets/images/emerald.JPG';
    if((a%5) == 0){
        image = 'assets/images/City.JPG';
        // image = 'assets/images/Aurora.JPG';
    }
    else{
      if((a%5) == 1){
          image = 'assets/images/Somewhere.JPG';
      }
      else{
        if((a%5) ==2){
            // image = 'assets/images/emerald.JPG';
            image = 'assets/images/Aurora.JPG';
        }
        else{
          if((a%5) == 3){
              image = 'assets/images/Somewhere1.JPG';
          }
          else{
                image = 'assets/images/Cosmos.JPG';
          }
        }
      }
    }
    return image;
  }

  @override
  void initState() {
    super.initState();
    loadRooms();
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

        body: 
        // SingleChildScrollView(child:
          Padding(
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
                  itemCount: _rooms.length,
                   itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeacherClassScreen(roomID: _rooms[index]['room_id'])),
                          );
                        },
                        child: Card(
                          color: Colors.greenAccent.shade100,
                          // surfaceTintColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                            side: BorderSide(
                              color: Colors.greenAccent,
                            ),
                          ),
                          child: Container(
                             decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(getphoto(index)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Padding(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          Text(_rooms[index]['room_name'], style: TextStyle(color: Colors.white, fontSize: 29, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 80,
                          ),
                          _rooms[index]['scheduleS'].toString() == '1'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_start']))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_end']))).toString() + ',  T2,4,6', style: TextStyle(color: Colors.white, fontSize: 26,),)
                                  : _rooms[index]['scheduleS'].toString() == '2'
                                  ? Text((DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_start']))).toString() + '-' + (DateFormat('H:mm').format(DateFormat('H:mm').parse(_rooms[index]['time_end']))).toString() + ',  T3,5,7', style: TextStyle(color: Colors.white, fontSize: 26,),)
                                  : const Text('Không xác định'),
                          Row(
                            children: [
                              Text('Buổi đầu:  ', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                              Text(_rooms[index]['date_start'], style: TextStyle(color: Colors.white, fontSize: 26,)),
                            ]
                          ),
                          
                        ],)
                      )
                          ),

                      // child: Padding(
                      //   padding: EdgeInsets.all(10),
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     mainAxisAlignment: MainAxisAlignment.start,
                      //     children: [
                      //     Text(_rooms[index]['room_name'], style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      //     SizedBox(
                      //       height: 8,
                      //     ),
                      //     Row(
                      //       children: [
                      //         Text('Buổi đầu:  ', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                      //         Text(_rooms[index]['date_start'], style: TextStyle(fontSize: 22,)),
                      //       ]
                      //     ),
                          
                      //   ],)
                      // )

                    )
                      )
                    );                                        
                   }

                ),
                
              ),
            ]
          )
          ),
          
        // ),
    );
  }
}