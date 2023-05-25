import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam/account_add.dart';
import 'package:quanlitrungtam/account_edit.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'dart:convert';

class AccountListScreen extends StatefulWidget{
  const AccountListScreen({Key? key}) : super(key: key);

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen>{
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }

  bool _loading = true;
  bool _error = false;
  List<dynamic> _users = [];
  int _type = 0;
  String _name = '';
  String _deleteid = '';
  String _search_name = '';

  loadUserList() async {
    setState(() {
      _users = [];
      _loading = true;
    });
    // final params = {'type': _type.toString(), 'name': _name};
    await http
        .get(Uri.http('localhost:8000', "/api/allaccounts"))
        .then((response){
            var jsonData = jsonDecode(response.body);
            setState(() {
              _users = jsonData;
            });

          });

    setState(() {
      _loading = false;
    });
  }

  loadUserTypeList() async {
    setState(() {
      _users = [];
      _loading = true;
    });
    final params = {'type': _type.toString(), 'search_name': _search_name};
    await http
        .get(Uri.http('localhost:8000', "/api/alltypeaccounts",params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _users = jsonData;
      });

    });

    setState(() {
      _loading = false;
    });
  }

  deleteUser() async {
    // setState(() {
    //   _users = [];
    //   _loading = true;
    // });
    final params = {'account_id': _deleteid};
    await http
        .delete(Uri.http('localhost:8000', "/api/deleteuser", params))
        .then((response){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.green,
              content: Text(jsonDecode(response.body).values.first),
              duration: const Duration(milliseconds: 1400),
            ));
            loadUserTypeList();
    });
    setState(() {
      _deleteid = '';
    });
  }

  NewUser(){

  }


  @override
  void initState() {
    super.initState();
    loadUserTypeList();
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
                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child:Row(children: [
                      MaterialButton(
                        child: Text('Tất cả', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.greenAccent,
                        hoverColor: Colors.greenAccent.shade100,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 255,
                        height: 40,
                        onPressed: () {
                          setState(() {
                            _type = 0;
                            loadUserTypeList();
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        child: Text('Admin', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.redAccent,
                        hoverColor: Colors.redAccent.shade100,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 255,
                        height: 40,
                        onPressed: () {
                          setState(() {
                            _type = 1;
                            loadUserTypeList();
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        child: Text('Giáo viên', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.orangeAccent,
                        hoverColor: Colors.orangeAccent.shade100,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 255,
                        height: 40,
                        onPressed: () {
                          setState(() {
                            _type = 2;
                            loadUserTypeList();
                          });
                        },
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      MaterialButton(
                        child: Text('Học viên', style: TextStyle(fontSize: 20)),
                        textColor: Colors.white,
                        color: Colors.purple,
                        hoverColor: Colors.purple.shade100,
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                        minWidth: 255,
                        height: 40,
                        onPressed: () {
                          setState(() {
                            _type = 3;
                            loadUserTypeList();
                          });
                        },
                      ),

                    ]),
                ),

                const SizedBox(
                  height: 10,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child:Wrap(children: [
                    SizedBox(
                      width: 920,
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Text('    Tìm kiếm: ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                          prefixIconConstraints: (BoxConstraints(minWidth: 140, minHeight: 20)),
                          // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                          hintText: 'Nhập từ khóa tên tài khoản',
                          // hintText: _room_name,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide.none),
                          fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          filled: true,
                        ),
                        // controller: TextEditingController(text: _room_name),
                        onChanged: (value) {
                          _search_name = value;
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    MaterialButton(
                      child: Text('Tìm kiếm', style: TextStyle(fontSize: 17)),
                      textColor: Colors.white,
                      color: Colors.lightBlue,
                      hoverColor: Colors.lightBlue.shade100,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
                      minWidth: 100,
                      height: 60,
                      onPressed: () {
                        loadUserTypeList();
                      },
                    ),

                  ]),
                ),

                const SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  child: Text('Thêm tài khoản mới', style: TextStyle(fontSize: 20)),
                  textColor: Colors.white,
                  color: Colors.lightBlue,
                  hoverColor: Colors.lightBlue.shade100,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0),),),
                  minWidth: 220,
                  height: 45,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddUserScreen()),
                    ).then((value) {
                      loadUserTypeList();
                    });
                  },
                ),
                // Text('Đây là trang quản lí account nè'),
                DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'STT',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'ID',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Tên',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Email',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Số điện thoại',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          'Loại',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          ' ',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                    DataColumn(
                      label: Expanded(
                        child: Text(
                          ' ',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ),
                  ],
                  // rows: const <DataRow>[
                  //   DataRow(
                  //     cells: <DataCell>[
                  //       DataCell(Text('1')),
                  //       DataCell(Text('Ngô Anh Minh')),
                  //       DataCell(Text('ngoanhnminh@gmail.com')),
                  //       DataCell(Text('82822884')),
                  //       DataCell(Text('Giáo viên')),
                  //     ],
                  //   ),
                  //   DataRow(
                  //     cells: <DataCell>[
                  //       DataCell(Text('1')),
                  //       DataCell(Text('Ngô Anh Anh')),
                  //       DataCell(Text('ngoanhanh@gmail.com')),
                  //       DataCell(Text('82822554')),
                  //       DataCell(Text('Học viên')),
                  //     ],
                  //   ),
                  //   DataRow(
                  //     cells: <DataCell>[
                  //       DataCell(Text('1')),
                  //       DataCell(Text('Dương Anh Minh')),
                  //       DataCell(Text('duonganhnminh@gmail.com')),
                  //       DataCell(Text('74822884')),
                  //       DataCell(Text('Học viên')),
                  //     ],
                  //   ),
                  // ],
                  rows: List<DataRow>.generate(
                      _users.length,
                          (index) => DataRow(cells: [
                            DataCell(Text((index+1).toString())),
                            DataCell(Text(_users[index]['account_id'].toString())),
                            DataCell(Text(_users[index]['name'].toString())),
                            DataCell(Text(_users[index]['email'].toString())),
                            DataCell(Text(_users[index]['phone'].toString())),
                            DataCell(int.parse(_users[index]['type']) == 1
                                ? const Text('Admin')
                                : int.parse(_users[index]['type']) == 2
                                ? const Text('Giáo viên')
                                : int.parse(_users[index]['type']) == 3
                                ? const Text('Học viên')
                                : const Text('Không xác định')),
                            DataCell(TextButton(
                              child: Icon(Icons.edit),
                              onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EditUserScreen(userID: _users[index]['account_id'])),
                                ).then((value) {
                                  loadUserTypeList();
                                });
                              },
                            )),
                            DataCell(TextButton(
                              child: Icon(Icons.delete_forever, color: Colors.red),
                              onPressed: (){
                                setState(() {
                                  _deleteid = _users[index]['account_id'].toString();
                                });
                                deleteUser();
                              },
                            )),
                      ])
                  ),
                )
              ]
          )
      ),
    );
  }
}