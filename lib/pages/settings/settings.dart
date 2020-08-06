import 'package:PassPuss/localization.dart';
import 'package:PassPuss/pages/settings/ForYou.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Notification.dart';
import 'Privacy.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  var settingsIcon = Icon(
    Icons.settings,
    size: 32,
    color: Colors.white,
  );

  var notifcationIcon =
      Icon(Icons.notifications, color: Colors.yellowAccent, size: 32);

  var recommendationIcon = Icon(Icons.thumb_up, color: Colors.indigo, size: 32);

  var privacyIcon = Icon(Icons.lock, color: Colors.blueAccent, size: 32);

  @override
  Widget build(BuildContext context) {
    var listTileColor = Theme.of(context).cardColor;
    return Scaffold(
        body: Column(
      children: <Widget>[
        SafeArea(
          child: Row(children: <Widget>[
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      LocalizationTool.of(context).settings,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ))),
            Padding(
              child: Hero(tag: "settings", child: settingsIcon),
              padding: EdgeInsets.only(left: 10),
            )
          ]),
        ),
        Column(
          children: <Widget>[
            // ADD THIS CODE TO CREATE A NEW SETTINGS PART:
            //Row(children: <Widget>[

            //],
            // NOTIFICATIONS TAB

            Card(
              color: listTileColor,
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationSettingsTab())),
                leading: Hero(tag: "notif", child: notifcationIcon),
                title: Text(
                  LocalizationTool.of(context).notifications,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            // RECOMMENDATION TAB

            Card(
              color: listTileColor,
              child: ListTile(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForYouSettingsTab())),
                leading: Hero(tag: "forYou", child: recommendationIcon),
                title: Text(
                  LocalizationTool.of(context).forYou,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
            Card(
              color: listTileColor,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacySettingsTab()));
                },
                leading: Hero(tag: "privacy", child: privacyIcon),
                title: Text(
                  LocalizationTool.of(context).privacy,
                  style: Theme.of(context)
                      .textTheme
                      .headline6
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }
}

class SettingsManager {
  static changePref<T>(String key, T value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    switch (T) {
      case int:
        sharedPreferences.setInt(key, value as int);
        break;
      case String:
        sharedPreferences.setString(key, value as String);
        break;
      case bool:
        sharedPreferences.setBool(key, value as bool);
        break;
      case double:
        sharedPreferences.setDouble(key, value as double);
        break;
    }
  }

  static Future<Object> getPref(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}

class SettingsTab {
  void initSettings() {}
}
