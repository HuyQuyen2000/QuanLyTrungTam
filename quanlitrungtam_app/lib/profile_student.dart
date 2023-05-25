import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

class StudentInforScreen extends StatefulWidget{
  const StudentInforScreen({Key? key}) : super(key: key);

  @override
  State<StudentInforScreen> createState() => _StudentInforScreenState();
}

class _StudentInforScreenState extends State<StudentInforScreen>{
  String _email = '';
  String _password = '';
  String _name = '';
  String _phone = '';
  String _type = '1';

  bool visibleName = true;
  bool visibleMail = true;
  bool visiblePhone = true;

  bool visibleNameEdit = false;
  bool visibleMailEdit = false;
  bool visiblePhoneEdit = false;

  loadUser() async{
    final storage = new FlutterSecureStorage();
    var user = await storage.read(key: 'user');
    if(user != null){
      setState(() {
      _email = jsonDecode(user)['email'].toString();
      _name = jsonDecode(user)['name'].toString();
      _phone = jsonDecode(user)['phone'].toString();
      });
      
    }
    else{
      setState(() {
      _email = 'Lỗi';
      _name = 'Lỗi';
      _phone = 'lỗi';
      });   
    }

  }

  @override
  void initState() {
    super.initState();
    loadUser();
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

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
              ),
              Text('Thông tin tài khoản', style: TextStyle(color: Colors.pink, fontSize: 25, fontWeight: FontWeight.bold)),
              SizedBox(
                height: 40,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('E-mail:  ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      Text(_email, style: TextStyle(fontSize: 19)),
                    ],
                  ),
                  //  IconButton(
                  //     onPressed: () {
                        
                  //     },
                  //     icon: Icon(Icons.edit, size: 30),
                  //   ),
                ],
              ),
              SizedBox(
                height: 45,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Tên:  ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      Text(_name, style: TextStyle(fontSize: 19)),
                    ],
                  ),
                   IconButton(
                      onPressed: () {
                        
                      },
                      icon: Icon(Icons.edit, size: 30, color: Colors.blue,),
                    ),
                ],
              ),
              SizedBox(
                height: 35,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('SĐT:  ', style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold)),
                      Text(_phone, style: TextStyle(fontSize: 19)),
                    ],
                  ),
                   IconButton(
                      onPressed: () {
                        
                      },
                      icon: Icon(Icons.edit, size: 30, color: Colors.blue,),
                    ),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              MaterialButton(
                    child: 
                        Wrap(
                          children: [
                            Icon(Icons.password, size: 25),
                            Text('   Thay đổi mật khẩu', style: TextStyle(fontSize: 25)),
                          ],
                        ),
                  textColor: Colors.white,
                  color: Colors.orangeAccent,
                  // hoverColor: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  minWidth: 300,
                  height: 60,
                  onPressed: () {
                    
                  },
                ),

             
            ]
          )
          ),
        ),
    );
  }
}