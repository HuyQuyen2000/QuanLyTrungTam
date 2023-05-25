import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/post_postNew.dart';
import 'package:quanlitrungtam_app/post_post.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class CommentScreen extends StatefulWidget{
  var postID;
 CommentScreen({Key? key, @required this.postID}) : super(key: key);

  @override
  State<CommentScreen> createState() => _CommentScreenState(postID);
}

class _CommentScreenState extends State<CommentScreen>{
  final postID;
  _CommentScreenState(this.postID);
  String _account_id = '';
  String _post_id = '';
  String _type = '1';

  String _comment_id_edit = '';
  String _comment_content_edit = '';

  String _deleteCommentID = '';


  String _comment_content = '';

  List<dynamic> _comments = [];

  newComment() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _post_id = postID.toString();
      _account_id = jsonDecode(user)['account_id'].toString();
      // _post_type = 1;

    });
    }

    final params = {
      'post_id': _post_id.toString(),
      'account_id': _account_id.toString(),
      // 'post_type': _post_type.toString(),
      'content': _comment_content.toString(),
    };
    await http
        .post(Uri.parse('http://10.0.2.2:8000/api/newcomment'), body: params)
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Đăng bình luận thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Đăng bình luận thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Đăng bình luận thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });
  }

  bool visibleValue(String _comment_userid){
    if(_comment_userid.toString() == _account_id.toString()){
      return true;
    }
    else{
      return false;
    }
    // return false;
  }


  editComment() async {
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _post_id = postID.toString();
      _account_id = jsonDecode(user)['account_id'].toString();
      // _post_type = 1;

    });
    }

    final params = {
      'comment_id': _comment_id_edit.toString(),
      'content': _comment_content_edit.toString(),
    };
    await http
        .patch(Uri.parse('http://10.0.2.2:8000/api/editcomment'), body: params)
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('sửa bình luận thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sửa bình luận thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Sửa bình luận thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });

  }


  deleteComment() async {
    final params = {'comment_id': _deleteCommentID};
    await http
        .delete(Uri.parse('http://10.0.2.2:8000/api/deletecomment'), body: params)
        .then((response){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonDecode(response.body).values.first),
              duration: const Duration(milliseconds: 1400),
            ));
            // loadUserTypeList();
    });
    setState(() {
      _deleteCommentID = '';
    });
  }


  loadCommentList() async {
    final storage = new FlutterSecureStorage();

    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _account_id = jsonDecode(user)['account_id'].toString();
    });
    }
    
    setState(() {
      _comments = [];
    });
    // final params = {'room_id': roomID.toString()};
    String params = '?post_id=' + postID.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/commentlist' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _comments = jsonData;
      });

    });

  }


@override
  void initState() {
    super.initState();
    loadCommentList();
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Bình luận',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),


        body: 
        // SingleChildScrollView(child:
          Padding(
            // padding: const EdgeInsets.symmetric(horizontal: 1),
            padding: EdgeInsets.all(1),
            child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(postID + _comments.toString()),
              Expanded(
                // child: Text(_rooms.toString() + _account_id.toString()),
                child: ListView.builder(
                  // reverse: true,
                  padding: EdgeInsets.all(3),
                  itemCount: _comments.length,
                   itemBuilder: (context, index) {
                    return FractionallySizedBox(
                      widthFactor: 1,
                      child: InkWell(
                        onTap: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => PostScreen(postID: _posts[index]['post_id'])),
                          // ).then((value) {
                          //     loadPostList();
                          //   });
                        },
                        child: Card(
                          color: Colors.cyan.shade100,
                          // surfaceTintColor: Colors.lightBlue,
                          shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      side: BorderSide(
                                        color: Colors.greenAccent,
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
                              Text(_comments[index]['user_account']['name'], style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                              Row(mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: visibleValue(_comments[index]['account_id'].toString()),
                                    child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _comment_id_edit = _comments[index]['comment_id'].toString();
                                                  _comment_content_edit = _comments[index]['content'].toString();
                                                });
                                                showModal2(context);
                                    
                                              },
                                              icon: Icon(Icons.edit, size: 30, color: Colors.blue,),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _deleteCommentID = _comments[index]['comment_id'].toString();
                                                });
                                                deleteComment().then((value) {
                                                                    loadCommentList();
                                                                  });
                                                // Navigator.pop(context);
                                              },
                                              icon: Icon(Icons.delete, size: 30, color: Colors.blue,),
                                            )
                                          ],
                                        ),

                                  ),

                                ],
                              ),
                              

                            ],
                          ),
                          
                          Text(_comments[index]['com_time'].toString(), style: TextStyle(color: Colors.grey.shade600, fontSize: 22)),
                          SizedBox(
                            height: 30,
                          ),
                          Text(_comments[index]['content'], style: TextStyle(fontSize: 23,)),
                          SizedBox(
                            height: 2,
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

          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showModal(context);
            },
            // tooltip: 'Increment',
            child: const Icon(Icons.comment),
          ),



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
                  height: 10,
                ),
                Text('Bình luận mới', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        // prefixIcon: Text('    Nhập tên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                        // prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                        // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                        hintText: 'Hãy nhập nội dung tại đây',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      onChanged: (value) {
                        _comment_content = value;
                      },
                    ),
                    SizedBox(
                        height: 20,
                      ),
                    MaterialButton(
                        child: Text('Đăng', style: TextStyle(fontSize: 23)),
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        // hoverColor: Colors.greenAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 100,
                        height: 40,
                        onPressed: () {
                          newComment().then((value) {
                            loadCommentList();
                          });
                          // Navigator.pop(context);                                     
                          // setState(() {  
                          // });
                        },
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

  void showModal2(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        // content: const Text('Example Dialog', style: TextStyle(fontSize: 20,)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('Chỉnh sửa bình luận', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 20,
                ),
                TextField(
                      maxLines: 5,
                      decoration: InputDecoration(
                        // prefixIcon: Text('    Nhập tên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                        // prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                        // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                        hintText: 'Hãy nhập nội dung tại đây',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      controller: TextEditingController(text: _comment_content_edit),
                      onChanged: (value) {
                        _comment_content_edit = value;
                      },
                    ),
                    SizedBox(
                        height: 20,
                      ),
                    MaterialButton(
                        child: Text('Chỉnh sửa', style: TextStyle(fontSize: 23)),
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        // hoverColor: Colors.greenAccent.shade100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 120,
                        height: 40,
                        onPressed: () {
                          editComment().then((value) {
                            loadCommentList();
                            setState(() {
                              _comment_id_edit = '';
                              _comment_content_edit = '';
                            });
                          });
                          // Navigator.pop(context);                                     
                          // setState(() {  
                          // });
                        },
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