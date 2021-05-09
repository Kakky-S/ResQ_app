import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/signup/signup_model.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mailController = TextEditingController();
    final passwordController = TextEditingController();

    return ChangeNotifierProvider<SignUpModel>(
      create: (_) => SignUpModel(),
      child: Scaffold(
        appBar: AppBar(

        ),
        body: Consumer<SignUpModel>(
          builder: (context, model, child){
            return Padding(
                padding: const EdgeInsets.only(top: 90.0, right: 20, left: 20),
              child: Column(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                    child: Text(
                        '新規アカウントを作成',
                         style: TextStyle(
                           fontSize: 25,
                         )
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40.0),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'メールアドレス',
                    ),
                    controller: mailController,
                    onChanged: (text){
                      model.mail = text;
                    },
                  ),
                  ),
                  Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: TextField(
                    decoration: InputDecoration(
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
                  OutlinedButton(
                    child: Text('登録する'),
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
                        await model.signUp();
                        _showDialog(context, '登録を完了しました');
                      } catch(e){
                        _showDialog(context, e.toString());
                      }
                      await model.signUp();
                      },
                  )
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