import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/favoriteSymptom/favoriteSymptom.dart';
import 'package:resq_chatbot_app/history/history.dart';

class History extends StatefulWidget{
  final String paramText;
  History({Key key, this.paramText}) : super(key: key);

  @override
  _History createState() =>  _History();
}

class _History extends State<History> {
  List<histories> historyList = [];

  Future<void> page() async{
    var snapshots = await FirebaseFirestore.instance.collection('test').doc(widget.paramText).get();
    var multiple = snapshots.data()['text'];


    // 複数行を取得
    multiple.forEach((doc){
      historyList.add(histories(
        history: doc,
      ));
    });
    setState(() {});
  }

  @override
  void initState(){
    super.initState();
    page();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('診察履歴'),
      ),

      body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index){
                  return
                  Padding(
                      padding: const EdgeInsets.only(top: 20, right: 20, left: 20 ),
                  child: Container(
                    child: (index % 2 == 0) ?
                    Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.grey)
                          )
                        ),
                    child: ListTile(
                      leading: Text(
                          'Q.',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 20,
                        ),
                      ),
                      title: Text(historyList[index].history),

                    )
                      )
                    :
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: Colors.grey)
                          )
                      ),
                      child:
                    ListTile(
                      leading: Text(
                        'A.',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                      title: Text(historyList[index].history),
                    )
                    )
                      ),
                      );
                },
                childCount: historyList.length,
              ),
            ),
          ]
      ),

    );
  }
}
