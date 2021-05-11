// 診察を行うチャットのページ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology_page.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favorite/favorite_page.dart';
import 'package:resq_chatbot_app/historyList/historyList_page.dart';
import 'chatBot.dart';

class chatBot extends StatefulWidget{
  @override
  _ChatBotState createState() =>  _ChatBotState();
}

class _ChatBotState extends State<chatBot> {
  // 回答ボタン用のList
  List<Data> dataList = [];
  //　質問と答えのList
  List<String> chatArea = ['今日は、どうしましたか？'];


  void setKey(_key, key, question) {

    chatArea.add(_key);
    chatArea.add(question);
      // 症状ページに遷移
      switch(key) {
        case 'answerWhiplash':
          addSymptom(question);
          chatArea.clear();
          // 症状ページに遷移する際に値を受け渡し
          Navigator.push(context, MaterialPageRoute(builder: (context) => Symptom(paramText: key)));
          break;

          default:
          getData(key);
          break;
      }

  }

  // お気に入りに追加する処理
  Future<void> addSymptom(key) async {
    var collection = FirebaseFirestore.instance.collection('test');
    await collection.add({
      'created_date': Timestamp.now(),
      'text': chatArea,
      'title': ('診断名 : ''${key}')
    });
  }


  // メモの取得
  Future<void> getData(key) async{

    var snapshot = await FirebaseFirestore.instance.collection('medical_consultation').doc(key).get();
    var docs = snapshot.data()['answers'];

    if(dataList.length >= 0){
      dataList.clear();
    }

    // データを配列に格納
    docs.forEach((docs) {
      dataList.add(Data(
        content: docs['content'],
        nextId: docs['nextId'],
        question: docs['question'],
      ));
    });
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    getData('init');
  }

  void chat(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('診察中'),
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
                     '診察を始める',
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
       body:Column(
        children: [
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 450.0,
            ),
            child: Container(
              color: HexColor('EDF5FF'),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40, left: 20, right: 20),

            // 質問と回答表示エリア
            child: ListView.builder(
                itemCount: chatArea.length,
                itemBuilder: (context, index){
                  return (
                      (index % 2 == 0) ?
                          // 質問を左から表示
                          Padding(padding: const EdgeInsets.only(bottom: 25 ),
                            child:
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Image.asset('images/docter.png', width: 50),
                                ),
                                  Padding(padding: const EdgeInsets.only(left: 10 )),
                                 Container(
                                   width: 300,
                                    child: Text(
                                      chatArea[index],
                                      style: TextStyle(
                                        fontSize: 16
                                      )
                                    ),
                                 )
                              ],
                            )
                          )
                      :
                      // 回答を右から表示
                      Padding(padding: const EdgeInsets.only(bottom: 25 ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            Container(
                              child: Text(
                                  chatArea[index],
                                  style: TextStyle(
                                      fontSize: 16
                                  )
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(right: 10 )),
                            Container(
                              child: Image.asset('images/patient.png', width: 50),
                            )
                          ],
                        ),
                      )
                  );
                }),
                ),
          ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300.0,
            ),

            // 回答ボタンエリア
            child: ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: dataList.length,
                itemBuilder: (context, index){
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
                          setKey(dataList[index].content,dataList[index].nextId,dataList[index].question),
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
                }),
          )
          ),
        ],
       ),
    );
  }
}
  

