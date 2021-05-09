import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology_page.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favorite/favorite_page.dart';
import 'package:resq_chatbot_app/historyList/historyList_page.dart';
import 'package:resq_chatbot_app/navigation/navigation.dart';
import 'chatBot.dart';

class chatBot extends StatefulWidget{
  @override
  _ChatBotState createState() =>  _ChatBotState();
}

class _ChatBotState extends State<chatBot> {
  List<Data> dataList = [];
  List<String> chatArea = ['今日は、どうしましたか？'];


  void setKey(_key, key) {
      
    chatArea.add(_key);
      // 症状ページに遷移
      switch(key) {
        case 'kosi':
          addSymptom(key);
          chatArea.clear();
          // 症状ページに遷移する際に値を受け渡し
          Navigator.push(context, MaterialPageRoute(builder: (context) => Symptom(paramText: key)));
          break;

          default:
          getData(key);
          break;
      }

      // if(key == 'kosi'){
      //   chatArea.clear();
      //   // 症状ページに遷移する際に値を受け渡し
      //   Navigator.push(context, MaterialPageRoute(builder: (context) => Symptom(paramText: key)));
      // }
      // // データ取得の関数
      // getData(key);
  }

  // お気に入りに追加する処理
  Future<void> addSymptom(key) async {
    var collection = FirebaseFirestore.instance.collection('test');
    await collection.add({
      'created_date': Timestamp.now(),
      'text': chatArea,
      'title': key
    });
  }


  // メモの取得
  Future<void> getData(key) async{

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
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20 ),
          child: ListView(
            children: [
             Padding(
               padding: const EdgeInsets.only(bottom: 50,),
               child:  ListTile(
                 leading: Icon(
                   Icons.chat,
                   color: HexColor('FBC52C'),
                 ),
                 title: Text(
                     '診察',
                 style: TextStyle(
                   fontSize: 23,
                 ),
                   ),

                 onTap: (){
                   Navigator.push(context, MaterialPageRoute(builder: (context) => chatBot()));
                 },
               ),
             ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50,),
              child: ListTile(
                leading: Icon(
                  Icons.favorite,
                  color: HexColor('FBC52C'),
                ),
                title: Text(
                    'お気に入り',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Favorite()));
                },
              ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50,),
              child: ListTile(
                leading: Icon(
                  Icons.create,
                  color: HexColor('FBC52C'),
                ),
                title: Text(
                    '診察履歴',
                  style: TextStyle(
                    fontSize: 23,
                  ),
                ),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryList()));
                },
              ),
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 40, right: 20, left: 20),
        child: CustomScrollView(
        slivers: [
          SliverList(
              delegate: SliverChildBuilderDelegate(
              (context, index){
                return  Container(
                  child: (index % 2 == 0) ?
                  Padding(
                      padding: const EdgeInsets.only(bottom: 25 ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Image.asset('images/docter.png', width: 50),
                      ),
                      Padding(padding: const EdgeInsets.only(left: 10 )),
                      Container(
                        child: Text(
                            chatArea[index],
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  )
                  // ListTile(
                  //   leading: Image.asset('images/logo_main.png', width: 30),
                  //   title: Text(chatArea[index]),
                  //  )
                )
                  :
                  Padding(
                    padding: const EdgeInsets.only(bottom: 25 ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            child: Text(
                                chatArea[index],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(padding: const EdgeInsets.only(right: 10 )),
                          Container(
                            child: Image.asset('images/patient.png', width: 50),
                          ),
                        ],
                      )
                  //   child: ListTile(
                  //   trailing: Icon(
                  //     Icons.chat,
                  //     color: Colors.pinkAccent,
                  //   ),
                  //   title: Text(chatArea[index]),
                  // ),
                )
                );
              },
                childCount: chatArea.length,
          ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index){
                return
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                child: OutlinedButton(
                    child: Text(
                        dataList[index].content,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    onPressed: () => {
                      setKey(dataList[index].question,dataList[index].nextId),
                      //getData(dataList[index].nextId),
                    },
                  style: OutlinedButton.styleFrom(
                    primary: HexColor('555555'),
                    backgroundColor: HexColor('FFFFFF'),
                    side: const BorderSide(
                        color: Colors.lightBlueAccent
                    ),
                    minimumSize: Size(300, 50),
                    textStyle: TextStyle(
                        fontSize: 18
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  ),
                  );
              },
              childCount: dataList.length,
            ),
          ),
        ],
      ),
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
  

