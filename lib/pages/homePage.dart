import 'package:PassPuss/pages/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:PassPuss/Database.dart';
import "package:PassPuss/passentry.dart";
import 'package:flutter_svg/flutter_svg.dart';
import 'package:PassPuss/PassFieldItem.dart';

import 'package:PassPuss/NewPassEntry.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  static List<PassEntry> Pairs = [];
  static HomePageState _page;

  @override
  Widget build(BuildContext context) {
    _page = this;
    return Column(children: <Widget>[
      Expanded(
          child: ListView.builder(
              itemCount: Pairs.length,
              itemBuilder: (BuildContext context, int index) {
                return new PassField(Pairs[index], GlobalKey());
              })),
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
