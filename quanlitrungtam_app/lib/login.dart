import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/home_teacher.dart';
import 'package:quanlitrungtam_app/home_student.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }
  String _email = '';
  String _password = '';
  String _type = '';
  var _tok = '';

  loginPressed() async{
    final storage = new FlutterSecureStorage();
    if (_email.isNotEmpty && _password.isNotEmpty) {
      final params = {'password': _password, 'email': _email,};
      await http
          .post(Uri.parse('http://10.0.2.2:8000/api/login2'), body: params)
          .then((response) async {
        var jsonData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          await storage.write(key: 'token', value: jsonData['token']);
          // _tok = await storage.read(key: 'token');
          // await storage.write(key: 'token', value: 'token');
          _tok = await storage.read(key: 'token').toString();
          await storage.write(key: 'user', value: jsonEncode(jsonData['user']));
          // successSnackBar(context, 'Xin chào');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Đăng nhập thành công'),
            // content: Text(jsonData['user']['type']),
            duration: const Duration(milliseconds: 1400),
          ));
          if(jsonData['user']['type'] == '2'){
            goToTeacherHomePage();
          }
          if(jsonData['user']['type'] == '3'){
            goToStudentHomePage();
          }
        } else {
          // errorSnackBar(context, jsonData.values.first);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text(jsonData.values.first),
            duration: const Duration(milliseconds: 1400),
          ));
        }
      });
    } else {
      // errorSnackBar(context, 'Xin điền email và password');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Xin điền email và password'),
        duration: const Duration(milliseconds: 1400),
      ));
    }
  }

  goToTeacherHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => TeacherMenuScreen()),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => TeacherMenuScreen()),
    // );
  }

  goToStudentHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => StudentMenuScreen()),
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => StudentMenuScreen()),
    // );
  }


// @override
  // void initState() {
  //   sideMenu.addListener((p0) {
  //     page.jumpToPage(p0);
  //   });
  //   super.initState();
  // }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/world2.JPG'),
                  fit: BoxFit.cover,
                ),
            ),
            child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    // height: 80,
                    height: 125,
                  ),
                  // Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 40,), textAlign: TextAlign.center,),
                  const SizedBox(
                    height: 40,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập email',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      // fillColor: Theme.of(context).primaryColor.withOpacity(0.7),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _email = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Nhập password',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      // fillColor: Theme.of(context).primaryColor.withOpacity(0.7),
                      fillColor: Colors.white.withOpacity(0.9),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MaterialButton(
                    child: Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                    textColor: Colors.white,
                    color: Colors.greenAccent,
                    hoverColor: Colors.greenAccent.shade200,
                    shape: StadiumBorder(),
                    minWidth: 220,
                    height: 70,
                    onPressed: () => loginPressed(),
                  ),
                  const SizedBox(
                    height: 350,
                  ),
                ],
              ),
            )
            
          ),
            )
    );
  }
}