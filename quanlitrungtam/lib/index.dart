import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

class IndexScreen extends StatefulWidget{
  const IndexScreen({Key? key}) : super(key: key);

  @override
  State<IndexScreen> createState() => _IndexScreenState();
}

class _IndexScreenState extends State<IndexScreen>{
  // @override
  // Widget build(BuildContext context){
  //   return Scaffold(
  //     backgroundColor: Colors.blue,
  //   );
  // }
  String _email = '';
  String _password = '';
  String _type = '1';

  loginPressed() async{
    goToHomePage();
  }

  goToHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
          const MyHomePage(title: 'Quản lý đưa đón học sinh')),
    );
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
              Text('Đây là trang Index nè'),
            ]
          )
        ),
    );
  }
}