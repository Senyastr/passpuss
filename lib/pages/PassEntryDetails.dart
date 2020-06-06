import 'package:PassPuss/pages/editEntryPage.dart';
import 'package:PassPuss/passentry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import 'package:PassPuss/localization.dart';

import '../main.dart';

class PassEntryDetails extends StatefulWidget {
  PassEntry entry;

  @override
  State<StatefulWidget> createState() {
    return PassEntryDetailsState(entry);
  }

  PassEntryDetails(this.entry);
}

class PassEntryDetailsState extends State<PassEntryDetails> {
  PassEntry entry;
  Widget mainInfo;
  Widget timeBlock;

  Icon iconLocked;
  Icon iconOpened;

  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;
  var username;
  var password;
  DateFormat timeCreated;
  @override
  void initState() {
    super.initState();
    username = entry.getUsername();
    password = entry.getPassword();
  }

  @override
  Widget build(BuildContext context) {
    timeCreated = DateFormat(DateFormat.YEAR_MONTH_DAY,
            LocalizationTool.of(context).locale.toLanguageTag())
        .add_Hm();
    passwordShowState = Icon(Icons.lock,
        key: passwordStateKey, color: Theme.of(context).accentColor);
    iconLocked = Icon(Icons.lock,
        key: passwordStateKey, color: Theme.of(context).accentColor);
    iconOpened = Icon(Icons.lock_open,
        key: passwordStateKey, color: Theme.of(context).accentColor);
    mainInfo = Column(children: <Widget>[
      Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                LocalizationTool.of(context).details,
                style: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(color: Colors.white),
              ))),
      Align(
          alignment: Alignment.topLeft,
          child: Row(children: <Widget>[
            Padding(
                child: SvgPicture.asset(entry.getIconId()),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
            Text(entry.getTitle(),
                style: TextStyle(fontSize: 20, color: Colors.white)),
          ])),
      Align(
          alignment: Alignment.bottomLeft,
          child: Row(children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
              child: Icon(Icons.person, color: Theme.of(context).accentColor),
            ),
            Padding(
                child: Text(username,
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                padding: EdgeInsets.only(top: 10, bottom: 10, left: 18)),
            Padding(
                padding: EdgeInsets.all(1),
                child: IconButton(
                    icon: Icon(Icons.content_copy,
                        color: Theme.of(context).accentColor),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: username));
                      PassEntriesPage.scaffoldKey.currentState.showSnackBar(
                          SnackBar(
                              content: Text(LocalizationTool.of(context)
                                  .usernameCopied)));
                    })),
            Padding(
                padding: EdgeInsets.all(5),
                child: Icon(
                  Icons.text_rotation_none,
                  color: Theme.of(context).accentColor,
                )),
            Padding(
                padding: EdgeInsets.all(5),
                child: Text(username.length.toString(),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.white)))
          ])),
      Align(
        alignment: Alignment.bottomLeft,
        child: Row(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: IconButton(
                icon: (isPasswordShown) ? iconOpened : iconLocked,
                onPressed: () {
                  setState(() {
                    isPasswordShown = !isPasswordShown;
                  });
                },
              )),
          Padding(
              padding: EdgeInsets.only(
                left: 6,
                top: 10,
                bottom: 10,
              ),
              child: Text((isPasswordShown) ? password : hidePassword(password),
                  style: TextStyle(fontSize: 20, color: Colors.white))),
          Padding(
              padding: EdgeInsets.all(1),
              child: IconButton(
                  icon: Icon(Icons.content_copy,
                      color: Theme.of(context).accentColor),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: password));
                    PassEntriesPage.scaffoldKey.currentState.showSnackBar(
                        SnackBar(
                            content: Text(
                                LocalizationTool.of(context).passwordCopied)));
                  })),
          Padding(
              padding: EdgeInsets.all(5),
              child: Icon(
                Icons.text_rotation_none,
                color: Theme.of(context).accentColor,
              )),
          Padding(
              padding: EdgeInsets.all(5),
              child: Text(password.length.toString(),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white)))
        ]),
      ),
    ]);
    timeBlock = Column(children: <Widget>[
      Align(
        alignment: Alignment.centerLeft,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: Text(
              LocalizationTool.of(context).time,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
            )),
      ),
      AlignCenterLeft(
          Row(children: <Widget>[
            Icon(Icons.edit, color: Theme.of(context).accentColor),
            Padding(
              padding: EdgeInsets.only(left: 10),
              child: Text(timeCreated.format(entry.createdTime),
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white)),
            )
          ]),
          EdgeInsets.only(
            left: 20,
            top: 10,
          ))
    ]);
    var editButton = FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => EditEntryPage(entry)));
        },
        child: Icon(Icons.edit));
    return Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SafeArea(
            child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    LocalizationTool.of(context).passwordDetailsPage,
                    style: Theme.of(context)
                        .textTheme
                        .headline5
                        .copyWith(color: Colors.white),
                  )),
            ),
            mainInfo,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(color: Colors.white),
            ),
            Expanded(child: timeBlock),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(10),
                child:
                    Align(alignment: Alignment.bottomRight, child: editButton),
              ),
            )
          ],
        )));
  }

  PassEntryDetailsState(this.entry);

  Widget AlignCenterLeft(Widget text, EdgeInsets insets) {
    return Padding(
      padding: insets,
      child: Align(alignment: Alignment.centerLeft, child: text),
    );
  }
}

String hidePassword(String password) {
  String result;
  StringBuffer buffer = StringBuffer();
  for (int i = 0; i < password.length; i++) {
    buffer.write("*");
  }
  result = buffer.toString();
  return result;
}
