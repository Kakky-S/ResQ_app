// お気に入りに入れた症状の情報を表示する用のファイル
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_chatbot_app/color/color.dart';
import 'package:resq_chatbot_app/favoriteSymptom/favoriteSymptom.dart';

class FavoriteSymptom extends StatefulWidget {
  final String paramText;

  FavoriteSymptom({Key key, this.paramText}) : super(key: key);

  @override
  _FavoriteSymptom createState() => _FavoriteSymptom();
}

class _FavoriteSymptom extends State<FavoriteSymptom> {
  // 症状の原因を格納するList
  List<favoriteSymptomData> causeList = [];

  // 症状を格納するList
  List<favoriteSymptomData> symptomList = [];

  // 治療方法を格納するList
  List<favoriteSymptomData> treatmentList = [];

  // タイトルを格納するList
  List<favoriteSymptomData> setlist = [];

  // List<favoriteSymptomData> textList = [];

  // 症状の特徴を格納するList
  List<favoriteSymptomData> featureList = [];

  // どこに行くべきかを格納するList
  List<favoriteSymptomData> whereList = [];
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
      setlist.add(favoriteSymptomData(
        title: docs['title'], //doc.data()['test']
        //title: doc['test']
      ));
    });

    // 原因を取得
    cause.forEach((doc) {
      causeList.add(favoriteSymptomData(
        list: doc,
      ));
    });
    // 症状を取得
    symptom.forEach((doc) {
      symptomList.add(favoriteSymptomData(
        list: doc,
      ));
    });
    // 治療方法を取得
    treatment.forEach((doc) {
      treatmentList.add(favoriteSymptomData(
        list: doc,
      ));
    });

    // 症状の特徴を取得
    feature.forEach((doc) {
      featureList.add(favoriteSymptomData(
        multiple: doc,
      ));
    });

    // どこに行くべきかを取得
    where.forEach((doc) {
      whereList.add(favoriteSymptomData(
        multiple: doc,
      ));
    });

    setState(() {});
    print(setlist[0]);
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
    );
  }
}

