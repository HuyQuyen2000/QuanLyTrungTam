import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/src/painting/borders.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

const Map<String, String> headers = {"Content-Type": "application/json"};

class NewRoomSScreen extends StatefulWidget{
  const NewRoomSScreen({Key? key}) : super(key: key);

  @override
  State<NewRoomSScreen> createState() => _NewRoomSScreenState();
}

class _NewRoomSScreenState extends State<NewRoomSScreen>{
  DateTime _chosenDate = DateTime.now();

  TimeOfDay time = TimeOfDay.now();
  var picked;

  String _room_name = '';
  String _max_mem = '';
  String _date_start = 'Thông tin bắt buộc (Thứ hai lịch học sẽ là T2,4,6 / Thứ ba lịch học sẽ là T3,5,7)';
  String _date_end = 'Thông tin bắt buộc';
  String _time_start = 'TT bắt buộc';
  String _time_end = 'TT bắt buộc (giờ kết thúc phải sau giờ bắt đầu)';

  String _account_id = '';
  String _teacher_name = 'Thông tin bắt buộc';
    String _teacher_email = '';
  List<dynamic> _teacher_list = [];
  int _type = 2;
    String _search_name = '';

  String _course_name = 'Thông tin bắt buộc';
  String _course_id = '';

  String _classroom_name = 'Thông tin bắt buộc';
  String _classroom_id = '';

  List<dynamic> _classRooms = [];

  String _date_startt = '';

  List<dynamic> _courses = [];
  List<dynamic> _temp = [];

  List<dynamic> _languages = [
    {'language_id': 0, 'name': 'Tất cả'},
  ];
  int _language_id = 0;

  loadLanguageList() async {
    setState(() {
      _temp = [];
      // _languages = [];
    });
    // final params = {'type': _type.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/alllanguages"))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _temp = jsonData;
        _languages = _languages..addAll(_temp);
        // _languages = jsonData;
        _language_id = _languages[0]['language_id'];
      });

    });
  }

  loadCourseList() async {
    setState(() {
      _courses = [];
    });
    final params = {'language_id': _language_id.toString()};
    await http
        .get(Uri.http('localhost:8000', "/api/languagecourses", params))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _courses = jsonData;
      });

    });
  }

  void selectRoom(){
    if((_date_start != '')&&(_time_start != '')&&(_time_end != '')&&(_course_id != '')&&(_max_mem != '')){
      loadRoomList().then((value) {
        if((DateFormat("H:mm").parse(_time_start)).isBefore((DateFormat("H:mm").parse(_time_end)))){
          showModal1(context);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
            duration: const Duration(milliseconds: 2000),
          ));
        }
          
          // if(_classRooms.length == 0){
          //   Navigator.pop(context, true);
          // }
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Hãy nhập thông tin khóa học, số lượng, ngày giờ trước khi nhập dữ liệu này'),
          duration: const Duration(milliseconds: 2500),
        ));
    }
  }

  loadRoomList() async {
    setState(() {
      _classRooms = [];
      // _loading = true;
    });
    final params = {
      'date_start': _date_start.toString(),
      'time_start': _time_start.toString(),
      'time_end': _time_end.toString(),
      'course_id': _course_id.toString(),
      'max_mem': _max_mem.toString(),
    };
    await http
        .get(Uri.http('localhost:8000', "/api/showclassrooms", params))
        .then((response){
          if (response.statusCode == 200) {
        // successSnackBar(context, 'Thêm mới thành công');
        var jsonData = jsonDecode(response.body);
        setState(() {
          _classRooms = jsonData;
        });
      } else if (response.statusCode == 430) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      }
      

    });

  }

  void selectTeacher(){
    if((_date_start != '')&&(_time_start != '')&&(_time_end != '')&&(_course_id != '')&&(_max_mem != '')){
      loadTeacherList().then((value) {
          if((DateFormat("H:mm").parse(_time_start)).isBefore((DateFormat("H:mm").parse(_time_end)))){
          showModal2(context);
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.red,
            content: Text('Thời gian kết thúc phải sau thời gian bắt đầu'),
            duration: const Duration(milliseconds: 2000),
          ));
        }

      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Hãy nhập thông tin khóa học, số lượng, ngày giờ trước khi nhập dữ liệu này'),
          duration: const Duration(milliseconds: 2500),
        ));
    }
  }

  loadTeacherList() async {
    setState(() {
      _teacher_list = [];
      // _loading = true;
    });
    final params = {
      'date_start': _date_start.toString(),
      'time_start': _time_start.toString(),
      'time_end': _time_end.toString(),
      'course_id': _course_id.toString(),
      'max_mem': _max_mem.toString(),
      'search_name': _search_name.toString(),
    };
    await http
        .get(Uri.http('localhost:8000', "/api/showteachers", params))
        .then((response){
          if (response.statusCode == 200) {
        // successSnackBar(context, 'Thêm mới thành công');
        var jsonData = jsonDecode(response.body);
        setState(() {
          _teacher_list = jsonData;
        });
      } else if (response.statusCode == 430) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text(jsonDecode(response.body).values.first),
          duration: const Duration(milliseconds: 1400),
        ));
      }
      

    });

  }



  newRoom() async{
    final storage = new FlutterSecureStorage();
    // var token = await storage.read(key: 'token');
    var token = '';

    final params = {
      'room_name': _room_name.toString(),
      'max_mem': _max_mem.toString(),
      'date_start': _date_start.toString(),
      'time_start': _time_start.toString(),
      'time_end': _time_end.toString(),
      'account_id': _account_id.toString(),
      'course_id': _course_id.toString(),
      'classroom_id': _classroom_id.toString(),
    };
    await http
        .post(Uri.http('localhost:8000', "/api/newroomS", params),)
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
          content: Text('Thêm mới thất bại 1'),
          duration: const Duration(milliseconds: 1400),
        ));
      }
    }).catchError((e) {
      setState(() {
        // errorSnackBar(context, 'Thêm mới thất bại');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red,
          content: Text('Thêm mới thất bại 2'),
          duration: const Duration(milliseconds: 1400),
        ));
      });
    });

    // Navigator.pop(context, true);
  }


  Future<Null> selectTime(BuildContext context, int startorend) async {
    picked = await showTimePicker(context: context, initialTime: time);

    if (picked != null) {
      setState(() {
        time = picked;
        String tempHour = time.hour.toString();
        String tempMinute = time.minute.toString();
        if (time.hour < 10) tempHour = '0' + picked.hour.toString();
        if (time.minute < 10) tempMinute = '0' + picked.minute.toString();
        if (startorend == 0) {
          _time_start = tempHour + ':' + tempMinute + ':00';
        } else
          _time_end = tempHour + ':' + tempMinute + ':00';
      });
    }
  }

  void showModal(BuildContext context) {
    // loadCourseList();
    showDialog(
      context: context,
      builder:(BuildContext context) =>
          Center(
            child: Container(
              color: Colors.white,
              width: 900,
              height: 600,
              child: Material(
              child: SingleChildScrollView(
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Chọn khóa học', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(
                        children: [
                          SizedBox(
                            width: 330,
                            child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                    prefixIcon: Text('    Chọn ngôn ngữ   ',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                                    prefixIconConstraints: (BoxConstraints(minWidth: 150, minHeight: 20)),
                                    // hintText: 'Thông tin bắt buộc',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(40),
                                        borderSide: BorderSide.none),
                                    fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                                    filled: true,
                                  ),
                                // borderRadius: BorderRadius.circular(40),
                                  items: _languages.map((valueItem) {
                                    return DropdownMenuItem(
                                        value: valueItem['language_id'],
                                        child: Text(valueItem['name'].toString()));
                                        // child: Text(valueItem['tag'].toString() + ' con chim non ' + valueItem['tag'].toString()));
                                  }).toList(),
                                  value: _language_id,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _language_id = int.tryParse(newValue.toString())!;
                                      // _language_id = newValue.toString();
                                    });
                                  }
                                  ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          MaterialButton(
                            child: Text('Liệt kê', style: TextStyle(fontSize: 20)),
                            textColor: Colors.white,
                            color: Colors.greenAccent,
                            hoverColor: Colors.greenAccent.shade100,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0),),),
                            minWidth: 120,
                            height: 60,
                            onPressed: () {
                              loadCourseList().then((value) {
                                Navigator.pop(context, true);
                                showModal(context);
                              });
                              // Navigator.pop(context, true);
                              // showModal(context);
                            },
                          ),
                          
                        ]
                      ),
                      SizedBox(
                        height: 10,
                      ),
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
                                'Tên khóa học',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Ngôn ngữ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Số buổi',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Học phí',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                '',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          
                        ],
                        
                        rows: List<DataRow>.generate(
                            _courses.length,
                                (index) => DataRow(cells: [
                              // DataCell(Text((index+1).toString())),
                              DataCell(Text(_courses[index]['course_id'].toString())),
                              DataCell(Text(_courses[index]['name'].toString())),
                              DataCell(Text(_courses[index]['language']['name'].toString())),
                              DataCell(Text(_courses[index]['lessons'].toString())),
                              DataCell(Text(_courses[index]['cost'].toString() + ' VND')),
                              DataCell(TextButton(
                                child: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: (){
                                  setState(() {
                                    _course_id = _courses[index]['course_id'].toString();
                                    _course_name = _courses[index]['name'].toString();
                                  });
                                  Navigator.pop(context, true);
                                },
                              )),
                            ])
                        ),
                      )
                    ]
                )
            ),
            ),
            ),
          ), 
        
    );
  }

  void showModal1(BuildContext context) {
    // loadCourseList();
    showDialog(
      context: context,
      builder:(BuildContext context) =>
          Center(
            child: Container(
              color: Colors.white,
              width: 900,
              height: 600,
              child: Material(
              child: SingleChildScrollView(
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Chọn phòng học còn trống đủ sức chứa', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
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
                                'Tên phòng',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Sức chứa',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Expanded(
                              child: Text(
                                'Ghi chú',
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
                        ],
                        
                        rows: List<DataRow>.generate(
                            _classRooms.length,
                                (index) => DataRow(cells: [
                              DataCell(Text((index+1).toString())),
                              DataCell(Text(_classRooms[index]['name'].toString())),
                              DataCell(Text(_classRooms[index]['capacity'].toString())),
                              DataCell(Text(_classRooms[index]['note'].toString())),
                              DataCell(TextButton(
                                child: Icon(Icons.add_circle_outline, color: Colors.green),
                                onPressed: (){
                                  setState(() {
                                    _classroom_id = _classRooms[index]['classroom_id'].toString();
                                    _classroom_name = _classRooms[index]['name'].toString();
                                  });
                                  Navigator.pop(context, true);
                                },
                              )),
                            ])
                        ),
                      )
                    ]
                )
            ),
            ),
            ),
          ), 
        
    );
  }


  void showModal2(BuildContext context) {
    // loadCourseList();
    showDialog(
      context: context,
      builder:(BuildContext context) =>
          Center(
            child: Container(
              color: Colors.white,
              width: 900,
              height: 600,
              child: Material(
              child: SingleChildScrollView(
                child: Column(
                    // mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text('Chọn giáo viên với lịch còn trống', style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      Wrap(children: [
                        SizedBox(
                          width: 600,
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
                            loadTeacherList().then((value) {
                                Navigator.pop(context, true);
                                showModal2(context);
                                _search_name = '';
                              });
                          },
                        ),

                      ]),
                      
                      const SizedBox(
                        height: 20,
                      ),
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
                                ' ',
                                style: TextStyle(fontStyle: FontStyle.italic),
                              ),
                            ),
                          ),
                        ],
                        rows: List<DataRow>.generate(
                            _teacher_list.length,
                                (index) => DataRow(cells: [
                                  DataCell(Text((index+1).toString())),
                                  DataCell(Text(_teacher_list[index]['account_id'].toString())),
                                  DataCell(Text(_teacher_list[index]['name'].toString())),
                                  DataCell(Text(_teacher_list[index]['email'].toString())),
                                  DataCell(Text(_teacher_list[index]['phone'].toString())),
                                  DataCell(TextButton(
                                    child: Icon(Icons.add_circle_outline, color: Colors.green),
                                    onPressed: (){
                                      setState(() {
                                        _account_id = _teacher_list[index]['account_id'].toString();
                                        _teacher_name = _teacher_list[index]['name'].toString();
                                        _teacher_email = _teacher_list[index]['email'].toString();
                                      });
                                      Navigator.pop(context, true);
                            
                                    },
                                  )),
                            ])
                        ),
                      )
                      
                    ]
                )
            ),
            ),
            ),
          ), 
        
    );
  }


  @override
  void initState() {
    super.initState();
    loadLanguageList();
    loadCourseList();
    // loadRoomList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.greenAccent,
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Thêm lớp học mới',
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
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập tên lớp học mới',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      // prefixStyle: TextStyle(color: Colors.black, fontSize: 20),
                      hintText: 'Thông tin bắt buộc',
                      // hintText: _teacher_list.toString(),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _room_name = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập khóa học',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _course_name,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _course_name = value;
                      _classroom_id = '';
                      _classroom_name = 'Thông tin bắt buộc';
                      _teacher_name = 'Thông tin bắt buộc';
                      _teacher_email = '';
                      _account_id = '';
                    },
                    onTap: () {
                      // loadLanguageList();
                      // loadCourseList();
                      showModal(context);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập số lượng học viên',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: 'Thông tin bắt buộc',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _max_mem = value;
                      _classroom_id = '';
                      _classroom_name = 'Thông tin bắt buộc';
                      _teacher_name = 'Thông tin bắt buộc';
                      _teacher_email = '';
                      _account_id = '';

                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập ngày học đầu',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _date_start,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _date_start = value;
                      _classroom_id = '';
                      _classroom_name = 'Thông tin bắt buộc';
                      _teacher_name = 'Thông tin bắt buộc';
                      _teacher_email = '';
                      _account_id = '';
                    },
                    onTap: () async {
                      var chosenDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015, 1, 1),
                          lastDate: DateTime(2025, 12, 31));
                      if (chosenDate != null)
                        setState(() {
                          // _date_start = DateFormat('y-M-d').parse(chosenDate.toString()).toString();
                          // var temp = DateFormat('E y-MM-dd').parse(chosenDate.toString());
                          _date_start = DateFormat('E y-MM-dd').format(chosenDate);
                          // _dateDMY = dMY(chosenDate.toString());
                        });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 575,
                        child:TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: Text('    Nhập giờ bắt đầu',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                            hintText: _time_start,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none),
                            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                          ),
                          onChanged: (value) {
                            _time_start = value;
                            _classroom_id = '';
                            _classroom_name = 'Thông tin bắt buộc';
                            _teacher_name = 'Thông tin bắt buộc';
                            _teacher_email = '';
                            _account_id = '';
                          },
                          onTap: () async {
                            selectTime(context, 0);
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 575,
                        child: TextField(
                          readOnly: true,
                          decoration: InputDecoration(
                            prefixIcon: Text('    Nhập giờ kết thúc',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                            prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                            hintText: _time_end,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide.none),
                            fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                            filled: true,
                          ),
                          onChanged: (value) {
                            _time_end = value;
                            _classroom_id = '';
                            _classroom_name = 'Thông tin bắt buộc';
                            _teacher_name = 'Thông tin bắt buộc';
                            _teacher_email = '';
                            _account_id = '';
                          },
                          onTap: () async {
                            selectTime(context, 1);
                          },
                        ),

                      ),

                    ],
                  ),   
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập giáo viên giảng dạy',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _teacher_name + '  ' +_teacher_email,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _teacher_name = value;
                    },
                    onTap: () {
                      selectTeacher();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    readOnly: true,
                    decoration: InputDecoration(
                      prefixIcon: Text('    Nhập phòng học',style: TextStyle(fontSize: 15), textAlign: TextAlign.left,),
                      prefixIconConstraints: (BoxConstraints(minWidth: 190, minHeight: 20)),
                      hintText: _classroom_name,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40),
                          borderSide: BorderSide.none),
                      fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                      filled: true,
                    ),
                    onChanged: (value) {
                      _classroom_name = value;
                    },
                    onTap: () {
                      selectRoom();
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  MaterialButton(
                    child: Text('THÊM MỚI', style: TextStyle(fontSize: 20)),
                    // child: Text(_account_id.toString(), style: TextStyle(fontSize: 20)),
                    textColor: Colors.white,
                    color: Colors.greenAccent,
                    hoverColor: Colors.greenAccent.shade100,
                    shape: StadiumBorder(),
                    minWidth: 200,
                    height: 60,
                    onPressed: () {
                      newRoom();
                    },
                  ),
                ]
            )
        ),
      ),
    );
  }
}