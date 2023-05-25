import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/PDFviewer.dart';

import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class SubmitTaskScreen extends StatefulWidget{
  var submitID;
  SubmitTaskScreen({Key? key, @required this.submitID}) : super(key: key);

  @override
  State<SubmitTaskScreen> createState() => _SubmitTaskScreenState(submitID);
}

class _SubmitTaskScreenState extends State<SubmitTaskScreen>{
  final submitID;
  _SubmitTaskScreenState(this.submitID);

  String _account_id = '';
  String _room_id = '';
  int _post_type = 2;
  String _content = '';
  String _status_submit ='';
  String _document_name ='';

  String _file_name = '___';
  
  List<PlatformFile>? _paths;
  String? _extension;
  double progress = 0.0;
  String link = '';


  bool _error = false;

  bool _visible1 = false;
  bool _visible2 = false;


  loadSubmitInfor() async {
    // final storage = new FlutterSecureStorage();
    // var user = await storage.read(key: 'user');

    // if(user != null){
    //   setState(() {
    //   _account_id = jsonDecode(user)['account_id'].toString();
    //   });  
    // }

    String params = '?submit_id=' + submitID.toString();
    await http.get(Uri.parse('http://10.0.2.2:8000/api/idsubmit' + params)).then((response) {
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null) {
          setState(() {   
            _status_submit = jsonData['status'].toString();
            _document_name = jsonData['document_name'].toString();
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

    if(_status_submit == '1'){
      setState(() {
        _visible1 = true;
        _visible2 = false;
      });
    }
    else{
      if(_status_submit == '2'){
      setState(() {
        _visible1 = false;
        _visible2 = true;
      });
    }
    }
    

    
  }


  loadFileName() async {
    if(_paths != null){
      var path = _paths![0].path!;
      setState(() {
        _file_name = path.split('/').last;
      });
    }  
  }


    void _pickFiles() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Unsupported operation$e');
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
    loadFileName();  
  }
  
 upload() async {
  // final storage = new FlutterSecureStorage();
  //   // var token = await storage.read(key: 'token');
  //   var token = '';
  //   var user = await storage.read(key: 'user');

  //   if (user!=null){
  //     setState(() {
  //     _room_id = roomID.toString();
  //     _account_id = jsonDecode(user)['account_id'].toString();
  //     _post_type = 2;

  //   });
  //   }


    if (_paths == null) {
      // print('Select a file first.');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text('Chưa chọn file để up load'),
        duration: const Duration(milliseconds: 1400),
      ));
    }
    else{
      var path = _paths![0].path!;
      String fileName = path.split('/').last;
      String url = 'http://10.0.2.2:8000/api/submitTask'; // change it with your api url
      ChunkedUploader chunkedUploader = ChunkedUploader(
        Dio(
          BaseOptions(
            baseUrl: url,
            headers: {
              'Content-Type': 'multipart/form-data',
              'Connection': 'Keep-Alive',
            },
          ),
        ),
      );
      try {
        Response? response = await chunkedUploader.upload(
          fileKey: "file",
          method: "POST",
          filePath: path,
          maxChunkSize: 500000000,
          path: url,
          data: {
            'submit_id': submitID.toString(),
          },
          onUploadProgress: (v) {
            if (kDebugMode) {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   backgroundColor: Colors.red,
              //   content: Text(v.toString()),
              //   duration: const Duration(milliseconds: 5400),
              // ));
              print(v);
            }
          },
        );
        if (kDebugMode) {
          // print(response);
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   backgroundColor: Colors.red,
          //   content: Text(response.toString()),
          //   duration: const Duration(milliseconds: 5400),
          // ));
          print(response);
        }

      } on DioError catch (e) {
        if (kDebugMode) {
          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //   backgroundColor: Colors.red,
          //   content: Text(e.toString()),
          //   duration: const Duration(milliseconds: 5400),
          // ));
          print(e);
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Đăng tài liệu thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        Navigator.pop(context, true);

    }
    
  } 


  @override
  void initState() {
    super.initState();
    loadSubmitInfor();
    // loadFileName();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          centerTitle: true,
          elevation: 0,
          title:  Text(
            'Nộp bài tập' + _status_submit.toString(),
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

        body: Center(
        child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                //     TextField(
                //       maxLines: 4,
                //       decoration: InputDecoration(
                //         // prefixIcon: Text('    Nhập tên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                //         // prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                //         // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                //         hintText: 'Hãy nhập nội dung tại đây',
                //         border: OutlineInputBorder(
                //             borderRadius: BorderRadius.circular(20),
                //             borderSide: BorderSide.none),
                //         fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                //         filled: true,
                //       ),
                //       onChanged: (value) {
                //         _content = value;
                //       },
                //     ),
                // const SizedBox(
                //   height: 20,
                // ),
                Wrap(
                  children:[
                    
                    ElevatedButton(
                      onPressed: () {
                        _pickFiles();
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(40,40),
                        backgroundColor: Colors.greenAccent,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                        Wrap(children: [
                          Icon(Icons.book, size: 20,),
                          Text('  Chọn tài liệu', style: TextStyle(fontSize: 20,)),
                        ],)
                        ],)

                      ),
                      
                  ]
                ),
                Text(_file_name),
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                      visible: _visible1,
                      child: MaterialButton(
                        child: Text('NỘP BÀI', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.greenAccent.shade700,
                        hoverColor: Colors.greenAccent.shade100,
                        shape: StadiumBorder(),
                        minWidth: 200,
                        height: 60,
                        // onPressed: () =>newPost(),
                        onPressed: (){
                          upload();
                        },
                      ),
                ),
                Visibility(
                      visible: _visible2,
                      child: MaterialButton(
                        child: Text('CẬP NHẬT', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.greenAccent.shade700,
                        hoverColor: Colors.greenAccent.shade100,
                        shape: StadiumBorder(),
                        minWidth: 200,
                        height: 60,
                        // onPressed: () =>newPost(),
                        onPressed: (){
                          upload();
                        },
                      ),
                ),
                SizedBox(
                  height: 30,
                ),
                Visibility(
                      visible: _visible2,
                      child: MaterialButton(
                        child: Text('Xem lại bài đã nộp', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.red,
                        hoverColor: Colors.greenAccent.shade100,
                        // shape: StadiumBorder(),
                        minWidth: 200,
                        height: 60,
                        // onPressed: () =>newPost(),
                        onPressed: (){
                          Navigator.push(
                        context,
                        MaterialPageRoute(
                          // builder: (context) => PDFviewScreen(postID: postID.toString())),
                          builder: (context) => PDFviewScreen(docName: _document_name.toString())),
                      ).then((value) {
                          // loadPostInfor();
                        });
                        },
                      ),
                ),
                  
              ]
          )
        ),
      ),
    );
  }
}