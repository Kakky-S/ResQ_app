
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatBot.dart';

class chatBot extends StatefulWidget{
  @override
  _ChatBotState createState() =>  _ChatBotState();
}

class _ChatBotState extends State<chatBot> {
  List<Data> dataList = [];

  // メモの取得
  Future<void> getData() async{
    var snapshot = await FirebaseFirestore.instance.collection('testdata').get();
    var docs = snapshot.docs;

    docs.forEach((docs) {
      var answer = docs.data()['answer'];
      dataList.add(Data(
        content: answer[0]['content'],
        nextId: answer[0]['nextId'],
      ));
    });
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('chatbot'),
      ),
      // endDrawer: Drawer(
      //   child: Center(
      //     child: Text('Drawer'),
      //   ),
      // ),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(dataList[index].content),
          );
        },
      ),
    );
  }
}


