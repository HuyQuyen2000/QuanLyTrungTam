import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PDFviewScreen extends StatefulWidget{
  var docName;
  PDFviewScreen({Key? key, @required this.docName}) : super(key: key);

  @override
  State<PDFviewScreen> createState() => _PDFviewScreenState(docName);
}

class _PDFviewScreenState extends State<PDFviewScreen>{
  final docName;
  _PDFviewScreenState(this.docName);


  final storage = new FlutterSecureStorage();
  String _id= '';
  String _document_name = '';
 
  List<dynamic> _user = [];

  bool _loading = true;
  bool _error = false;


  String localPath ='';


  // loadPostInfor() async {
    

  //   String params = '?post_id=' + postID.toString();
  //   await http.get(Uri.parse('http://10.0.2.2:8000/api/iddocument' + params)).then((response) {
  //     if (response.statusCode == 200) {
  //       final jsonData = jsonDecode(response.body);
  //       if (jsonData != null) {
  //         setState(() {
  //           var document = jsonData;
  //           _document_name = document['document_name'].toString();

  //         });
  //       }
  //     } else
  //       setState(() {
  //         _error = true;
  //       });
  //   }).catchError((error) {
  //     setState(() {
  //       _error = true;
  //     });
  //   });

  // }
  // http.get(Uri.parse('http://10.0.2.2:8000/api/teacherrooms'))

  



  @override
  void initState() {
    super.initState();
    // loadPostInfor();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        centerTitle: true,
        elevation: 0,
        title: Text(
          'PDF Reader',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),


      body: 
      docName.toString() != ''
      ?Container(
        // Container(
                    child: SfPdfViewer.network(
                        // 'http://10.0.2.2:8000/api/getFile',
                        'http://10.0.2.2:8000/api/getFileTeacher?doc_name='+docName.toString(),
                        // 'http://10.0.2.2:8000/api/getFileTeacher?doc_name=11693782671682143422.pdf',
                        // 'http://10.0.2.2:8000/api/getFileTeacher2?post_id=' + postID.toString(),
                        canShowScrollHead: false,
                        canShowScrollStatus: false)
                          )
      :Container(child: Center(child: CircularProgressIndicator()),)

      // body: Container(
      //   child: Text(_document_name.toString()),
      // )
      
      
    );
  }
}