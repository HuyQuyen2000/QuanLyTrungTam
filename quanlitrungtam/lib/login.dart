import 'package:flutter/material.dart';
import 'package:quanlitrungtam/main.dart';
import 'package:flutter/src/painting/borders.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
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
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Login',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 80,
              ),
              Text('ĐĂNG NHẬP QUẢN TRỊ VIÊN', style: TextStyle(fontSize: 40), textAlign: TextAlign.center,),
              const SizedBox(
                height: 80,
              ),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Nhập email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none),
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  filled: true,
                ),
                onChanged: (value) {
                  _email = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Nhập password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40),
                      borderSide: BorderSide.none),
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  filled: true,
                ),
                onChanged: (value) {
                  _password = value;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                child: Text('ĐĂNG NHẬP', style: TextStyle(fontSize: 20)),
                textColor: Colors.white,
                color: Colors.lightBlue,
                hoverColor: Colors.lightBlue.shade200,
                shape: StadiumBorder(),
                minWidth: 200,
                height: 60,
                onPressed: () => loginPressed(),
              )
            ],
          ),
        ))
    );
  }
}