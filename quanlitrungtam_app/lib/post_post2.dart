import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/comments.dart';
import 'package:quanlitrungtam_app/post_postEdit2.dart';

import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class PostScreen2 extends StatefulWidget{
  var postID;
  PostScreen2({Key? key, @required this.postID}) : super(key: key);

  @override
  State<PostScreen2> createState() => _PostScreen2State(postID);
}

class _PostScreen2State extends State<PostScreen2>{
  final postID;
  _PostScreen2State(this.postID);

  String _teacher_name = '';
  String _time = '';
  String _content = '';
  String _account_id = '';
  String _Postaccount_id = '';

  String _deletePostID = '';

  bool _visible = false;

  bool _error = false;

  var post = null;

  loadPostInfor() async {
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');

    if(user != null){
      setState(() {
      _account_id = jsonDecode(user)['account_id'].toString();
      });  
    }

    String params = '?post_id=' + postID.toString();
    await http.get(Uri.parse('http://10.0.2.2:8000/api/idpost' + params)).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {
            post = jsonData;
            _teacher_name = post['teacher']['name'];
            _time = post['time'];
            _content = post['content'];
            _Postaccount_id = post['account_id'].toString();
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

    if(_account_id == _Postaccount_id){
      setState(() {
        _visible = true;
      });
    }
  }


  deletePost() async{
     final params = {'post_id': _deletePostID};
    await http
        .delete(Uri.parse('http://10.0.2.2:8000/api/deletepost'), body: params)
        .then((response){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonDecode(response.body).values.first),
              duration: const Duration(milliseconds: 1400),
            ));
            // loadUserTypeList();
    });
    setState(() {
      _deletePostID = '';
    });
    Navigator.pop(context);

  }


  @override
  void initState() {
    super.initState();
    loadPostInfor();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: Visibility(
            visible: _visible,
            child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditPostScreen2(postID: post['post_id'].toString())),
                  ).then((value) {
                      loadPostInfor();
                    });
                      },
                      icon: Icon(Icons.edit, size: 30),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _deletePostID = postID.toString();
                        });
                        deletePost();
                        // Navigator.pop(context);
                      },
                      icon: Icon(Icons.delete, size: 30),
                    )
                  ],
                ),


          ),
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // SizedBox(
                //   height: 5,
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [
                //     IconButton(
                //       onPressed: () {

                //       },
                //       icon: Icon(Icons.edit, size: 30, color: Colors.blue),
                //     ),
                //     IconButton(
                //       onPressed: () {

                //       },
                //       icon: Icon(Icons.delete, size: 30, color: Colors.blue),
                //     )
                //   ],
                // ),
                SizedBox(
                  height: 20,
                ),
                Text(_teacher_name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Text(_time, style: TextStyle(color: Colors.grey.shade600, fontSize: 22)),
                SizedBox(
                  height: 50,
                ),
                Text(_content, style: TextStyle(fontSize: 23,)),
                // Text(_account_id + ' / ' + _Postaccount_id, style: TextStyle(fontSize: 23,)),
              ]
          )

          ),
          
        ),

        bottomNavigationBar: Stack(
          children: [
            Container(
              height: 60,
              width: 500,
              child: Column(
                children: [
                  ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(postID: postID.toString())),
                  ).then((value) {
                      loadPostInfor();
                    });
                  
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(60,60),
                  backgroundColor: Colors.lightBlue,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  Row(children: [
                    Text('         ', style: TextStyle(fontSize: 30,)),
                    Icon(Icons.comment, size: 30,),
                    Text('   Xem bình luận', style: TextStyle(fontSize: 30,)),
                  ],)
                  ],)

                ),
                ],

              ),
              
            ),
          ],
        ),
    );
  }
}