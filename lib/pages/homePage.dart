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

enum InteractMode { def, searching }

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  static List<PassEntry> Pairs = [];
  static HomePageState _page;
  static Widget emptyList;

  AnimationController _controller;

  Animation<Offset> _offsetAnimation;
  List<PassField> passFieldsWidgets;
  InteractMode mode = InteractMode.def;

  String searchInquery;

  List<PassEntry> entriesFound = List<PassEntry>();

  int viewItemsCount;
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
    Widget upperPart;
    switch (mode) {
      case InteractMode.def:
      viewItemsCount = Pairs.length;
        upperPart = Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        LocalizationTool.of(context).home,
                        style: TextStyle(fontSize: 32, color: Colors.white),
                      ))),
              Pairs.length != 0
                  ? Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          onPressed: () {
                            mode = InteractMode.searching;
                            setState(() {});
                          },
                        ),
                      ))
                  : Container(),
            ]);
        break;
      case InteractMode.searching:
      viewItemsCount = entriesFound.length;
        upperPart = SafeArea(
            child: Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                    child: Row(
                  children: <Widget>[
                    Expanded(
                        child: FocusScope(
                            child: TextField(
                                autofocus: true,
                                onChanged: searchUpdate,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2
                                    .copyWith(color: Colors.white),
                                decoration: InputDecoration(
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodyText2
                                        .copyWith(
                                            color: Color.fromARGB(
                                                150, 255, 255, 255)),
                                    hintText: LocalizationTool.of(context)
                                        .entrySearchHint,
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Theme.of(context).accentColor),
                                    ))))),
                    Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: IconButton(
                          icon: Icon(Icons.cancel, color: Colors.white),
                          onPressed: () {
                            mode = InteractMode.def;
                            setState(() {});
                          },
                        ))
                  ],
                ))));
        break;
    }

    return Column(children: <Widget>[
      SafeArea(child: upperPart),
      Pairs.length == 0
          ? Expanded(child: emptyList)
          : !loading
              ? Expanded(
                  child: ListView.builder(
                      itemCount: viewItemsCount,
                      itemBuilder: (BuildContext context, int index) {
                        switch (mode) {
                          case InteractMode.def:
                            return PassField(Pairs[index], GlobalKey());
                            break;
                          case InteractMode.searching:
                            return PassField(entriesFound[index], GlobalKey());
                            break;
                        }
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
    callback();
    _page.setState(() => _page.loading = false);
  }

  // SEARCH
  void searchUpdate(String changed) {
    searchInquery = changed;
    entriesFound = search(searchInquery);
    setState((){});
  }
  List<PassEntry> search(String inquery){
    List<PassEntry> result = List<PassEntry>();
    for(int i = 0; i < Pairs.length; i++){
      var curPair = Pairs[i];
      if (concur(inquery, curPair)){
        result.add(curPair);
      }
    }
    return result;
  }
  bool concur(String inquery, PassEntry entry){
    var username = entry.getUsername();
    var emailValue = entry.getEmail();
    var email = emailValue == null ? "" : emailValue;
    var title = entry.getTitle();
    // TODO: Implement a searching mechanism for icons
    var usernameConcur = username.contains(inquery);
    var emailConcur = email != "" ? email.contains(inquery) : false ;
    var titleConcur = title.contains(inquery);
    return usernameConcur || emailConcur|| titleConcur; 
    
    
    

  }
}
