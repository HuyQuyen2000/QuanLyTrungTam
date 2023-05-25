import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:path_provider/path_provider.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ShowFileScreen extends StatefulWidget{
  const ShowFileScreen({Key? key}) : super(key: key);

  @override
  State<ShowFileScreen> createState() => _ShowFileScreenState();
}

class _ShowFileScreenState extends State<ShowFileScreen>{
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

  static Future<String> loadPDF() async {
    var response = await http.get(Uri.parse('http://10.0.2.2:8000/api/getFile'));
    // var response = await http.get(Uri.parse('https://www.ibm.com/downloads/cas/GJ5QVQ7X'));
    // var response = await http.get("https://www.ibm.com/downloads/cas/GJ5QVQ7X");

    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }



  @override
  void initState() {
    super.initState();
    
    loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });

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
      //         ]
      //     )
      // ),
      body: localPath != null
          ? PDFView(
              filePath: localPath,
            )
          : Center(child: CircularProgressIndicator()),

    );
  }
}