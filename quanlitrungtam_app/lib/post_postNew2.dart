import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';

import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class NewPostScreen2 extends StatefulWidget{
  var roomID;
  NewPostScreen2({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<NewPostScreen2> createState() => _NewPostScreen2State(roomID);
}

class _NewPostScreen2State extends State<NewPostScreen2>{
  final roomID;
  _NewPostScreen2State(this.roomID);

  String _account_id = '';
  String _room_id = '';
  int _post_type = 1;
  String _content = '';

  newPost() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _room_id = roomID.toString();
      _account_id = jsonDecode(user)['account_id'].toString();
      _post_type = 1;

    });
    }

    final params = {
      'room_id': _room_id.toString(),
      'account_id': _account_id.toString(),
      'post_type': _post_type.toString(),
      'content': _content.toString(),
    };
    await http
        .post(Uri.parse('http://10.0.2.2:8000/api/newpost'), body: params)
        .then((response) {
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Đăng bài thành công'),
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
          content: Text('Đăng bài thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Đăng bài thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Thêm bài viết mới',
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
                      onChanged: (value) {
                        _content = value;
                      },
                    ),
                const SizedBox(
                  height: 20,
                ),
                  MaterialButton(
                    child: Text('ĐĂNG NỘI DUNG', style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.orangeAccent.shade700,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: () =>newPost(),
                  ),
              ]
          )
        ),
      ),
    );
  }
}