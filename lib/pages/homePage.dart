import 'dart:isolate';

import 'package:PassPuss/localization.dart';
import 'package:flutter/material.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:PassPuss/PassFieldItem.dart';

import 'package:PassPuss/NewPassEntry.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static List<PassEntry> Pairs = [];
  static HomePageState _page;
  static Widget emptyList;

  AnimationController _controller;

  Animation<Offset> _offsetAnimation;
  List<PassField> passFieldsWidgets;
  @override
  void initState() {
    super.initState();
    assignPairs();

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _offsetAnimation = Tween<Offset>(
            begin: Offset.zero, end: const Offset(1.5, 0.0))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  bool loading = true;
  @override
  Widget build(BuildContext context) {
    
    
    emptyList = SafeArea(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60),
                      child: Row(
                        children: <Widget>[
                          Center(
                            child: Icon(Icons.lock_outline,
                                size: 100,
                                color: Theme.of(context).accentColor),
                          ),
                          Center(
                            child: Icon(Icons.list,
                                size: 100,
                                color: Theme.of(context).accentColor),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        LocalizationTool.of(context).passEntriesEmpty,
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            .copyWith(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ))));
    _page = this;
    return Column(children: <Widget>[
      SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                LocalizationTool.of(context).home,
                style: TextStyle(fontSize: 32, color: Colors.white),
              )),
        ),
      ),
      Pairs.length == 0
          ? Expanded(child: emptyList)
          : !loading
              ? Expanded(
                  child: ListView.builder(
                      itemCount: Pairs.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PassField(Pairs[index], GlobalKey());
                      }))
              : Center(child: CircularProgressIndicator()),
      loading
          ? Container()
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NewPassEntryPage()));
              },
            )
    ]);
  }

  

  assignPairs() async {
    loading = true;
    var pairs = await DBProvider.DB.getPassEntries();
    setState(() {
      Pairs = pairs;
      loading = false;
    });
  }

  static changeDataset(VoidCallback callback) {
    _page.loading = true;
    _page.setState(callback);
  }
}
