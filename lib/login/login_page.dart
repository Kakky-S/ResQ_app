import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_chatbot_app/chatBot/chatBot_page.dart';
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
        appBar: AppBar(
          title: Text('ログイン'),
        ),
        body: Consumer<LoginModel>(
            builder: (context, model, child){
              return Center(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.lightBlueAccent.withOpacity(0.1),
                        spreadRadius: 1.0,
                        blurRadius: 10.0,
                        offset: Offset(10, 10),
                      ),
                    ],
                    /* ここまでを追加しました */
                  ),
                  //color: Colors.black12.withOpacity(0.1),
                  width: 400,

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:50.0),
                          child: TextField(
                            decoration: InputDecoration(
                                //hintText: 'e-mail',
                              border: OutlineInputBorder(),
                              labelText: 'e-mail',
                            ),
                            controller: mailController,
                            onChanged: (text){
                              model.mail = text;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:30.0,bottom:30.0),
                          child: TextField(
                            decoration: const InputDecoration(
                                //hintText: 'password',
                                border: OutlineInputBorder(),
                                labelText: 'password',
                            ),
                            // 文字を隠す
                            obscureText: true,
                            controller: passwordController,
                            onChanged: (text){
                              model.password = text;
                            },
                          ),
                        ),
                        ElevatedButton(
                          child: Text('ログインする'),
                          style: ElevatedButton.styleFrom(
                              primary: Colors.orange,
                              onPrimary: Colors.white,
                              shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                              ),
                          onPressed: () async{
                            try {
                              await model.login();
                              _showDialog(context, 'ログインしました');
                            } catch(e){
                              _showDialog(context, e.toString());
                            }
                            await model.login();
                          },
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                            },
                            child: Text('新規登録')
                        ),
                        ElevatedButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => chatBot()));
                            },
                            child: Text('診察を始める')
                        ),
                      ],
                    ),
                  ),
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