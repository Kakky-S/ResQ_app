// お気に入りリストに関するページ
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/chatBot/chatBot_page.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favoriteSymptom/favoriteSymptom_page.dart';
import 'package:resq_chatbot_app/historyList/historyList_page.dart';

class Favorite extends StatefulWidget {
  Favorite({Key key}) : super(key: key);

  @override
  _Favorite createState() => _Favorite();
}

class _Favorite extends State<Favorite> {
  CollectionReference favorite;

  @override
  void initState() {
    super.initState();
    favorite = FirebaseFirestore.instance.collection('mylist');
  }

  // 削除機能
  Future<void> deleteFavorite(String docId) async {
    var document = FirebaseFirestore.instance.collection('mylist').doc(docId);
    document.delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('お気に入り'),
      ),
      endDrawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, right: 20, left: 20),
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50,),
                child: ListTile(
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

                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => chatBot()));
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Favorite()));
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
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => HistoryList()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: favorite.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 20, left: 20, right: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(color: HexColor('FBC52C'))
                          )
                      ),
                      child: ListTile(
                        title: Text(snapshot.data.docs[index].data()['title']),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: HexColor('6BB8FF'),
                          ),
                          onPressed: () async {
                            var result = await showDialog<int>(
                                context: context,
                                barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('本当に削除しますか？'),
                                    content: Text('一度削除すると戻すことができません。'),
                                    actions: [
                                      TextButton(
                                          child: Text('はい'),
                                          onPressed: () async {
                                            await deleteFavorite(
                                                snapshot.data.docs[index].id);
                                            Navigator.pop(context);
                                          }
                                      ),
                                      TextButton(
                                          child: Text('いいえ'),
                                          onPressed: () =>
                                              Navigator.pop(context)
                                      )
                                    ],
                                  );
                                }
                            );
                          },
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  FavoriteSymptom(
                                      paramText: snapshot.data.docs[index]
                                          .data()['key'])));
                        },
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }

}
