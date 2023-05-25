import 'package:flutter/material.dart';
import 'package:quanlitrungtam_app/main.dart';
import 'package:quanlitrungtam_app/show_file2.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:file_picker/file_picker.dart';
import 'package:dio/dio.dart';
import 'package:chunked_uploader/chunked_uploader.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

// import 'package:simple_permissions/simple_permissions.dart';

class TeacherMenubScreen extends StatefulWidget{
  const TeacherMenubScreen({Key? key}) : super(key: key);

  @override
  State<TeacherMenubScreen> createState() => _TeacherMenubScreenState();
}

class _TeacherMenubScreenState extends State<TeacherMenubScreen>{
  String _file_name = '456';
  
  List<PlatformFile>? _paths;
  String? _extension;
  double progress = 0.0;
  String link = '';

  
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
      String url = 'http://10.0.2.2:8000/api/file_upload'; // change it with your api url
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
            'additional_data': 'hiii',
          },
          onUploadProgress: (v) {
            if (kDebugMode) {
              print(v);
            }
          },
        );
        if (kDebugMode) {
          print(response);
        }

      } on DioError catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

    }
    
  } 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   centerTitle: true,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _pickFiles();
              },
              child: const Text('Select File'),
            ),
            Text(_file_name),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                upload();
              },
              child: const Text('Upload'),
            ),
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ShowFile2Screen()),
                );
              },
              child: const Text('Show file ở đây'),
            ),
          ],
        ),
      ),
    );
  }
// @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   backgroundColor: Colors.greenAccent,
//       //   centerTitle: true,
//       //   elevation: 0,
//       //   title: const Text(
//       //     'Quản lý trung tâm Anh ngữ',
//       //     style: TextStyle(
//       //       fontSize: 20,
//       //       fontWeight: FontWeight.bold,
//       //     ),
//       //   ),
//       // ),

//       body: SingleChildScrollView(
//           child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Text('AAA'),
//               ]
//           )
//       ),
//     );
//   }
}