import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // バリデーション
  // todo 両方とも入力されているかを確認
  // todo 送信を押したらページ移動と入力をクリアにする
  Future signUp() async{
    if (mail.isEmpty){
      throw('メールアドレスを入力してください');
    }

    if (password.isEmpty){
      throw('パスワードを入力してください');
    }

    final User user = (await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password
    )).user;
    final email = user.email;
    FirebaseFirestore.instance.collection('users').add(
        {
          'email': email,
          'createdAt': Timestamp.now()
        }
        );
  }
}

// todo 両方とも入力されているかを確認
// todo 送信を押したらページ移動と入力をクリアにする