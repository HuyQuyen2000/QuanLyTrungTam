import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfileScreen extends StatefulWidget{
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>{
  final storage = new FlutterSecureStorage();
  String _id= '';
  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  String _type = '';
  List<dynamic> _user = [];

  bool _loading = true;
  bool _error = false;

  loadUserProfile() async {
    setState(() {
      // _users = [];
      _loading = true;
    });
    // final params = {'type': _type.toString(), 'name': _name};

    // const headers = {
    //   "Authorization": "Bearer " + localStorage.getItem("access_token")
    // }

    // await http
    //     .get(Uri.http('localhost:8000', "/api/testlogin"), )
    //     .then((response) {
    //   var jsonData = jsonDecode(response.body);
    //   setState(() {
    //     // _name = ;
    //
    //   });
    // });

    // var user = await storage.read(key: 'user');
    // if (user != null) {
    //   setState(() {
    //     _id = jsonDecode(user)['account_id'];
    //     _name = jsonDecode(user)['name'].toString();
    //     _email = jsonDecode(user)['email'].toString();
    //     _phone = jsonDecode(user)['phone'].toString();
    //     _type = jsonDecode(user)['type'].toString();
    //     _password = jsonDecode(user)['password'].toString();
    //   });
    // }


    setState(() {
      _loading = false;
    });
  }


  @override
  void initState() {
    super.initState();
    loadUserProfile();
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
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text('ID: '+_id),
                Text('Tên: ' + _name),
                Text('Email: ' + _email),
                Text('Phone: ' + _phone),
                Text('Password: ' + _password),
              ]
          )
      ),
    );
  }
}