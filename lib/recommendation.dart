import 'package:PassPuss/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'passentry.dart';

class RecommendationTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new RecommendationTabState();
  }
}

class RecommendationTabState extends State<RecommendationTab> {
  List<RecommendationItem> items;

  @override
  void initState() {
    items = analyze();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return Column(

        children: <Widget>[
          Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(color: Colors.white)),
              itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return items[index];
                  }
              ))
        ]);
  }

  List<RecommendationItem> analyze() {
    // TODO: Here we're getting RecommendationItems(passwords that should be changed)
    // TODO: Make a field for PassField with the date of creation
    var pairs = HomePageState.Pairs;
    var recommendItems = List<RecommendationItem>();
    // HERE WE ANALYZE THE TIME THAT HAS PASSED SINCE THE PASSENTRYIES WERE CREATED
    pairs.forEach((f) {
      var filtered = filter(f);
      if (filtered != null) {
        recommendItems.add(filtered);
      }
    });
    return recommendItems;
  }

  RecommendationItem filter(PassEntry f) {
    var password = f.getPassword();
    var timeDifference = (f.createdTime.difference(DateTime.now()));
    if (timeDifference.inDays > 31) {
      return new RecommendationItem(
          f,
          "You should consider generating another password for this entry.",
          MessageType.recommendation);
    }
    else {
      // HERE WE ANALYZE THE PASSWORDS(PASSWORDS SAFETY)

      // WE ANALYZE ONLY LOWER-CASED PASSWORDS
      // 1. The password has the length less than 8 characters.
      if (password.length < 8) {
        return new RecommendationItem(
            f,
            "This password has length less than 8 characters long. Generate another one.",
            MessageType.higlyRecommended);
      }
      // 2. The password has repeated characters.
      if (hasRepeatedCharacters(password)) {
        return new RecommendationItem(
            f,
            "This password has repeated characters. Generate another one.",
            MessageType.warning);
      }
      // 3. The password is one of these:
      // qwertyui
      // iuytrewq
      // 12345678
      // 87654321

      if (hasIdiotPasswords(password)) {
        return new RecommendationItem(
            f,
            "This password is widely used in the Internet and can be brute-forced. You should generate another one",
            MessageType.higlyRecommended);
      }
      // 4. The password hasn't used any letters, but numbers
      if (hasOnlyLetters(password)) {
        return new RecommendationItem(
            f,
            "This password contains letters only. Consider generating a new one.",
            MessageType.recommendation
        );
      }
      // 5. Vice versa, the password used only letters.
      if (hasOnlyNumbers(password)) {
        return new RecommendationItem(
            f,
            "This password contains numbers only. Consider generating a new one.",
            MessageType.recommendation

        );
      }
    }
    return null;
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
enum MessageType {
  higlyRecommended,
  warning,
  recommendation
}
class RecommendationItem extends StatefulWidget {
  String message;
  PassEntry entry;

  MessageType messageType;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RecommendationItemState(entry, message, messageType);
  }

  RecommendationItem(this.entry, this.message, this.messageType);
}

class RecommendationItemState extends State<RecommendationItem> {
  String message;
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
        messageIcon = Icon(
            Icons.warning,
            color: warning_color,
            size: iconsize
        );
        textColor = warning_color;
        cardColor = warning_cardColor;
        break;
      case MessageType.recommendation:
        messageIcon = Icon(
            Icons.warning,
            color: recommendation_color,
            size: iconsize
        );
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
                            child: Text(
                                message,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: 18,
                                ))
                        )),
                    Padding(
                        padding: EdgeInsets.all(7),
                        child: messageIcon)
                  ])
              )
          ),
          Card(
              color: cardColor,
              child: Column(children: <Widget>[
                Align(
                    alignment: Alignment.topLeft,
                    child: Row(children: <Widget>[
                      Padding(
                          child: SvgPicture.asset(entry.getIconId()),
                          padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
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
                              style: TextStyle(fontSize: 20, color: Colors
                                  .white)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18, vertical: 10))
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
                        padding: EdgeInsets.symmetric(
                            horizontal: 6, vertical: 10),
                        child: Text(
                            (isPasswordShown) ? entry.getPassword() : "******",
                            style: TextStyle(fontSize: 20, color: Colors
                                .white))),
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
              ]
              )),

        ]));
  }

  RecommendationItemState(this.entry, this.message, this.messageType);
}
