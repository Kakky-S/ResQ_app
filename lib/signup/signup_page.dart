import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          title: Text('サインアップ'),
        ),
        body: Consumer<SignUpModel>(
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
                    child: Text('登録する'),
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