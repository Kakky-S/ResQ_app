import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology_page.dart';
import 'chatBot.dart';

class chatBot extends StatefulWidget{
  @override
  _ChatBotState createState() =>  _ChatBotState();
}

class _ChatBotState extends State<chatBot> {
  List<Data> dataList = [];
  List<String> chatArea = [];

  void setKey(_key, key) {
      chatArea.add(_key);
      // 症状ページに遷移
      if(key == 'kosi'){
        chatArea.clear();
        // 症状ページに遷移する際に値を受け渡し
        Navigator.push(context, MaterialPageRoute(builder: (context) => Symptom(paramText: key)));

      }
      // データ取得の関数
      getData(key);
  }

  // メモの取得
  Future<void> getData(key) async{
    // chatArea.add(Data(
    //   content: '今日は、どうしましたか'
    // ));
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
        nextId: docs['nextId'],
        question: docs['nextQuestion'],
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

  void chat(){

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

                    title: Text(chatArea[index]),
                   );
              },
                childCount: chatArea.length,
          ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index){
                return
                  ElevatedButton(
                    child: Text(dataList[index].content),
                    onPressed: () => {
                      setKey(dataList[index].question,dataList[index].nextId),
                      //getData(dataList[index].nextId),

                    },
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


