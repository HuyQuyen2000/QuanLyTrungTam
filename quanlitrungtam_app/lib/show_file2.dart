import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowFile2Screen extends StatefulWidget{
  const ShowFile2Screen({Key? key}) : super(key: key);

  @override
  State<ShowFile2Screen> createState() => _ShowFile2ScreenState();
}

class _ShowFile2ScreenState extends State<ShowFile2Screen>{
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


  String localPath ='';

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
  // http.get(Uri.parse('http://10.0.2.2:8000/api/teacherrooms'))

  



  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Quản lý trung tâm Anh ngữ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      // body: SingleChildScrollView(
      //     child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         mainAxisAlignment: MainAxisAlignment.start,
      //         children: [
      //           Text('Show file ở đây'),
      //           // Container(
      //           //     child: SfPdfViewer.network(
      //           //         'https://cdn.syncfusion.com/content/PDFViewer/flutter-succinctly.pdf',
      //           //         canShowScrollHead: false,
      //           //         canShowScrollStatus: false))
      //         ]
      //     )
      // ),

      // body: Container(
      //               child: SfPdfViewer.network(
      //                   'http://10.0.2.2:8000/api/getFile',
      //                   canShowScrollHead: false,
      //                   canShowScrollStatus: false)
      //                     ),
      
      
    );
  }
}