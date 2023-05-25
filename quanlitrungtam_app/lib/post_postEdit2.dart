import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';

import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class EditPostScreen2 extends StatefulWidget{
  var postID;
  EditPostScreen2({Key? key, @required this.postID}) : super(key: key);

  @override
  State<EditPostScreen2> createState() => _EditPostScreen2State(postID);
}

class _EditPostScreen2State extends State<EditPostScreen2>{
  final postID;
  _EditPostScreen2State(this.postID);

  String _account_id = '';
  String _room_id = '';
  int _post_type = 1;
  String _content = '';

  var post = null;

  bool _error = false;


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
            // _teacher_name = post['teacher']['name'];
            // _time = post['time'];
            _content = post['content'];
            // _Postaccount_id = post['account_id'].toString();
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

    // if(_account_id == _Postaccount_id){
    //   setState(() {
    //     _visible = true;
    //   });
    // }
  }


  editPost() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    // if (user!=null){
    //   setState(() {
    //   _room_id = postID.toString();
    //   _account_id = jsonDecode(user)['account_id'].toString();
    //   _post_type = 1;

    // });
    // }

    final params = {
      'content': _content.toString(),
      'post_id': postID.toString(),
    };
    await http
        .patch(Uri.parse('http://10.0.2.2:8000/api/editpost'), body: params)
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Chỉnh sửa bài viết thành công'),
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
          content: Text('Chỉnh sửa thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Chỉnh sửa thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });
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
          title: const Text(
            'Chỉnh sửa bài viết',
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
        //       Text('Đây là trang thêm bài viết mới'),
        //     ]
        //   )
        // ),

        body: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text('Nhập nội dung bài viết', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 30,
                ),
                    TextField(
                      maxLines: 10,
                      decoration: InputDecoration(
                        // prefixIcon: Text('    Nhập tên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                        // prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                        // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                        hintText: 'Hãy nhập nội dung tại đây',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      controller: TextEditingController(text: _content),
                      onChanged: (value) {
                        _content = value;
                      },
                    ),
                const SizedBox(
                  height: 20,
                ),
                  MaterialButton(
                    child: Text('SỬA NỘI DUNG', style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.orangeAccent.shade700,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: () =>editPost(),
                  ),
              ]
          )
        ),
      ),
    );
  }
}