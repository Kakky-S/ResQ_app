
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'chatBot.dart';

class chatBot extends StatefulWidget{
  @override
  _ChatBotState createState() =>  _ChatBotState();
}

class _ChatBotState extends State<chatBot> {
  List<Data> dataList = [];
  List<Data> chatArea = [];

  // void setKey() {
  //   setState(() {
  //     _key = 'init';
  //   });
  // }
  // メモの取得
  Future<void> getData(key) async{
    // dataList.add(Data(
    //   content: '今日は、どうしましたか'
    // ));
    // todo 'test'のところにボタンをプッシュした際にnextIdが入るようにする
    var snapshot = await FirebaseFirestore.instance.collection('testdata').doc(key).get();
    var docs = snapshot.data()['answer'];

    if(dataList.length >= 0){
      dataList.clear();
    }

    docs.forEach((docs) {
      //var answer = docs.data()['answer'];
      dataList.add(Data(
        // content: docs['content'], //answer[0]['content'],
        content: docs['content'],
        nextId: docs['nextId']  //answer[0]['nextId'],
      ));
      // chatArea.add(Data(
      //   // content: docs['content'], //answer[0]['content'],
      //     nextId: docs['nextId']  //answer[0]['nextId'],
      // ));
    });
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    getData('test');
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
      body: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
              (context, index){
                return
                  ListTile(
                    title: Text(dataList[index].content),
                   );
              },
                childCount: dataList.length,
          ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index){
                return
                  ElevatedButton(

                    onPressed: () => {
                      getData(dataList[index].nextId)
                    },
                    child: Text(dataList[index].nextId),
                  );
              },
              childCount: dataList.length,
            ),
          ),
        ],
      )
      // ListView.builder(
      //         itemCount: dataList.length,
      //         itemBuilder: (context,index){
      //           return
      //           //   ListTile(
      //           //   title: Text(dataList[index].content),
      //           // );
      //           ElevatedButton(
      //               onPressed: () => {
      //                 getData(dataList[index].nextId)
      //               },
      //               child: Text(dataList[index].nextId),
      //           );
      //         },
      //       ),
    );
  }
}


