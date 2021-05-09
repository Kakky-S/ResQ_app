import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_chatbot_app/chatBot/chatBot_page.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favorite/favorite_page.dart';
import 'package:resq_chatbot_app/historyList/historyList_page.dart';
import 'package:resq_chatbot_app/signup/signup_page.dart';
import 'login_model.dart';


class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        body: Consumer<LoginModel>(
            builder: (context, model, child){
              return Padding(
                    padding: const EdgeInsets.only(top: 120, right: 20, left: 20 ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset('images/logo_main.png' ),
                       TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'メールアドレス',
                            ),
                            controller: mailController,
                            onChanged: (text){
                              model.mail = text;
                            },
                          ),
                        Padding(
                          padding: const EdgeInsets.only(top:25.0,bottom:30.0),
                          child: TextField(
                            decoration: const InputDecoration(
                                //hintText: 'password',
                                border: OutlineInputBorder(),
                                labelText: 'パスワード',
                            ),
                            // 文字を隠す
                            obscureText: true,
                            controller: passwordController,
                            onChanged: (text){
                              model.password = text;
                            },
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(bottom:10.0),
                        child: OutlinedButton(
                          child: Text('診察をはじめる'),
                          style: OutlinedButton.styleFrom(
                            primary: HexColor('555555'),
                            backgroundColor: HexColor('FFFFFF'),
                            side: const BorderSide(
                                color: Colors.orange
                            ),
                            minimumSize: Size(300, 50),
                            textStyle: TextStyle(
                                fontSize: 18
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async{
                            try {
                              await model.login();
                              _showDialog(context, 'ログインしました');
                              Navigator.push(context, MaterialPageRoute(builder: (context) => chatBot()));
                            } catch(e){
                              _showDialog(context, e.toString());
                            }
                            await model.login();
                          },
                        ),
                      ),
                        OutlinedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                            },
                            child: Text('アカウントを作成する'),

                          style: OutlinedButton.styleFrom(
                            primary: HexColor('555555'),
                            backgroundColor: HexColor('FFFFFF'),
                            side: const BorderSide(
                                color: Colors.lightBlueAccent
                            ),
                            minimumSize: Size(300, 50),
                            textStyle: TextStyle(
                                fontSize: 18
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => chatBot()));
                            },
                            child: Text('診察を始める')
                        ),

                      ],
                    ),
              );
            }
        ),
      ),
    );
  }
}

Future _showDialog(
    BuildContext context,
    String title,
    ){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.of(context).pop();
                },
                child: Text('OK'))
          ],
        );
      }
  );
}