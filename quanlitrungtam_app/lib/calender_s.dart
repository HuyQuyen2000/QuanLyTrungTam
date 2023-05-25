import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';

class Event {
  final String title;
  Event(@required this.title);

  String toString() => this.title;
}

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  final storage = new FlutterSecureStorage();
  DateTime _chosenDate = DateTime.now();

  List<dynamic> _dates = [];
  String _account_id = '';
  String a ='';

  TextEditingController _eventController = TextEditingController();

  

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }


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
        .get(Uri.parse('http://10.0.2.2:8000/api/listScheduleStudent' + params.toString()))
        .then((response){
      var jsonData = jsonDecode(response.body);
      setState(() {
        _dates = jsonData;
      });

    });

    // for(int i = 0; i < _dates.length; i++){
    //   if (selectedEvents[DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ",'en-US').parse(_dates[i]['date']+ ' 00:00:00.000Z')] != null) {
    //     selectedEvents[DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ",'en-US').parse(_dates[i]['date']+ ' 00:00:00.000Z')]?.add(
    //     // Event(_dates[i]['room']['time_start'].toString()),
    //     Event('event'),
    //     );
    //   }
    //   else {
    //     selectedEvents[DateFormat("yyyy-MM-dd HH:mm:ss.SSSZ",'en-US').parse(_dates[i]['date']+ ' 00:00:00.000Z')] = [
    //     // Event(_dates[i]['room']['time_start'].toString())
    //     Event('event')
    //     ];
    //   }
  
    // }

    for(int i = 0; i < _dates.length; i++){
      String date_date = _dates[i]['date'].toString();
      final splited =  date_date.split('-');
      // print(splited);
      int d = int.parse(splited[2]);
      int m = int.parse(splited[1]);
      int y = int.parse(splited[0]);
      // print(d);
      // print(m);
      // print(y);
      String title = _dates[i]['room']['time_start'].toString() + '-' +_dates[i]['room']['time_end'].toString() + '    P.' + _dates[i]['room']['class_room']['name'].toString() + '\n' +_dates[i]['room']['room_name'].toString();
      if (selectedEvents[DateTime.utc(y, m, d ,00, 00, 00)] != null) {
        selectedEvents[DateTime.utc(y, m, d ,00, 00, 00)]?.add(
        // Event(_dates[i]['room']['time_start'].toString()),
        Event(title),
        );
      }
      else {
        selectedEvents[DateTime.utc(y, m, d ,00, 00, 00)] = [
        // Event(_dates[i]['room']['time_start'].toString())
        Event(title)
        ];
      }

      //  selectedEvents[DateTime.utc(int.parse(DateFormat('yyyy').format(DateFormat("yyyy").parse(_dates[i]['date']))), int.parse(DateFormat('MM').format(DateFormat("MM").parse(_dates[i]['date']))), int.parse(DateFormat('dd').format(DateFormat("dd").parse(_dates[i]['date']))), 00, 00, 00)]?.add(
      //   // Event(_dates[i]['room']['time_start'].toString()),
      //   Event('event'),
      //   );

      // splited = [];
  
    }



    // int.parse((DateFormat("yyyy").parse(_dates[i]['date'])).toString());
    // int.parse((DateFormat("MM").parse(_dates[i]['date'])).toString());
    // int.parse((DateFormat("dd").parse(_dates[i]['date'])).toString());




    // selectedEvents[DateTime.utc(2023, 05, 08, 00, 00, 00)] = [
    //     Event('_eventController.text')
    //   ];
    // selectedEvents[_chosenDate]?.add(
    //     Event('_eventController.text'),
    //   );

      


  }

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
    loadDates();
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("ESTech Calendar"),
      //   centerTitle: true,
      // ),
      body: SingleChildScrollView(
      
      child:Column(
        children: [
          // Text(selectedEvents.toString(),style: TextStyle(fontSize: 25,)),
          // Text(_dates.toString(),style: TextStyle(fontSize: 25,)),
          TableCalendar(
            locale: "en_US",
            focusedDay: selectedDay,
            firstDay: DateTime(1990),
            lastDay: DateTime(2050),
            // calendarFormat: format,
            // onFormatChanged: (CalendarFormat _format) {
            //   setState(() {
            //     format = _format;
            //   });
            // },
            // startingDayOfWeek: StartingDayOfWeek.sunday,
            // daysOfWeekVisible: true,

            //Day Changed
            onDaySelected: (DateTime selectDay, DateTime focusDay) {
              setState(() {
                selectedDay = selectDay;
                focusedDay = focusDay;
              });
              print(focusedDay);
              // print(selectedDay);
            },
            selectedDayPredicate: (DateTime date) {
              return isSameDay(selectedDay, date);
            },

            eventLoader: _getEventsfromDay,

            //To style the Calendar
            // calendarStyle: CalendarStyle(
            //   isTodayHighlighted: true,
            //   selectedDecoration: BoxDecoration(
            //     color: Colors.blue,
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   selectedTextStyle: TextStyle(color: Colors.white),
            //   todayDecoration: BoxDecoration(
            //     color: Colors.purpleAccent,
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   defaultDecoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            //   weekendDecoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     borderRadius: BorderRadius.circular(5.0),
            //   ),
            // ),
            calendarBuilders: CalendarBuilders(
                            markerBuilder: (BuildContext context, date, events) {
                              if (events.isEmpty) return SizedBox();
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: events.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      margin: const EdgeInsets.only(top: 27),
                                      padding: const EdgeInsets.all(1),
                                      child: Container(
                                            // height: 7, // for vertical axis
                                            width: 8, // for horizontal axis
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Colors.orangeAccent),
                                          ),
                                      
                                    );
                                  });
                            },
                          ),
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              // formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(5.0),
              ),
              formatButtonTextStyle: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height:20),
          ..._getEventsfromDay(selectedDay).map(
            (Event event) =>
            Container(
              decoration: BoxDecoration(
                  // color: Colors.greenAccent.shade100,
                  border: Border.all(width: 1.8, color:Colors.orange),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: ListTile(
                  textColor: Colors.purple.shade900,
                  title: Text(
                    event.title,
                    style: TextStyle(fontSize: 19)

                  ),
                ),

            ),
            // ListTile(
            //   textColor: Colors.red,
            //   title: Text(
            //     event.title,
            //   ),
            // ),
          ),
        ],
      ),
    ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: () => showDialog(
      //     context: context,
      //     builder: (context) => AlertDialog(
      //       title: Text("Add Event"),
      //       content: TextFormField(
      //         controller: _eventController,
      //       ),
      //       actions: [
      //         TextButton(
      //           child: Text("Cancel"),
      //           onPressed: () => Navigator.pop(context),
      //         ),
      //         TextButton(
      //           child: Text("Ok"),
      //           onPressed: () {
      //             if (_eventController.text.isEmpty) {

      //             } else {
      //               if (selectedEvents[selectedDay] != null) {
      //                 selectedEvents[selectedDay]?.add(
      //                   Event(_eventController.text),
      //                 );
      //               }
      //               else {
      //                 selectedEvents[selectedDay] = [
      //                   Event(_eventController.text)
      //                 ];
      //               }

      //             }
      //             Navigator.pop(context);
      //             _eventController.clear();
      //             setState((){});
      //             return;
      //           },
      //         ),
      //       ],
      //     ),
      //   ),
      //   label: Text("Add Event"),
      //   icon: Icon(Icons.add),
      // ),

    );
  }
}