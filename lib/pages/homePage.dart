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

class HomePageState extends State<HomePage> {
  static List<PassEntry> Pairs = [];
  static HomePageState _page;
  static Widget emptyList;

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
      Expanded(
          child: Pairs.length == 0 ? emptyList :
          ListView.builder(
              itemCount: Pairs.length,
              itemBuilder: (BuildContext context, int index) {
                return new PassField(Pairs[index], GlobalKey());
              })
      ),

      FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => NewPassEntryPage()));
        },
      )
    ]);
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      assignPairs();
    });
  }

  assignPairs() async {
    var pairs = await DBProvider.DB.getPassEntries();
    setState(() {
      Pairs = pairs;
    });
  }

  static changeDataset(VoidCallback callback) {
    _page.setState(callback);
  }
}
