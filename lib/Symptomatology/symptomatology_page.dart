import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology.dart';

class Symptom extends StatefulWidget{
  final String paramText;
  Symptom({Key key, this.paramText}) : super(key: key);

  @override
  _Symptom createState() =>  _Symptom();
}

class _Symptom extends State<Symptom> {
 List<SymptomData> symptomList = [];
 List<SymptomData> setlist =[];
 List<SymptomData> textList = [];
 List<SymptomData> multipleList = [];

   // final String paramText;
   // Symptomatology({Key key, @required this.paramText}) : super(key: key);

   // final Data data;
  // Symptomatology(this.data);

   Future<void> page() async{
     var snapshots = await FirebaseFirestore.instance.collection('symptom').doc(widget.paramText).get();
     //var data = snapshots.data()['array'];
      var data = snapshots.data()['test3']['ssss'];
     //var list = data['test3']['ssss'];
     // var list = data['test3'];
     var title = snapshots.data()['test2'];
     var multiple = snapshots.data()['test4'];

     // docs.forEach((docs) {
     //   //var answer = docs.data()['answer'];
     //   dataList.add(Data(
     //     // content: docs['content'], //answer[0]['content'],
     //     content: docs['content'],
     //     nextId: docs['nextId'],
     //     question: docs['nextQuestion'],
     //   ));

     // タイトルを取得
     title.forEach((docs){
       setlist.add(SymptomData(
         title:  docs['test'],//doc.data()['test']
         //title: doc['test']
       ));
     });
     // リストを取得
     data.forEach((doc){
       symptomList.add(SymptomData(
         list: doc,//doc.data()['test']
       ));
     });

     // 複数行を取得
     multiple.forEach((doc){
       multipleList.add(SymptomData(
         multiple: doc,//doc.data()['test']
       ));
     });

     //textList = [...setlist, ...symptomList];
     //new List.from(setlist)..addAll(symptomList);
     setState(() {});
     print(setlist[0]);
   }

 @override
 void initState(){
   super.initState();
   page();
 }

 // お気に入りに追加する処理
 Future<void> addSymptom() async{
     var snapshots = await FirebaseFirestore.instance.collection('symptom').doc(widget.paramText).get();
     var title = snapshots.data()['test'];
     var collection =FirebaseFirestore.instance.collection('mylist');
     await collection.add({
        'title': title,
        'key': widget.paramText,
        'created_date': Timestamp.now()
     });
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text(widget.paramText),
    ),
     body: CustomScrollView(
         slivers: [
         SliverList(
         delegate: SliverChildBuilderDelegate(
         (context, index){
    return
    ListTile(
    title: Text(setlist[index].title),
    );
    },
      childCount: setlist.length,
    ),
    ),
           SliverList(
             delegate: SliverChildBuilderDelegate(
                   (context, index){
                 return
                   ListTile(

                     title: Text(symptomList[index].list),
                   );
               },
               childCount: symptomList.length,
             ),
           ),

           SliverList(
             delegate: SliverChildBuilderDelegate(
                   (context, index){
                 return
                   ListTile(

                     title: Text(multipleList[index].multiple),
                   );
               },
               childCount: multipleList.length,
             ),
           ),
    ]
    ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
            addSymptom();
        },
        tooltip: 'Increment',
        child: Icon(Icons.favorite),
      ),
    //  ListView.builder(
    //   itemCount: symptomList.length,
    //   itemBuilder: (context,index) {
    //     return Column(
    //        children: [
    //          Text('こんにちは'),
    //          //Text(textList[index].title),
    //          //Text(textList[index].text)
    //          Text(symptomList[index].text)
    //        ],
    //     );
    //   }
    // ),
    );
  }
}
