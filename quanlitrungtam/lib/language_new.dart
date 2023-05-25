import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class NewLanguageScreen extends StatefulWidget{
  const NewLanguageScreen({Key? key}) : super(key: key);

  @override
  State<NewLanguageScreen> createState() => _NewLanguageScreenState();
}

class _NewLanguageScreenState extends State<NewLanguageScreen>{
  String _name = '';
  String _email = '';
  String _password = '';
  String _phone = '';
  int _type = 1;

  List type_list = [
    {'tag': 'Admin', 'value': 1},
    {'tag': 'Giáo viên', 'value': 2},
    {'tag': 'Học viên', 'value': 3},
  ];


  addUser() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';

    final params = {
      'name': _name,
    };
    await http
        .post(Uri.http('localhost:8000', "/api/newlanguage", params),)
        .then((response) {
      if (response.statusCode == 200) {
        // successSnackBar(context, 'Thêm mới thành công');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Thêm mới thành công'),
          duration: const Duration(milliseconds: 1400),
        ));
        Navigator.pop(context, true);
      } else if (response.statusCode == 430) {
        // errorSnackBar(context, jsonDecode(response.body).values.first);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      } else {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm mới thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm mới thất bại'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });

    // Navigator.pop(context, true);

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thêm mới ngôn ngữ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Wrap(children: [
                const SizedBox(
                  height: 30,
                ),
                    TextField(
                      decoration: InputDecoration(
                        prefixIcon: Text('    Nhập tên ngôn ngữ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                        prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                        // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                        hintText: 'Thông tin bắt buộc',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide.none),
                        fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                        filled: true,
                      ),
                      onChanged: (value) {
                        _name = value;
                      },
                    ),
                //   const SizedBox(
                //     height: 20,
                //   ),
                //   TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: Text('    Nhập Email',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                //       prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                //       hintText: 'Thông tin bắt buộc',
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40),
                //           borderSide: BorderSide.none),
                //       fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                //       filled: true,
                //     ),
                //     onChanged: (value) {
                //       _email = value;
                //     },
                //   ),
                // const SizedBox(
                //   height: 20,
                // ),
                //   TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: Text('    Nhập mật khẩu',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                //       prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                //       hintText: 'Thông tin bắt buộc (>6 ký tự)',
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40),
                //           borderSide: BorderSide.none),
                //       fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                //       filled: true,
                //     ),
                //     onChanged: (value) {
                //       _password = value;
                //     },
                //   ),
                // const SizedBox(
                //   height: 20,
                // ),
                //   TextField(
                //     decoration: InputDecoration(
                //       prefixIcon: Text('    Nhập số điện thoại',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                //       prefixIconConstraints: (BoxConstraints(minWidth: 160, minHeight: 20)),
                //       hintText: 'Thông tin không bắt buộc',
                //       border: OutlineInputBorder(
                //           borderRadius: BorderRadius.circular(40),
                //           borderSide: BorderSide.none),
                //       fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                //       filled: true,
                //     ),
                //     onChanged: (value) {
                //       _phone = value;
                //     },
                //   ),
                // const SizedBox(
                //   height: 20,
                // ),
                //   Row(children: [
                //     Text('    Loại:    ',
                //         style: TextStyle(
                //             fontSize: 17, color: Colors.lightBlue)),
                //     DropdownButton(
                //         // borderRadius: BorderRadius.circular(40),
                //         items: type_list.map((valueItem) {
                //           return DropdownMenuItem(
                //               value: valueItem['value'],
                //               child: Text(valueItem['tag'].toString()));
                //         }).toList(),
                //         value: _type,
                //         onChanged: (newValue) {
                //           setState(() {
                //             _type = int.tryParse(newValue.toString())!;
                //           });
                //         })
                //   ]),
                const SizedBox(
                  height: 20,
                ),
                  MaterialButton(
                    child: Text('THÊM MỚI', style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.greenAccent,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: () =>addUser(),
                  ),
                // ]),
              ]
          )
        ),
      ),
    );
  }
}