import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/signup/signup_page.dart';
// import 'Page/home.dart';
import 'login/login_page.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),//MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


