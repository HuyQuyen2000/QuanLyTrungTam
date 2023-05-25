import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quanlitrungtam_app/main.dart';
import 'package:flutter/src/painting/borders.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class Event {
  final String classroom;
  final String time_start;
  final String time_end;

  Event(
    this.classroom,
    this.time_start,
    this.time_end,
  );

  String toString() => this.classroom;
}

class CalenderScreen extends StatefulWidget{
  const CalenderScreen({Key? key}) : super(key: key);

  @override
  State<CalenderScreen> createState() => _CalenderScreenState();
}

class _CalenderScreenState extends State<CalenderScreen>{
  final storage = new FlutterSecureStorage();
  DateTime _chosenDate = DateTime.now();

  List<dynamic> _dates = [];
  String _account_id = '';

  // Map<DateTime,List<dynamic>> events;
  // Map<DateTime, List<Event>> selectedEvents;

  // List<Event> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }



  
  loadDates() async {
    final storage = new FlutterSecureStorage();

    var user = await storage.read(key: 'user');

    if (user!=null){
      setState(() {
      _account_id = jsonDecode(user)['account_id'].toString();
    });
    }
    
    setState(() {
      _dates = [];
    });

    String params = '?account_id=' + _account_id.toString();
    await http
        .get(Uri.parse('http://10.0.2.2:8000/api/listScheduleTeacher' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _dates = jsonData;
        // _dates.forEach((element) {
        //     DateFormat('y-MM-DD').parse(element.['date']);
        //   });
      });
      

    });   

  }



  


  @override
  void initState() {
    super.initState();
    loadDates();

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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Text('LỊCH', style: TextStyle(color: Colors.blue, fontSize: 25, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 30,
                ),
                // CalendarDatePicker(
                //   initialDate: DateTime.now(),
                //   firstDate: DateTime(2015, 1, 1),
                //   lastDate: DateTime(2025, 12, 31),
                //   onDateChanged: (DateTime value) {},
                // ),
                
                TableCalendar(
                  locale: "en_US",
                  rowHeight: 43,
                  headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                  focusedDay: _chosenDate,
                  selectedDayPredicate: (day) {
                    return isSameDay(_chosenDate, day);
                  },
                  // eventLoader: (day) => ,
                  firstDay: DateTime(2015, 1, 1),
                  lastDay: DateTime(2025, 12, 31),
                  onDaySelected: (selectedDay, focusedDay){
                    setState(() {
                      _chosenDate = selectedDay;
                    });
                  },

                ),

                // Text(_dates.toString()),
              ]
          )
      ),
    );
  }
}