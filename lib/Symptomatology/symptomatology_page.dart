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

   // final String paramText;
   // Symptomatology({Key key, @required this.paramText}) : super(key: key);

   // final Data data;
  // Symptomatology(this.data);

   Future<void> page() async{
     var snapshot = await FirebaseFirestore.instance.collection('symptom').doc(widget.paramText).get();
     var docs = snapshot.data()['kosi'];
     // docs.forEach((docs) {
     //   //var answer = docs.data()['answer'];
     //   dataList.add(Data(
     //     // content: docs['content'], //answer[0]['content'],
     //     content: docs['content'],
     //     nextId: docs['nextId'],
     //     question: docs['nextQuestion'],
     //   ));
     //symptomatologyList.add(docs);

     docs.forEach((doc){
       symptomList.add(SymptomData(
         title:  doc['test2']//doc.data()['test']
       ));
     });
     setState(() {});
     print(symptomList);
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
        title: Text(widget.paramText),
    ),
     body: ListView.builder(
      itemCount: symptomList.length,
      itemBuilder: (context,index) {
        return ListTile(
          title: Text(symptomList[index].title),
        );
      }
    )
    );
  }
}
