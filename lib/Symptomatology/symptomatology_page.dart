import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/Symptomatology/symptomatology.dart';
import 'package:resq_chatbot_app/chatBot/chatBot_page.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favorite/favorite_page.dart';
import 'package:resq_chatbot_app/historyList/historyList_page.dart';

class Symptom extends StatefulWidget {
  final String paramText;

  Symptom({Key key, this.paramText}) : super(key: key);

  @override
  _Symptom createState() => _Symptom();
}

class _Symptom extends State<Symptom> {
  List<SymptomData> causeList = [];
  List<SymptomData> symptomList = [];
  List<SymptomData> treatmentList = [];
  List<SymptomData> setlist = [];
  List<SymptomData> textList = [];
  List<SymptomData> featureList = [];
  List<SymptomData> whereList = [];
  var bool = false;

  Future<void> page() async {
    var snapshots = await FirebaseFirestore.instance.collection('symptom').doc(
        widget.paramText).get();
    var cause = snapshots.data()['cause']['list'];
    var symptom = snapshots.data()['symptom']['list'];
    var treatment = snapshots.data()['treatment']['list'];
    var title = snapshots.data()['subTitle'];
    var feature = snapshots.data()['feature'];
    var where = snapshots.data()['where'];

    // タイトルを取得
    title.forEach((docs) {
      setlist.add(SymptomData(
        title: docs['title'], //doc.data()['test']
        //title: doc['test']
      ));
    });

    // 原因を取得
    cause.forEach((doc) {
      causeList.add(SymptomData(
        list: doc,
      ));
    });
    // 症状を取得
    symptom.forEach((doc) {
      symptomList.add(SymptomData(
        list: doc,
      ));
    });
    // 治療方法を取得
    treatment.forEach((doc) {
      treatmentList.add(SymptomData(
        list: doc,
      ));
    });

    // 症状の特徴を取得
    feature.forEach((doc) {
      featureList.add(SymptomData(
        multiple: doc,
      ));
    });

    // どこに行くべきかを取得
    where.forEach((doc) {
      whereList.add(SymptomData(
        multiple: doc,
      ));
    });

    setState(() {});
    print(setlist[0]);
  }

  // お気に入りに追加する処理
  Future<void> addSymptom() async {
    var snapshots = await FirebaseFirestore.instance.collection('symptom').doc(
        widget.paramText).get();
    var title = snapshots.data()['title'];
    var collection = FirebaseFirestore.instance.collection('mylist');
    await collection.add({
      'title': title,
      'key': widget.paramText,
      'created_date': Timestamp.now()
    });
  }

  @override
  void initState() {
    super.initState();
    page();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paramText),
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
      body:
      Padding(
        padding: const EdgeInsets.only(bottom: 80),
        child: CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Container(
                        child: Column(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 60)),
                            Text(
                              '最も疑わしい症状',
                              style: TextStyle(
                                fontSize: 22,
                              ),
                            ),
                            Padding(padding: const EdgeInsets.only(top: 15)),
                            Text(
                              setlist[index].title,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      );
                  },
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          top: 60, left: 20, right: 20, bottom: 30),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: HexColor('FBC52C')),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.only(
                                top: 50, right: 20)),
                            Text(
                              'どこに行くべき？',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 40, right: 40, bottom: 15),
                      child: Wrap(
                        children: [
                          Text(
                            whereList[index].multiple,
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.8
                            ),
                          )
                        ],
                      ),
                    );


                    // ListTile(
                    //   title: Text(multipleList[index].multiple),
                    // );
                  },
                  childCount: whereList.length,
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 40, left: 20, right: 20, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor('FBC52C')),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(padding: const EdgeInsets.only(
                                  top: 50, right: 20)),
                              Text(
                                '症状の特徴',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                  childCount: 1,
                ),
              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: Wrap(
                        children: [
                          Text(
                            featureList[index].multiple,
                            maxLines: null,
                            style: TextStyle(
                                fontSize: 16,
                                height: 1.8
                            ),
                          )
                        ],
                      ),
                    );


                    // ListTile(
                    //   title: Text(multipleList[index].multiple),
                    // );
                  },
                  childCount: featureList.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 20, right: 20, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor('FBC52C')),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(padding: const EdgeInsets.only(
                                  top: 50, right: 20)),
                              Text(
                                '主な症状',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Container(
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 40,
                                left: 20,
                                right: 20)),
                            Text(
                              symptomList[index].list,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                  },
                  childCount: symptomList.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 20, right: 20, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor('FBC52C')),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(padding: const EdgeInsets.only(
                                  top: 50, right: 20)),
                              Text(
                                '主な原因',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Container(
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 40,
                                left: 20,
                                right: 20)),
                            Text(
                              causeList[index].list,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                  },
                  childCount: causeList.length,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 50, left: 20, right: 20, bottom: 30),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: HexColor('FBC52C')),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Padding(padding: const EdgeInsets.only(
                                  top: 50, right: 20)),
                              Text(
                                '主な治療法',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                  },
                  childCount: 1,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return
                      Container(
                        child: Row(
                          children: [
                            Padding(padding: const EdgeInsets.only(top: 40,
                                left: 20,
                                right: 20)),
                            Text(
                              treatmentList[index].list,
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      );
                  },
                  childCount: treatmentList.length,
                ),
              ),
            ]
        ),
      ),

      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            print(bool);
            (bool != true) ?
            {
              addSymptom(),
              bool = true
            }
                :
            bool = false;
            setState(() {});
          },
          tooltip: 'Increment',
          child: (bool != true) ?
          Icon(
            Icons.favorite,
            color: Colors.white,
          )
              :
          Icon(
            Icons.favorite,
            color: Colors.pinkAccent,
          )
      ),
    );
  }
}




