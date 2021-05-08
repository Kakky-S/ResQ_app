import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/favorite/favorite.dart';
import 'package:resq_chatbot_app/favoriteSymptom/favoriteSymptom_page.dart';

class Favorite extends StatefulWidget{
  Favorite({Key key}) : super(key: key);

  @override
  _Favorite createState() =>  _Favorite();
}

class _Favorite extends State<Favorite> {
  CollectionReference favorite;
  //List<favorites> favoriteList = [];
  //
  // Future<void> page() async{
  //   var snapshots = await FirebaseFirestore.instance.collection('mylist').get();
  //   var docs = snapshots.docs;
  //
  //   // タイトルを取得
  //   docs.forEach((doc){
  //     favoriteList.add(favorites(
  //       title: doc.data()['title'],
  //       key: doc.data()['key'],
  //       //createdTime: doc.data()['created_date']
  //     ));
  //   });
  //   setState(() {});
  //
  // }

  @override
  void initState(){
    super.initState();
    favorite = FirebaseFirestore.instance.collection('mylist');
  }

  // 削除機能
  Future<void> deleteFavorite(String docId) async{
    var document = FirebaseFirestore.instance.collection('mylist').doc(docId);
    document.delete();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       title: Text('お気に入り'),
     ),
     body: StreamBuilder<QuerySnapshot>(
         stream: favorite.snapshots(),
         builder: (context, snapshot){
           if(snapshot.connectionState == ConnectionState.waiting) {
             return CircularProgressIndicator();
           }
           return ListView.builder(
               itemCount: snapshot.data.docs.length,
               itemBuilder: (context, index){
                 return ListTile(
                   title: Text(snapshot.data.docs[index].data()['title']),
                   trailing: IconButton(
                     icon: Icon(
                         Icons.delete,
                       color: Colors.grey,
                     ),
                     onPressed: () async {
                       var result = await showDialog<int>(
                           context: context,
                           barrierDismissible: false,
                           builder: (BuildContext context){
                             return AlertDialog(
                               title: Text('本当に削除しますか？'),
                               content: Text('確認のダイアログです。'),
                               actions: [
                                 TextButton(
                                     child: Text('OK'),
                                     onPressed: () async{
                                       await deleteFavorite(snapshot.data.docs[index].id);
                                       Navigator.pop(context);
                                     }
                                 ),
                                 TextButton(
                                     child: Text('Cancel'),
                                     onPressed: () => Navigator.pop(context)
                                 )
                               ],
                             );
                           }
                       );
                       //deleteFavorite(favoriteList[index].id);
                     },
                   ),
                   onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteSymptom(paramText: snapshot.data.docs[index].data()['key'])));
                   },
                 );
               }
           );
         }

     ),
   );

  }

  }
