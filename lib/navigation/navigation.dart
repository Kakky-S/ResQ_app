import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class  Navigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            TextButton(
              child: Text('お気に入り'),
              onPressed: (){

              }
              )
          ],
        ),
    );
  }
}
