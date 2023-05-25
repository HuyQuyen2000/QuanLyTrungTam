import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:quanlitrungtam/index.dart';
import 'package:quanlitrungtam/home.dart';
import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreenb extends StatefulWidget{
  const LoginScreenb({Key? key}) : super(key: key);

  @override
  State<LoginScreenb> createState() => _LoginScreenbState();
}

class _LoginScreenbState extends State<LoginScreenb>{
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }
  String _email = '';
  String _password = '';
  String _type = '1';
  var _tok = '';


  // loginPressed() async{
  //   goToHomePage();
  // }

  loginPressed() async{
    final storage = new FlutterSecureStorage();
    if (_email.isNotEmpty && _password.isNotEmpty) {
      final params = {'password': _password, 'email': _email, 'type': _type};
      await http
          .post(Uri.http('localhost:8000', "/api/login", params))
          .then((response) async {
        var jsonData = jsonDecode(response.body);
        if (response.statusCode == 200) {
          // await storage.write(key: 'token', value: jsonData['token']);
          // _tok = await storage.read(key: 'token');
          await storage.write(key: 'token', value: 'token');
          _tok = await storage.read(key: 'token').toString();
          await storage.write(key: 'user', value: jsonEncode(jsonData['user']));
          // successSnackBar(context, 'Xin chào');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.green,
            content: Text('Đăng nhập thành công'),
            duration: const Duration(milliseconds: 1400),
          ));
          goToHomePage();
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

  goToHomePage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.lightBlue,
        //   centerTitle: true,
        //   elevation: 0,
        //   title: const Text(
        //     'Login',
        //     style: TextStyle(
        //       fontSize: 20,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        // ),

        body:
        SingleChildScrollView(
          // child: Column(children: [ Container(
             // child:Padding(
             //   padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Flexible(child: Center(
                      child: Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.greenAccent,
                      // child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // const SizedBox(
                            // height: 200,
                            // ),
                            Text('QUẢN LÝ CÁC KHÓA HỌC', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w800,), textAlign: TextAlign.center,),
                            const SizedBox(
                              height: 10,
                            ),
                            Text('TRUNG TÂM NGOẠI NGỮ', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.w800,), textAlign: TextAlign.center,),
                          ],
                        ),
                      // ),
                      ),
                      ),
                     ),
                    Flexible(child:
                      Container(
                        // height: MediaQuery.of(context).size.height,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // const SizedBox(
                              //   // height: 80,
                              // ),
                              Text('Đăng nhập tài khoản quản trị viên', style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.w500,), textAlign: TextAlign.center, overflow: TextOverflow.fade,),
                              const SizedBox(
                                height: 20,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Nhập email',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(40),
                                      borderSide: BorderSide.none),
                                  fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
                                  fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
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
                                child: Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 20)),
                                textColor: Colors.white,
                                color: Colors.greenAccent,
                                hoverColor: Colors.greenAccent.shade100,
                                shape: StadiumBorder(),
                                minWidth: 200,
                                height: 60,
                                onPressed: () => loginPressed(),
                              )
                            ],
                          ),
                        ),
                        ),
                    ),
                  ]
              )
              //),

            // ),]),
        )

    );
  }
}