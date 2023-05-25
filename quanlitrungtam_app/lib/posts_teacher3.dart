import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/post_postNew.dart';
import 'package:quanlitrungtam_app/post_fileNew.dart';
import 'package:quanlitrungtam_app/post_taskNew.dart';
import 'package:quanlitrungtam_app/post_post.dart';
import 'package:quanlitrungtam_app/post_file.dart';
import 'package:quanlitrungtam_app/post_task.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class TeacherPosts3Screen extends StatefulWidget{
  var roomID;
  TeacherPosts3Screen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<TeacherPosts3Screen> createState() => _TeacherPosts3ScreenState(roomID);
}

class _TeacherPosts3ScreenState extends State<TeacherPosts3Screen>{
  final roomID;
  _TeacherPosts3ScreenState(this.roomID);
  String _email = '';
  String _password = '';
  String _type = '1';

  List<dynamic> _posts = [];

  newPost() async{

  }


  loadPostList() async {
    setState(() {
      _posts = [];
    });
    // final params = {'room_id': roomID.toString()};
    String params = '?room_id=' + roomID.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/post3list' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _posts = jsonData;
      });

    });

  }

  bool visibleValueFile(String _post_type){
    if(_post_type.toString() == '2'){
      return true;
    }
    else{
      return false;
    }
  }

  bool visibleValueNews(String _post_type){
    if(_post_type.toString() == '1'){
      return true;
    }
    else{
      return false;
    }
  }

  bool visibleValueTask(String _post_type){
    if(_post_type.toString() == '3'){
      return true;
    }
    else{
      return false;
    }
  }


@override
  void initState() {
    super.initState();
    loadPostList();
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
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/world.JPG'),
                  fit: BoxFit.cover,
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
                  itemCount: _posts.length,
                   itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: InkWell(
                        onTap: () {
                          if(_posts[index]['post_type'].toString() == '1'){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostScreen(postID: _posts[index]['post_id'])),
                          ).then((value) {
                              loadPostList();
                            });
                          };
                          if(_posts[index]['post_type'].toString() == '2'){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostFileScreen(postID: _posts[index]['post_id'])),
                          ).then((value) {
                              loadPostList();
                            });
                          };
                          if(_posts[index]['post_type'].toString() == '3'){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PostTaskScreen(postID: _posts[index]['post_id'])),
                          ).then((value) {
                              loadPostList();
                            });
                          };
                          
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.9),
                          // surfaceTintColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6),
                                      side: BorderSide(
                                        color: Colors.greenAccent,
                                      ),
                                    ),
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          // Text(_posts[index]['teacher']['name'], style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                          // Text(_posts[index]['time'].toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 22)),
                          SizedBox(
                                  height: 15,
                                ),
                          Visibility(
                            visible: visibleValueNews(_posts[index]['post_type'].toString()),
                            child: SizedBox(
                              height: 35,
                            ),
                          ),
                          Visibility(
                            visible: visibleValueFile(_posts[index]['post_type'].toString()),
                            child: Column(
                              children: [
                                Icon(Icons.book, size: 30, color: Colors.green),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                          ),
                          Visibility(
                            visible: visibleValueTask(_posts[index]['post_type'].toString()),
                            child: Column(
                              children: [
                                Wrap(
                                  children: [
                                   Container(
                                        height: 70, // for vertical axis
                                        width: 70, // for horizontal axis
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.greenAccent.shade400),
                                        child: Icon(Icons.home_work, size: 30, color: Colors.white),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('Bài tập ' + (_posts.length - index).toString(), style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                                          Text(_posts[index]['time'].toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 20)),
                                          Text('_________________________________', style: TextStyle(color: Colors.grey.shade600,)),
                                          
                                        ],
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                          ),
                          

                          Text(_posts[index]['content'], style: TextStyle(fontSize: 23,)),
                          SizedBox(
                            height: 8,
                          ),
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
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.greenAccent.shade700,
            onPressed: (){
              // showModal(context);
               Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostTaskScreen(roomID: roomID.toString())),
                      // roomID: _rooms[index]['room_id']
                  ).then((value) {
                      loadPostList();
                    });
            },
            // tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
          
        // ),
    );
  }


  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // content: const Text('Example Dialog', style: TextStyle(fontSize: 20,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostScreen(roomID: roomID.toString())),
                      // roomID: _rooms[index]['room_id']
                  ).then((value) {
                      loadPostList();
                    });
                  
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300,60),
                  backgroundColor: Colors.greenAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(children: [
                    Icon(Icons.newspaper, size: 35,),
                    Text('  Thông báo', style: TextStyle(fontSize: 35,)),
                  ],)
                  ],)

                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostFileScreen(roomID: roomID.toString())),
                      // roomID: _rooms[index]['room_id']
                  ).then((value) {
                      loadPostList();
                    });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300,60),
                  backgroundColor: Colors.greenAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(children: [
                    Icon(Icons.book, size: 35,),
                    Text('  Tài liệu', style: TextStyle(fontSize: 35,)),
                  ],)
                  ],)

                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewPostTaskScreen(roomID: roomID.toString())),
                      // roomID: _rooms[index]['room_id']
                  ).then((value) {
                      loadPostList();
                    });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(300,60),
                  backgroundColor: Colors.greenAccent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(children: [
                    Icon(Icons.home_work, size: 35,),
                    Text('  Bài tập', style: TextStyle(fontSize: 35,)),
                  ],)
                  ],)

                ),
                
              ]),
        actions: <TextButton>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Close', style: TextStyle(fontSize: 23,)),
          )
        ],
      ),
    );
  }
}