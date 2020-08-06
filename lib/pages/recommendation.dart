import 'package:PassPuss/pages/homePage.dart';
import 'package:PassPuss/pages/settings/ForYou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:PassPuss/localization.dart';
import 'package:PassPuss/passentry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tuple/tuple.dart';

enum PasswordProblem {
  Expired,
  OnlyLetters,
  OnlyNumbers,
  LessThan8,
  RepeatChars,
  Idiot
}

class RecommendationTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RecommendationTabState();
  }
}

class RecommendationTabState extends State<RecommendationTab> {
  List<RecommendationItem> items;

  List<Tuple3<PassEntry, PasswordProblem, MessageType>>
      recSet; // passEntry, message, messageType

  @override
  void initState() {
    analyzing = true;
    analyze().then((recSet) {
      this.recSet = recSet;
      setState(() {
        analyzing = false;
      });
    });
  }

  bool analyzing;
  @override
  Widget build(BuildContext context) {
    if (analyzing == false) {
      items = buildItems();
    }
    var emptyView = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
            padding: EdgeInsets.only(top: 30),
            child: Icon(Icons.verified_user,
                size: 100, color: Theme.of(context).accentColor)),
        Padding(
          padding: EdgeInsets.all(15),
          child: Center(
            child: Text(
              LocalizationTool.of(context).recommendationEmpty,
              style: Theme.of(context)
                  .textTheme
                  .headline5
                  .copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        )
      ],
    );

    return Column(children: <Widget>[
      SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                LocalizationTool.of(context).forYou,
                style: TextStyle(fontSize: 32, color: Colors.white),
              )),
        ),
      ),
      !analyzing
          ? items.length == 0
              ? Center(child: emptyView)
              : Expanded(
                  child: ListView.separated(
                      separatorBuilder: (context, index) => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(color: Colors.white)),
                      itemCount: items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return items[index];
                      }))
          : CircularProgressIndicator()
    ]);
  }

  Future<List<Tuple3<PassEntry, PasswordProblem, MessageType>>>
      analyze() async {
    // Here we're getting RecommendationItems(passwords that should be changed)
    var pairs = HomePageState.Pairs;
    var recommendSet = List<Tuple3<PassEntry, PasswordProblem, MessageType>>();
    // HERE WE ANALYZE THE TIME THAT HAS PASSED SINCE THE PASSENTRYIES WERE CREATED
    pairs.forEach((f) async {
      var filtered = await filter(f);
      if (filtered != null) {
        recommendSet.add(filtered);
      }
    });
    return recommendSet;
  }

  Future<Tuple3<PassEntry, PasswordProblem, MessageType>> filter(
      PassEntry f) async {
    var password = f.getPassword();
    var timeDifference = (f.createdTime.difference(DateTime.now()));
    if (timeDifference.inDays > 31) {
      return new Tuple3(f, PasswordProblem.Expired, MessageType.recommendation);
    } else {
      // HERE WE ANALYZE THE PASSWORDS(PASSWORDS SAFETY)

      // WE ANALYZE ONLY LOWER-CASED PASSWORDS
      // 1. The password has the length less than 8 characters.
      if (password.length < 8) {
        return new Tuple3(
            f, PasswordProblem.LessThan8, MessageType.higlyRecommended);
      }
      // 2. The password has repeated characters.
      if (hasRepeatedCharacters(password)) {
        return new Tuple3(f, PasswordProblem.RepeatChars, MessageType.warning);
      }
      // 3. The password is one of these:
      // qwertyui
      // iuytrewq
      // 12345678
      // 87654321

      if (hasIdiotPasswords(password)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = prefs.getBool(ForYouSettingsTabState.qwertyKey);
        var setting = temp == null ? true : temp;
        if (setting) {
          return new Tuple3(
              f, PasswordProblem.Idiot, MessageType.higlyRecommended);
        }
      }
      // 4. The password hasn't used any letters, but numbers
      if (hasOnlyLetters(password)) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var temp = prefs.getBool(ForYouSettingsTabState.onlyLettersSetting);
        var setting = temp == null ? true : temp;
        if (setting) {
          return new Tuple3(
              f, PasswordProblem.OnlyLetters, MessageType.recommendation);
        }
      }
      // 5. Vice versa, the password used only letters.
      if (hasOnlyNumbers(password)) {
        return new Tuple3(
            f, PasswordProblem.OnlyNumbers, MessageType.recommendation);
      }
    }
    return null;
  }

  List<RecommendationItem> buildItems() {
    var result = List<RecommendationItem>();
    for (int i = 0; i < this.recSet.length; i++) {
      result.add(RecommendationItem(
          recSet[i].item1, recSet[i].item2, recSet[i].item3));
    }
    return result;
  }
}

bool hasOnlyNumbers(String password) {
  var list = password.split("");

  for (int i = 0; i < list.length; i++) {
    var number = int.tryParse(list[i]);
    if (number == null) {
      return false;
    }
  }
  return true;
}

bool hasOnlyLetters(String password) {
  var list = password.split("");

  for (int i = 0; i < list.length; i++) {
    var number = int.tryParse(list[i]);
    if (number != null) {
      return false;
    }
  }
  return true;
}

bool hasIdiotPasswords(String password) {
  var pass = password.toLowerCase();
  List<String> idiotPasswords = [
    "qwertyui",
    "iuytrewq",
    "12345678",
    "87654321",
  ];
  for (int i = 0; i < idiotPasswords.length; i++) {
    var idiotPass = idiotPasswords[i];
    if (pass == idiotPass) {
      return true;
    }
  }
  return false;
}

bool hasRepeatedCharacters(String password) {
  var str = password.toLowerCase();
  var list = str.split("");
  String lastChar = "";
  for (int i = 0; i < list.length; i++) {
    var char = list[i];
    if (char == lastChar) {
      return true;
    }
    lastChar = char;
  }
  return false;
}

enum MessageType { higlyRecommended, warning, recommendation }

// ignore: must_be_immutable
class RecommendationItem extends StatefulWidget {
  PasswordProblem message;
  PassEntry entry;

  MessageType messageType;

  @override
  State<StatefulWidget> createState() {
    return RecommendationItemState(entry, message, messageType);
  }

  RecommendationItem(this.entry, this.message, this.messageType);
}

class RecommendationItemState extends State<RecommendationItem> {
  PasswordProblem message;
  PassEntry entry;
  MessageType messageType;

  Icon iconLocked;
  Icon iconOpened;

  @override
  void initState() {
    passwordShowState = Icon(Icons.lock, key: passwordStateKey);
    iconLocked = Icon(Icons.lock, key: passwordStateKey);
    iconOpened = Icon(Icons.lock_open, key: passwordStateKey);
  }

  var passwordShowState;
  var passwordStateKey = GlobalKey();
  var isPasswordShown = false;

  var warning_color = Colors.yellow[600];
  var error_color = Colors.red;
  var recommendation_color = Colors.blue;

  var error_cardColor = Color.fromARGB(255, 194, 83, 91); // dark blue
  var warning_cardColor = Color.fromARGB(255, 151, 168, 89);
  var recommendation_cardColor = Color.fromARGB(255, 35, 55, 82);

  @override
  Widget build(BuildContext context) {
    String textMessage;

    switch (message) {
      case PasswordProblem.Expired:
        textMessage = LocalizationTool.of(context).passwordExpired;
        break;
      case PasswordProblem.OnlyLetters:
        textMessage = LocalizationTool.of(context).passwordLetters;
        break;
      case PasswordProblem.OnlyNumbers:
        textMessage = LocalizationTool.of(context).passwordNumbers;
        break;
      case PasswordProblem.LessThan8:
        textMessage = LocalizationTool.of(context).passwordChars;
        break;
      case PasswordProblem.RepeatChars:
        textMessage = LocalizationTool.of(context).passwordRepeatChars;
        break;
      case PasswordProblem.Idiot:
        textMessage = LocalizationTool.of(context).passwordIdiot;
        break;
    }
    Icon messageIcon;
    double iconsize = 50;
    Color textColor;
    Color cardColor;
    switch (messageType) {
      case MessageType.higlyRecommended:
        messageIcon = Icon(
          Icons.error,
          color: error_color,
          size: iconsize,
        );
        textColor = error_color;
        cardColor = error_cardColor;
        break;
      case MessageType.warning:
        messageIcon = Icon(Icons.warning, color: warning_color, size: iconsize);
        textColor = warning_color;
        cardColor = warning_cardColor;
        break;
      case MessageType.recommendation:
        messageIcon =
            Icon(Icons.warning, color: recommendation_color, size: iconsize);
        textColor = recommendation_color;
        cardColor = recommendation_cardColor;
        break;
    }
    return new Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 5, right: 5),
              child: Card(
                  child: Row(children: <Widget>[
                Expanded(
                    child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(textMessage,
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                            )))),
                Padding(padding: EdgeInsets.all(7), child: messageIcon)
              ]))),
          Card(
              color: cardColor,
              child: Column(children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(children: <Widget>[
                      Padding(
                          child: SvgPicture.asset(entry.getIconId()),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10)),
                      Text(entry.getTitle(),
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                    ])),
                Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 27, top: 10, bottom: 10),
                        child: Icon(Icons.person),
                      ),
                      Padding(
                          child: Text(entry.getUsername(),
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                          padding: EdgeInsets.only(
                            left: 18,
                            top: 10,
                            bottom: 10,
                          )),
                      Padding(
                          padding: EdgeInsets.all(1),
                          child: IconButton(
                              icon: Icon(Icons.content_copy),
                              onPressed: () {
                                Clipboard.setData(
                                    ClipboardData(text: entry.getUsername()));
                                Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "The password is copied to the clipboard.")));
                              })),
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
                        padding: EdgeInsets.only(left: 6, top: 10, bottom: 10),
                        child: Text(
                            (isPasswordShown) ? entry.getPassword() : "******",
                            style:
                                TextStyle(fontSize: 20, color: Colors.white))),
                    Padding(
                        padding: EdgeInsets.all(1),
                        child: IconButton(
                            icon: Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(
                                  ClipboardData(text: entry.getPassword()));
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "The password is copied to the clipboard.")));
                            })),
                  ]),
                ),
              ])),
        ]));
  }

  RecommendationItemState(this.entry, this.message, this.messageType);
}
