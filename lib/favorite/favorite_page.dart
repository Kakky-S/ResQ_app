import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology_page.dart';
import 'package:resq_chatbot_app/favorite/favorite.dart';

class Favorite extends StatefulWidget{
  Favorite({Key key}) : super(key: key);

  @override
  _Favorite createState() =>  _Favorite();
}

class _Favorite extends State<Favorite> {
  List<favorites> favoriteList = [];

  Future<void> page() async{
    var snapshots = await FirebaseFirestore.instance.collection('mylist').get();
    var docs = snapshots.docs;

    // タイトルを取得
    docs.forEach((doc){
      favoriteList.add(favorites(
        title: doc.data()['title'],
        key: doc.data()['key'],
        //createdTime: doc.data()['created_date']
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
       title: Text('お気に入り'),
     ),
     body: ListView.builder(
         itemCount: favoriteList.length,
         itemBuilder: (context, index){
           return ListTile(
             title: Text(favoriteList[index].title),
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context) => Symptom(paramText: favoriteList[index].key)));
             },
           );
         }
     ),
   );

  }

  }
