import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/favoriteSymptom/favoriteSymptom.dart';

class FavoriteSymptom extends StatefulWidget{
  final String paramText;
  FavoriteSymptom({Key key, this.paramText}) : super(key: key);

  @override
  _FavoriteSymptom createState() =>  _FavoriteSymptom();
}

class _FavoriteSymptom extends State<FavoriteSymptom> {
  List<favoriteSymptomData> symptomList = [];
  List<favoriteSymptomData> setlist =[];
  List<favoriteSymptomData> textList = [];
  List<favoriteSymptomData> multipleList = [];

  Future<void> page() async{
    var snapshots = await FirebaseFirestore.instance.collection('symptom').doc(widget.paramText).get();
    var data = snapshots.data()['test3']['ssss'];
    var title = snapshots.data()['test2'];
    var multiple = snapshots.data()['test4'];

    // タイトルを取得
    title.forEach((docs){
      setlist.add(favoriteSymptomData(
        title:  docs['test'],//doc.data()['test']
        //title: doc['test']
      ));
    });

    // リストを取得
    data.forEach((doc){
      symptomList.add(favoriteSymptomData(
        list: doc,
      ));
    });

    // 複数行を取得
    multiple.forEach((doc){
      multipleList.add(favoriteSymptomData(
        multiple: doc,
      ));
    });

    setState(() {});
    print(setlist[0]);
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

    );
  }
}
