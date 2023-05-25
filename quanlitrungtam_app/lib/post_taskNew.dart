import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';

import 'package:flutter/src/painting/borders.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:intl/intl.dart';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class NewPostTaskScreen extends StatefulWidget{
  var roomID;
  NewPostTaskScreen({Key? key, @required this.roomID}) : super(key: key);

  @override
  State<NewPostTaskScreen> createState() => _NewPostTaskScreenState(roomID);
}

class _NewPostTaskScreenState extends State<NewPostTaskScreen>{
  final roomID;
  _NewPostTaskScreenState(this.roomID);

    DateTime _chosenDate = DateTime.now();

  String _account_id = '';
  String _room_id = '';
  int _post_type = 3;
  String _content = '';
  String _deadline = 'Hãy nhập thời hạn của bài tập';

  String _file_name = '___';
  
  List<PlatformFile>? _paths;
  String? _extension;
  double progress = 0.0;
  String link = '';

  newPost() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _room_id = roomID.toString();
      _account_id = jsonDecode(user)['account_id'].toString();
      _post_type = 3;

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
  final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';
    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _room_id = roomID.toString();
      _account_id = jsonDecode(user)['account_id'].toString();
      _post_type = 3;

    });
    }


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
      String url = 'http://10.0.2.2:8000/api/file_uploadTask'; // change it with your api url
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
            'room_id': _room_id.toString(),
            'account_id': _account_id.toString(),
            'post_type': _post_type.toString(),
            'content': _content.toString(),
            'deadline': _deadline.toString(),
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Thêm bài tập mới',
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
                Text('Nhập ghi chú cho bài tập', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 10,
                ),
                    TextField(
                      maxLines: 2,
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
                Text('Nhập thời hạn của bài tập', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),    
                const SizedBox(
                  height: 10,
                ),
                TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        // prefixIcon: Text('    Nhập tên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                        // prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                        // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                        hintText: _deadline,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none),
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      onChanged: (value) {
                        _deadline = value;
                      },
                      onTap: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          // initialDate: DateTime.parse(_deadline),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          // _date_start = DateFormat('y-M-d').parse(chosenDate.toString()).toString();
                          var temp = DateFormat('y-MM-dd').parse(chosenDate.toString());
                          _deadline = DateFormat('y-MM-dd').format(temp);
                          // _dateDMY = dMY(chosenDate.toString());
                        });
                    },
                    ),
                const SizedBox(
                  height: 20,
                ),    
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
                  MaterialButton(
                    child: Text('THÊM BÀI TẬP MỚI', style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.greenAccent.shade700,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: (){
                      upload();
                    },
                  ),
              ]
          )
        ),
      ),
    );
  }
}