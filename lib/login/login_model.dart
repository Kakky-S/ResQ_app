import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginModel extends ChangeNotifier {
  String mail = '';
  String password = '';

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // バリデーション
  // todo 両方とも入力されているかを確認
  // todo 送信を押したらページ移動と入力をクリアにする
  Future login() async {
    if (mail.isEmpty) {
      throw('メールアドレスを入力してください');
    }

    if (password.isEmpty) {
      throw('パスワードを入力してください');
    }

    final result = await _auth.signInWithEmailAndPassword(
        email: mail,
        password: password
    );
    final uid = result.user.uid;
  }
}