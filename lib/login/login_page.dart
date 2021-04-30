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
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'e-mail'
                      ),
                      controller: mailController,
                      onChanged: (text){
                        model.mail = text;
                      },
                    ),
                    TextField(
                      decoration: InputDecoration(
                          hintText: 'password'
                      ),
                      // 文字を隠す
                      obscureText: true,
                      controller: passwordController,
                      onChanged: (text){
                        model.password = text;
                      },
                    ),
                    ElevatedButton(
                      child: Text('ログインする'),
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