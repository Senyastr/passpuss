import 'package:PassPuss/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingsPageState();
  }
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var listTileColor = Theme.of(context).cardColor;
    return Scaffold(
        body: Column(
      children: <Widget>[
        SafeArea(
            child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      LocalizationTool.of(context).settings,
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    )))),
        Column(
          children: <Widget>[
            // ADD THIS CODE TO CREATE A NEW SETTINGS PART:
            //Row(children: <Widget>[

            //],
            // NOTIFICATIONS TAB

            Card(
              color: listTileColor,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationSettingsTab()));
                },
                leading: Icon(Icons.notifications,
                    color: Colors.yellowAccent, size: 32),
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
            GestureDetector(
              onTap: () {
                // TODO: Implement recommendation tab
              },
              child: Card(
                color: listTileColor,
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.thumb_up, color: Colors.indigo, size: 32),
                  title: Text(
                    LocalizationTool.of(context).forYou,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white),
                  ),
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

  static Object getPref(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.get(key);
  }
}

class NotificationSettingsTab extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return NotificationSettingsTabState();
  }
}

class NotificationSettingsTabState extends State<NotificationSettingsTab> {
  bool turnedNotifcation;
  String expirationDays;
  final List<String> expirationItems = [
    "1 month",
    "2 weeks",
    "1 week",
  ];
  static const String notifcationsOn = "notificationsOn";
  static const String passwordEntryExpiration = "passwordEntryExpirationDays";
  @override
  void initState() {
    super.initState();
    initSettings();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Padding(
            padding: EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    LocalizationTool.of(context).notifications,
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Colors.white),
                  ),
                  Container(
                      width: 60,
                      height: 40,
                      child: Switch(
                        onChanged: (bool changed) {
                          setState(() {
                            turnedNotifcation = changed;
                            SettingsManager.changePref(notifcationsOn,
                                changed); // TODO: USE THIS SHIT TO SCHEDULE NOTIFCATIONS
                            // print(SettingsManager.getPref(notifcationsOn));
                          });
                        },
                        value: turnedNotifcation,
                      ))
                ])),
        SafeArea(
            child: Column(
          children: <Widget>[
            // !!!! HERE ARE SETTINGS !!!!
            // Password Expiration Notification Days
            ListTile(
              title: Text(
                LocalizationTool.of(context)
                    .settingsNotificationPasswordExpirationDays,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.white),
              ),
              trailing: DropdownButton<String>(
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1
                      .copyWith(color: Colors.white),
                  value: expirationDays,
                  onChanged: (String changed) async {
                    setState(() {
                      expirationDays = changed;
                    });
                    switch (changed) {
                      case "1 month":
                        {
                          SettingsManager.changePref(
                              passwordEntryExpiration, 30); // 30 days = 1 month
                          break;
                        }
                      case "2 weeks":
                        {
                          SettingsManager.changePref(
                              passwordEntryExpiration, 14);
                          break;
                        }
                      case "1 week":
                        {
                          SettingsManager.changePref(
                              passwordEntryExpiration, 7);
                        }
                    }
                  },
                  items: expirationItems.map<DropdownMenuItem<String>>((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList()),
            ),
            Column(
              children: <Widget>[
                Text(
                  LocalizationTool.of(context).soon,
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(color: Colors.white),
                ),
                Icon(Icons.watch_later,
                    size: 50, color: Theme.of(context).accentColor),
              ],
            ),
          ],
        )),
      ],
    )));
  }

  void initSettings() async {
    // NOTIFCATION ON OR OFF IN GENERAL
    dynamic temp = (await SettingsManager.getPref(notifcationsOn)) as bool;
    turnedNotifcation = (temp == null ? true : temp);

    temp = (await SettingsManager.getPref(passwordEntryExpiration)) as int;
    switch (temp) {
      case 30:
        {
          temp = "1 month";
          break;
        }
      case 14:
        {
          temp = "2 weeks";
          break;
        }
      case 7:
        {
          temp = "1 week";
          break;
        }
    }
    expirationDays = (temp == null ? "1 month" : temp);
    setState(() {});
  }
}
